# GatherLite Forever releases

The addon stays **GatherLite**, including its installation folder and saved-variable names. Publish to the existing [GatherLite CurseForge project](https://www.curseforge.com/wow/addons/gatherlite), project **334918**. This release supports **WoW Forever 1.60.1**, interface **16001**, only.

## Branch and version

Develop this release line on `codex/forever-only`; `master` and the existing 7.x releases retain the previous clients. The first Forever version is `8.0.0-forever.1`. `VERSION` is the source of truth, and the release tag must match it exactly. Bump the numeric version for subsequent releases (for example `8.0.1-forever.1`), because the addon's version notification compares the numeric version prefix.

## GitHub Actions publication

The **Package and publish GatherLite Forever** workflow handles validation, packaging, and CurseForge upload. The repository needs a `CURSEFORGE_TOKEN` Actions secret with upload access to project 334918.

1. Update `VERSION` and the matching section of `CHANGELOG.md` on `codex/forever-only`.
2. Commit and push the reviewed branch.
3. Create a tag matching `VERSION` on that commit and push the tag. For this release the tag is `8.0.0-forever.1`.

Only tags matching `*-forever.*` trigger this branch's CurseForge workflow. It runs the complete test suite, requires the tag to match `VERSION`, builds the archive, retains the ZIP/checksum as an Actions artifact, and uploads to project 334918 as **GatherLite 8.0.0-forever.1**, game version **1.60.1 / Forever**, file type **Release**, with Markdown release notes. It does not mark this package compatible with other clients. Forever tags are excluded from the Wago workflow.

A manual run of this workflow on `codex/forever-only` only builds a downloadable artifact for review; it does not publish.

## Optional local validation

Run from the repository root with Python 3.10 or newer:

```sh
python -m unittest discover -s tools -p 'test_*.py'
lua tools/test_compat.lua
lua tools/test_database.lua
lua tools/test_tracking.lua
lua tools/test_tooltips.lua
python tools/package_forever.py
```

The builder creates `dist/GatherLite-8.0.0-forever.1.zip` and a SHA-256 checksum. It validates the release version, Forever metadata, database, and every TOC/XML load dependency. The archive has exactly one `GatherLite/` root. Only addon code, bundled libraries and licenses, icons, the Forever database, and the changelog are included. The Wowhead updater, tests, import state, caches, Git files, CI files, screenshots, and release tooling are excluded.

Install that ZIP in the Forever client and check `/reload`, both map menus, gathering/lockpicking, grouped tooltips, and nearby circles. Automated checks do not replace this in-game check.

Reference: [CurseForge upload API](https://support.curseforge.com/support/solutions/articles/9000197321) and [uploader action inputs](https://github.com/itsmeow/curseforge-upload).
