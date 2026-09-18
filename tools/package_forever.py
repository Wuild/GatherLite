#!/usr/bin/env python3
"""Build the same Forever-only release ZIP locally and in CurseForge CI."""

import argparse
import hashlib
import os
from pathlib import Path, PurePosixPath
import posixpath
import re
import zipfile

TOC = "GatherLite_Camelot.toc"
VERSION_PATTERN = r"(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)-forever\.[1-9][0-9]*"
RUNTIME_DIRS = ("scripts", "plugins", "icons")
ROOT_FILES = (TOC, "LICENSE", "CHANGELOG.md")
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


def build_package(root, output_dir, version=None):
    expected = (root / "VERSION").read_text(encoding="utf-8").strip()
    if not re.fullmatch(VERSION_PATTERN, expected):
        raise ValueError("VERSION must use X.Y.Z-forever.N")
    if version and version != expected:
        raise ValueError(f"Release tag {version!r} does not match VERSION {expected!r}")
    version = expected
    changelog = (root / "CHANGELOG.md").read_text(encoding="utf-8")
    heading = re.search(rf"^#### {re.escape(version)}(?:\s.*)?$", changelog, re.M)
    if not heading:
        raise ValueError(f"Missing changelog section for {version}")
    release_notes = changelog[heading.start():].split("\n#### ", 1)[0].strip()

    sources = [root / path for path in ROOT_FILES]
    for directory in RUNTIME_DIRS:
        sources.extend(path for path in (root / directory).rglob("*")
                       if path.is_file() and path.suffix.lower() in RUNTIME_EXTENSIONS
                       and not any(part.startswith(".") or part == "__pycache__"
                                   for part in path.relative_to(root).parts))
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
    parser.add_argument("--version", help="Optional release tag; must match VERSION")
    parser.add_argument("--output-dir", type=Path, default=Path("dist"))
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    try:
        archive, version, notes, count = build_package(root, args.output_dir, args.version)
    except (ValueError, OSError) as exc:
        parser.exit(1, f"Packaging failed: {exc}\n")
    if os.environ.get("GITHUB_OUTPUT"):
        with open(os.environ["GITHUB_OUTPUT"], "a", encoding="utf-8") as output:
            output.write(f"version={version}\narchive={archive.as_posix()}\n")
            output.write(f"changelog<<GATHERLITE_RELEASE_NOTES\n{notes}\nGATHERLITE_RELEASE_NOTES\n")
    print(f"Built {archive} ({count} files, {archive.stat().st_size:,} bytes)")


if __name__ == "__main__":
    main()
