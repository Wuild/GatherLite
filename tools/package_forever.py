#!/usr/bin/env python3
"""Validate and build the Forever-only release package."""

import argparse
import hashlib
import json
from pathlib import Path, PurePosixPath
import posixpath
import re
import zipfile

TOC = "GatherLite.toc"
VERSION_PATTERN = r"(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)(?:-forever(?:\.[1-9][0-9]*)?)?"
RUNTIME_DIRS = ("scripts", "plugins", "icons")
ROOT_FILES = (TOC, "LICENSE")
RUNTIME_EXTENSIONS = {".lua", ".xml", ".toc", ".tga", ".blp", ".md", ".txt"}


def validate_payload(payload, version):
    """Check the actual packaged load chain, including case-sensitive paths."""
    toc = payload[TOC].decode("utf-8")
    for key, value in {"Title": "GatherLite", "Interface": "16001",
                       "Version": version, "X-Curse-Project-ID": "334918"}.items():
        if not re.search(rf"^## {re.escape(key)}: {re.escape(value)}\s*$", toc, re.M):
            raise ValueError(f"Incorrect or missing TOC {key}: expected {value}")
    if "plugins/database/data/forever.lua" not in payload:
        raise ValueError("Missing Forever database")
    if {p for p in payload if p.startswith("plugins/database/data/")} != {"plugins/database/data/forever.lua"}:
        raise ValueError("Release must contain only the Forever database")

    visited = set()

    def visit(path):
        if path not in payload:
            raise ValueError(f"Missing packaged dependency: {path}")
        if path in visited:
            return
        visited.add(path)
        if path == TOC:
            refs = [line.strip() for line in toc.splitlines()
                    if line.strip() and not line.lstrip().startswith("#")]
        elif path.endswith(".xml"):
            xml = re.sub(r"<!--.*?-->", "", payload[path].decode("utf-8"), flags=re.S)
            refs = re.findall(r'<(?:Script|Include)\b[^>]*\bfile=["\']([^"\']+)["\']', xml)
        else:
            return
        for ref in refs:
            visit(posixpath.normpath(str(PurePosixPath(path).parent / ref.replace("\\", "/"))))

    visit(TOC)


def package_sources(root):
    """Select repository-relative files; exclusions win over includes."""
    rules_path = root / "package-rules.json"
    if not rules_path.exists():
        sources = {root / path for path in ROOT_FILES}
        for directory in RUNTIME_DIRS:
            sources.update(path for path in (root / directory).rglob("*")
                           if path.is_file() and path.suffix.lower() in RUNTIME_EXTENSIONS)
    else:
        try:
            rules = json.loads(rules_path.read_text(encoding="utf-8-sig"))
        except (ValueError, UnicodeError):
            raise ValueError("Invalid JSON in package-rules.json") from None
        if not isinstance(rules, dict) or set(rules) != {"include", "exclude"}:
            raise ValueError("package-rules.json requires include and exclude arrays only")
        for key in ("include", "exclude"):
            if not isinstance(rules[key], list):
                raise ValueError(f"Package {key} must be an array of glob patterns")
            for pattern in rules[key]:
                if (not isinstance(pattern, str) or not pattern or
                        pattern.startswith("/") or "\\" in pattern or ":" in pattern or
                        ".." in pattern.split("/")):
                    raise ValueError("Package patterns must be relative paths using forward slashes")
        sources = {path for pattern in rules["include"] for path in root.glob(pattern)
                   if path.is_file()}
        excluded = {path for pattern in rules["exclude"] for path in root.glob(pattern)}
        sources = {path for path in sources if path not in excluded
                   and not any(parent in excluded for parent in path.parents if parent != root)}
    # Credentials, Git metadata, and caches must never ship, even with broad globs.
    sources = {path for path in sources
               if not any(part.startswith(".") or part == "__pycache__"
                          for part in path.relative_to(root).parts)}
    for required in ROOT_FILES:
        if root / required not in sources:
            raise ValueError(f"Missing required packaged file: {required}")
    return sorted(sources)


def prepare_package(root, version, release_notes=None):
    """Validate release metadata and return the payload without writing an archive."""
    if not isinstance(version, str) or not re.fullmatch(VERSION_PATTERN, version):
        raise ValueError("Version must use X.Y.Z (optional legacy -forever or -forever.N suffix)")
    if release_notes is None:
        release_notes = f"GatherLite {version} for WoW Forever 1.60.1."
    if not release_notes.strip():
        raise ValueError("Release notes must not be empty")

    sources = package_sources(root)
    payload = {}
    for path in sorted(sources):
        if path.is_symlink() or not path.resolve().is_relative_to(root.resolve()):
            raise ValueError(f"Package source escapes repository: {path}")
        data = path.read_bytes()
        if path.suffix in {".toc", ".lua", ".xml", ".md", ".txt"}:
            data = data.replace(b"\r\n", b"\n")
        if path.suffix == ".toc":
            data = data.replace(b"@project-version@", version.encode("ascii"))
        payload[path.relative_to(root).as_posix()] = data
    validate_payload(payload, version)

    return payload, version, release_notes


def build_package(root, output_dir, version, release_notes=None):
    payload, version, release_notes = prepare_package(root, version, release_notes)
    output_dir.mkdir(parents=True, exist_ok=True)
    archive = output_dir / f"GatherLite-{version}.zip"
    with zipfile.ZipFile(archive, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9) as bundle:
        for path, data in sorted(payload.items()):
            entry = zipfile.ZipInfo(f"GatherLite/{path}", date_time=(2026, 1, 1, 0, 0, 0))
            entry.create_system = 3
            entry.external_attr = 0o100644 << 16
            entry.compress_type = zipfile.ZIP_DEFLATED
            bundle.writestr(entry, data)
    with zipfile.ZipFile(archive) as bundle:
        if bundle.testzip():
            raise ValueError("ZIP integrity check failed")
    digest = hashlib.sha256(archive.read_bytes()).hexdigest()
    archive.with_suffix(".zip.sha256").write_text(f"{digest}  {archive.name}\n", encoding="utf-8")
    return archive, version, release_notes, len(payload)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--version", required=True, help="Release version, e.g. 8.0.1")
    parser.add_argument("--output-dir", type=Path, default=Path("dist"))
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    try:
        archive, version, notes, count = build_package(root, args.output_dir, args.version)
    except (ValueError, OSError) as exc:
        parser.exit(1, f"Packaging failed: {exc}\n")
    print(f"Built {archive} ({count} files, {archive.stat().st_size:,} bytes)")


if __name__ == "__main__":
    main()
