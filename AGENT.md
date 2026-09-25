# GatherLite repository instructions

## Publishing a new version

Always update the main window's **What's New** content before publishing a new version.

- Edit the bundled release highlights in `Window:CreateChangelog` in `scripts/window.lua`.
- Describe the actual user-facing features, improvements, and fixes included in that version. Keep the wording concise and group related changes.
- Remove outdated highlights and do not describe unreleased or planned work as shipped.
- Keep the notes consistent with the version being published and any external release notes. The displayed installed version comes from addon metadata.
- Include the updated highlights in the release package before publishing. Do not publish a new version with stale What's New content.
- Run the relevant UI/controller checks after changing the changelog view or its navigation.

## Version numbering

Use `MAJOR.MINOR.PATCH`. Increase MINOR and reset PATCH to zero when releasing new features (for example, `8.1.0`). Reserve PATCH increments for database updates (for example, `8.1.1`).
