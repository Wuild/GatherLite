#!/usr/bin/env python3
"""Verify the next patch with CurseForge's read API, never the upload-token API."""
import argparse
from datetime import datetime, timezone
from email.utils import parsedate_to_datetime
import json
from pathlib import Path
import re
import sys
import time
from urllib.error import HTTPError, URLError
from urllib.request import Request, build_opener

from publish import NoRedirects, PublishError, read_env_value, read_project_id

API = 'https://api.curseforge.com/v1'
VERSION = re.compile(r'(?<![\d.])(\d+\.\d+\.\d+)(?![\d.])')


def request_page(project, key, index):
    request = Request(f'{API}/mods/{project}/files?index={index}&pageSize=50',
                      headers={'x-api-key': key, 'Accept': 'application/json',
                               'User-Agent': 'GatherLite-Watcher/1.0'})
    deadline = time.monotonic() + 3600
    for attempt in range(3):
        try:
            with build_opener(NoRedirects()).open(request, timeout=30) as response:
                return json.load(response)
        except HTTPError as exc:
            code = exc.code
            retry_after = exc.headers.get('Retry-After') if exc.headers else None
            exc.close()
            if code not in (408, 429, 500, 502, 503, 504) or attempt == 2:
                raise PublishError(f'CurseForge read API failed (HTTP {code}); no upload attempted') from None
        except (URLError, OSError):
            if attempt == 2:
                raise PublishError('CurseForge read API connection failed; no upload attempted') from None
            retry_after = None
        except (ValueError, UnicodeError):
            raise PublishError('CurseForge read API returned invalid JSON') from None
        delay = (60, 180)[attempt]
        if retry_after:
            try:
                seconds = float(retry_after)
            except ValueError:
                try:
                    seconds = (parsedate_to_datetime(retry_after) - datetime.now(timezone.utc)).total_seconds()
                except (ValueError, TypeError, OverflowError):
                    seconds = 0
            if not 0 <= seconds <= 3600:
                raise PublishError('CurseForge Retry-After exceeds recovery budget') from None
            delay = max(delay, seconds)
        if time.monotonic() + delay > deadline:
            raise PublishError('CurseForge retry would exceed recovery budget')
        print(f'Read API retry {attempt + 2}/3 after {delay:g}s', file=sys.stderr, flush=True)
        while delay > 0:
            chunk = min(30, delay)
            time.sleep(chunk)
            delay -= chunk


def list_files(project, key):
    files, seen, index, total = [], set(), 0, None
    while True:
        result = request_page(project, key, index)
        if not isinstance(result, dict) or not isinstance(result.get('data'), list):
            raise PublishError('Invalid CurseForge file list')
        page, paging = result['data'], result.get('pagination')
        if not isinstance(paging, dict):
            raise PublishError('Missing file-list pagination')
        for field in ('index', 'resultCount', 'totalCount'):
            if type(paging.get(field)) is not int or paging[field] < 0:
                raise PublishError('Invalid file-list pagination')
        if paging['index'] != index or paging['resultCount'] != len(page):
            raise PublishError('Incomplete file-list pagination')
        if total is None:
            total = paging['totalCount']
        if total != paging['totalCount'] or total > 10000 or index + len(page) > total:
            raise PublishError('File list changed or exceeds API pagination limit; verify again')
        for item in page:
            if (not isinstance(item, dict) or type(item.get('id')) is not int
                    or item['id'] <= 0 or item.get('modId') != project or item['id'] in seen):
                raise PublishError('Invalid, duplicate, or wrong-project file')
            seen.add(item['id'])
            files.append(item)
        index += len(page)
        if index == total:
            return files
        if not page:
            raise PublishError('File list ended before all files were returned')


def next_patch(files, watcher, project):
    versions = set()
    for item in files:
        matches = set()
        for field in ('displayName', 'fileName'):
            value = item.get(field, '')
            if not isinstance(value, str):
                raise PublishError('Invalid file version metadata')
            if field == 'fileName' and value.lower().endswith('.zip'):
                value = value[:-4]
            matches.update(tuple(map(int, v.split('.'))) for v in VERSION.findall(value))
        if len(matches) != 1:
            raise PublishError('Cannot reliably identify a file release version')
        versions.update(matches)
    if not versions:
        raise PublishError('No release versions returned; cannot choose a patch safely')
    if not isinstance(watcher, dict):
        raise PublishError('Invalid watcher state')
    for field in ('pending', 'pending_upload', 'pending_publish'):
        if watcher.get(field):
            raise PublishError('Pending upload requires reconciliation before choosing a version')
    last = watcher.get('last_successful_publish')
    if last:
        if (not isinstance(last, dict) or last.get('project_id') != project
                or type(last.get('file_id')) is not int or last['file_id'] <= 0
                or not isinstance(last.get('version'), str)
                or not re.fullmatch(r'\d+\.\d+\.\d+', last['version'])):
            raise PublishError('Invalid successful publication record')
        # A missing accepted file may still be processing; public absence is not proof of no upload.
        if last['file_id'] not in {item['id'] for item in files}:
            raise PublishError('Last accepted file is absent from API; reconcile before publishing')
        versions.add(tuple(map(int, last['version'].split('.'))))
    latest = max(versions)
    candidate = (latest[0], latest[1], latest[2] + 1)
    assert candidate not in versions
    return '.'.join(map(str, latest)), '.'.join(map(str, candidate))


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--env-file', type=Path, required=True)
    parser.add_argument('--watcher-state', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args(argv)
    try:
        key = read_env_value(args.env_file, 'CURSEFORGE_API_KEY')
        project = read_project_id(args.env_file)
        watcher = json.loads(args.watcher_state.read_text(encoding='utf-8'))
        files = list_files(project, key)
        latest, version = next_patch(files, watcher, project)
        snapshot = {'checked_at': datetime.now(timezone.utc).isoformat(), 'project_id': project,
                    'latest_version': latest, 'next_version': version, 'files': files}
        args.output.parent.mkdir(parents=True, exist_ok=True)
        temporary = args.output.with_suffix(args.output.suffix + '.tmp')
        temporary.write_text(json.dumps(snapshot, indent=2) + '\n', encoding='utf-8')
        temporary.replace(args.output)
        print(f'Verified {len(files)} files: latest {latest}; unused next patch {version}')
        return 0
    except (PublishError, OSError, ValueError) as exc:
        print(f'Version verification blocked: {exc}', file=sys.stderr)
        return 1


if __name__ == '__main__':
    sys.exit(main())
