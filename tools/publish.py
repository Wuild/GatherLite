#!/usr/bin/env python3
"""Publish GatherLite to CurseForge using the upload token in a local .env file."""

import argparse
import json
from pathlib import Path
import re
import sys
from urllib.error import HTTPError, URLError
from urllib.request import HTTPRedirectHandler, Request, build_opener
from uuid import uuid4

from package_forever import build_package, prepare_package

ROOT = Path(__file__).resolve().parents[1]
API = "https://wow.curseforge.com/api"
DEFAULT_PROJECT_ID = 334918
DEFAULT_GAME_VERSION = "1.60.1"


class PublishError(ValueError):
    pass


def read_env_value(path, key, default=None, allow_spaces=False):
    """Read one literal setting; never execute or expand .env contents."""
    try:
        lines = path.read_text(encoding="utf-8-sig").splitlines()
    except FileNotFoundError:
        if default is not None:
            return default
        raise PublishError(f"Cannot read {path}; copy .env.example to .env and set {key}") from None
    token = None
    for line in lines:
        match = re.match(rf"^\s*(?:export\s+)?{re.escape(key)}\s*=(.*)$", line)
        if not match:
            continue
        if token is not None:
            raise PublishError(f"Duplicate {key} entries in .env")
        value = match[1].strip()
        if value.startswith(("'", '"')):
            quote = value[0]
            end = value.find(quote, 1)
            if end < 0 or (value[end + 1:].strip() and not value[end + 1:].strip().startswith("#")):
                raise PublishError(f"Invalid quoted {key} in .env")
            value = value[1:end]
        else:
            value = re.split(r"\s+#", value, maxsplit=1)[0].strip()
        token = value
    if token is None and default is not None:
        return default
    if not token or any(ord(c) < (32 if allow_spaces else 33) or ord(c) > 126 for c in token):
        raise PublishError(f"Set a nonempty, single-line {key} in .env")
    return token


def read_token(path):
    return read_env_value(path, "CURSEFORGE_TOKEN")


def read_game_versions(path):
    value = read_env_value(path, "CURSEFORGE_GAME_VERSION", DEFAULT_GAME_VERSION,
                           allow_spaces=True)
    versions = [part.strip() for part in value.split(",")]
    if any(not re.fullmatch(r"[0-9]+\.[0-9]+\.[0-9]+", version) for version in versions):
        raise PublishError("CURSEFORGE_GAME_VERSION must contain comma-separated X.Y.Z versions")
    return list(dict.fromkeys(versions))


def read_project_id(path):
    value = read_env_value(path, "CURSEFORGE_PROJECT_ID", str(DEFAULT_PROJECT_ID))
    if not re.fullmatch(r"[0-9]+", value) or int(value) <= 0:
        raise PublishError("CURSEFORGE_PROJECT_ID must be a positive integer")
    return int(value)


