# Arcane Contributor Guide

This guide maps common contributor tasks to the exact places you should edit in this repository.

## Repository Layout (What Owns What)

- `lib/`
  Arcane package source. This is the public package that gets published as `arcane`.
- `lib/generated/arcane_shadcn/`
  Generated/copied shadcn fork source used by Arcane at runtime. Do not hand-edit long-term unless you know exactly why.
- `arcane_shadcn/`
  Fork workspace for upstream shadcn work. This is where framework-level shadcn changes should be made first.
- `docs/`
  Widget catalog/docs app (mostly derived/synced from upstream + arcane overlays).
- `arcane_docs/`
  Arcane-specific docs overlay that gets copied into `docs/` by script.
- `example/`
  Example app that consumes `arcane`.
- `script_sync_shadcn.sh`
  Pulls the `arcane_shadcn` fork, copies code into `lib/generated/arcane_shadcn`, and rebrands docs.
- `script_sync_docs_live.sh`
  Copies Arcane docs overlay files from `arcane_docs/` into `docs/`.

## Public API Surface

- `lib/arcane.dart`
  Primary export barrel for Arcane APIs.
- `lib/util/promotions.dart`
  Re-export layer that pulls in generated shadcn APIs + bundled dependencies.

When adding new public Arcane APIs, ensure they are exported from `lib/arcane.dart`.

## Common Task: Add a New Arcane Component

Use this when building Arcane-level widgets (screens, wrappers, helpers, specialized components).

1. Create the widget in one of:
   - `lib/component/screen/`
   - `lib/component/layout/`
   - `lib/component/view/`
   - `lib/component/input/`
   - `lib/component/navigation/`
   - `lib/component/dialog/`
   - `lib/component/form/`
2. Use package imports (project convention):
   - `import 'package:arcane/arcane.dart';`
3. Export it from:
   - `lib/arcane.dart`
4. If docs are needed:
   - Add Arcane docs examples/routes in `arcane_docs/lib/custom.dart`
   - Run `./script_sync_docs_live.sh` to copy overlay changes into `docs/`
5. Update changelog entry in `CHANGELOG.md` when shipping.

## Common Task: Change Theme or Visual Identity

Start here for colors, radius, scaling, blur/surface effects, haptics defaults.

- Core theme model:
  - `lib/util/appearance/theme.dart`
- Surface and blur behavior:
  - `lib/util/appearance/surface_effect.dart`
- Shader loading and runtime behavior:
  - `lib/util/appearance/shaders.dart`
- Shader widget wrappers:
  - `lib/component/shaders/`
- Assets:
  - `lib/resources/shaders/`
  - `lib/resources/fonts/`
  - `lib/resources/icons/`
  - `pubspec.yaml` (`flutter.shaders`, `fonts`)

If you add a new shader:

1. Add `.frag` file under `lib/resources/shaders/`
2. Register asset in `pubspec.yaml` under `flutter.shaders`
3. Add Arcane shader registration in `ArcaneShader.loadAll()` (`lib/util/appearance/shaders.dart`)
4. Add/adjust any wrapper component in `lib/component/shaders/`

## Common Task: Modify shadcn Fork Behavior

Use this when changing low-level shadcn components (tabs, button internals, menu behavior, etc.).

1. Make changes in:
   - `arcane_shadcn/lib/src/...`
2. Validate in the fork workspace as needed (`arcane_shadcn/`).
3. Sync into Arcane package generated folder by running:
   - `./script_sync_shadcn.sh`

Important:

- `script_sync_shadcn.sh` runs `git reset --hard origin/arcane` inside `arcane_shadcn/`.
- Any uncommitted local work in `arcane_shadcn/` can be lost.
- Commit or stash fork changes before running sync.

## Common Task: Sync Upstream Fork into Arcane

Use when you want Arcane to consume the latest `ArcaneArts/arcane_shadcn` branch.

Run:

```bash
./script_sync_shadcn.sh
```

This script does all of the following:

- Updates/clones `arcane_shadcn` on branch `arcane`
- Copies `arcane_shadcn/lib` into `lib/generated/arcane_shadcn`
- Rewrites imports to `package:arcane/generated/arcane_shadcn/...`
- Patches icon `fontPackage` values
- Rebuilds/rebrands docs app content
- Runs clean/pub get for multiple workspaces

After sync, inspect diffs carefully:

- `lib/generated/arcane_shadcn/**`
- `docs/**`
- any Arcane wrappers that depend on changed upstream behavior

## Common Task: Update Documentation

There are two docs layers:

- Base docs app in `docs/` (mostly synced/generated)
- Arcane overlay in `arcane_docs/` (you should edit this for Arcane-specific docs)

Recommended workflow:

1. Edit Arcane docs pages in:
   - `arcane_docs/lib/custom.dart`
   - `arcane_docs/lib/introduction_page.dart`
   - `arcane_docs/lib/installation_page.dart`
   - `arcane_docs/lib/theme_page.dart`
2. Sync overlay to docs:
   - `./script_sync_docs_live.sh`
3. Verify docs app under `docs/`.

Note:

- Direct edits in `docs/lib/custom.dart` can be overwritten by sync scripts.
- Prefer editing `arcane_docs/` for Arcane-owned documentation.

## Common Task: Add/Adjust Example App Usage

- Example entrypoint:
  - `example/lib/main.dart`
- Example screens:
  - `example/lib/screen/`

Use this app to demonstrate intended Arcane API usage and sanity-check behavior quickly.

## App Bootstrap and Runtime Hooks

If your change touches app startup, state wiring, or global behaviors:

- Startup and app shell:
  - `lib/component/support/app.dart`
- Global helpers/navigation/haptics:
  - `lib/util/arcane.dart`

Key patterns:

- Arcane apps typically start with:
  - `runApp("<appId>", ArcaneApp(...))`
- Startup includes init tasks (Hive, haptics, shader loading, optional MetaSEO).

## Release Hygiene Checklist

Before merging/releasing notable changes:

1. Update `CHANGELOG.md`
2. Ensure exported API in `lib/arcane.dart` is correct
3. Confirm style expectations in `CODE_STYLE.md`
4. Run relevant checks (at minimum analyze/build paths you touched)
5. Verify docs and example still reflect current API

## Known Drift Risk

Some docs snippets may describe APIs that have changed over time. If examples mention APIs that do not exist in `lib/` anymore, treat runtime code as source of truth and update docs accordingly.

