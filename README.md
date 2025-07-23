# OfflineCatalogApp

iOS-app til at hente LibraryThing-katalog som `catalog.html` og vise det offline.

## Installation

- Clone repo.
- Installer Xcode (min. 13.x).
- `chmod +x build.sh`
- `./build.sh` -> `OfflineCatalogApp.ipa`.
- Overfør `.ipa` til iPad og installer via TrollStore.

## Entitlements

- `get-task-allow`, `no-sandbox`, `platform-application` er nødvendige for TrollStore unsandboxed.

## Automatisk build

Push til `main` -> GitHub Actions bygger IPA automatisk og uploader som artifact.