class NoRedirects(HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        # Do not forward upload credentials to a redirect target or replay POSTs.
        raise HTTPError(req.full_url, code, "Redirect refused", headers, fp)


def api_json(path, token, data=None, content_type=None):
    headers = {"X-Api-Token": token, "Accept": "application/json",
               "User-Agent": "GatherLite-Publisher/1.0"}
    if content_type:
        headers["Content-Type"] = content_type
    request = Request(API + path, data=data, headers=headers)
    try:
        with build_opener(NoRedirects()).open(request, timeout=120) as response:
            return json.load(response)
    except HTTPError as exc:
        # Response bodies and transport exceptions may echo headers. Never log them.
        raise PublishError(f"CurseForge request failed (HTTP {exc.code})") from None
    except (URLError, OSError):
        raise PublishError("CurseForge connection failed or timed out") from None
    except (ValueError, UnicodeError):
        raise PublishError("CurseForge returned an invalid JSON response") from None


def resolve_game_version(versions, game_version=DEFAULT_GAME_VERSION):
    if not isinstance(versions, list):
        raise PublishError("CurseForge returned an invalid game-version list")
    matches = [entry for entry in versions
               if isinstance(entry, dict) and entry.get("name") == game_version]
    if len(matches) != 1:
        raise PublishError(f"Expected exactly one CurseForge version for {game_version}; found {len(matches)}")
    version_id = matches[0].get("id")
    if type(version_id) is not int or version_id <= 0:
        raise PublishError("CurseForge returned an invalid game-version ID")
    return version_id


def multipart(archive, metadata):
    boundary = "GatherLite" + uuid4().hex
    body = (
        f'--{boundary}\r\nContent-Disposition: form-data; name="metadata"\r\n'
        'Content-Type: application/json\r\n\r\n'
        + json.dumps(metadata, ensure_ascii=False) + '\r\n'
        + f'--{boundary}\r\nContent-Disposition: form-data; name="file"; filename="{archive.name}"\r\n'
        'Content-Type: application/zip\r\n\r\n'
    ).encode("utf-8")
    body += archive.read_bytes() + f"\r\n--{boundary}--\r\n".encode("ascii")
    return body, f"multipart/form-data; boundary={boundary}"


def upload(archive, version, notes, version_ids, token, project_id=DEFAULT_PROJECT_ID):
    metadata = {"displayName": f"GatherLite {version}", "changelog": notes,
                "changelogType": "markdown", "gameVersions": version_ids,
                "releaseType": "release"}
    body, content_type = multipart(archive, metadata)
    try:
        result = api_json(f"/projects/{project_id}/upload-file", token, body, content_type)
        file_id = result.get("id") if isinstance(result, dict) else None
        if type(file_id) is not int or file_id <= 0:
            raise PublishError("CurseForge did not return a valid file ID")
    except PublishError as exc:
        raise PublishError(f"{exc}. Check the author dashboard before retrying; the upload may have been accepted.") from None
    if project_id == DEFAULT_PROJECT_ID:
        return f"https://www.curseforge.com/wow/addons/gatherlite/files/{file_id}"
    return f"https://legacy.curseforge.com/projects/{project_id}/files/{file_id}"


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--version", required=True, help="Release version, e.g. 8.0.1")
    parser.add_argument("--changelog", type=Path, help="Optional UTF-8 Markdown release notes")
    parser.add_argument("--env-file", type=Path, default=ROOT / ".env", help="Configuration file (default: repository .env)")
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--dry-run", action="store_true", help="Validate and preview only; no token, network, or archive required")
    mode.add_argument("--package-only", action="store_true", help="Build ZIP and checksum without a token or upload")
    args = parser.parse_args(argv)
    try:
        game_versions = read_game_versions(args.env_file)
        game_version = ", ".join(game_versions)
        project_id = read_project_id(args.env_file)
        notes = (args.changelog.read_text(encoding="utf-8-sig") if args.changelog
                 else f"GatherLite {args.version} for WoW Forever {game_version}.")
        payload, version, notes = prepare_package(ROOT, args.version, notes)
        print(f"GatherLite {version}: {len(payload)} files; CurseForge project {project_id}; WoW {game_version}")
        if args.dry_run:
            print(notes)
            print("Dry run complete: no archive created and nothing uploaded.")
            return 0
        if args.package_only:
            archive, _, _, _ = build_package(ROOT, ROOT / "dist", version, notes)
            print(f"Package created: {archive}")
            print(f"Checksum: {archive.with_suffix('.zip.sha256')}")
            return 0
        token = read_token(args.env_file)
        available_versions = api_json("/game/versions", token)
        version_ids = [resolve_game_version(available_versions, name) for name in game_versions]
        archive, version, notes, _ = build_package(ROOT, ROOT / "dist", version, notes)
        print(f"Uploading {archive.name} for game-version IDs {', '.join(map(str, version_ids))}...")
        link = upload(archive, version, notes, version_ids, token, project_id)
        print(f"Upload accepted: {link}")
        print("Check file approval and Forever classification in the CurseForge author dashboard.")
        return 0
    except (ValueError, OSError) as exc:
        print(f"Publish failed: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
