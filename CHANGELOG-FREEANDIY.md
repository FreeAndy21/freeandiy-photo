<!-- Modified-by: FreeANDIY (Free Andy Agency), 2026. New file, not part of upstream PhotoCraft. -->
# FreeANDIY Photo: changes from upstream PhotoCraft

This file lists what the FreeANDIY fork changes in PhotoCraft (Apache-2.0 section 4(b)). The
exact changes are generated from `freeandiy/` (see `NOTICE`); `git diff upstream-main main`
shows every changed file.

## Unreleased

### Branding
- Product name **FreeANDIY Photo** everywhere users see it: window title, menus, About, start
  screen, messages, all 17 bundled translations, installers, desktop entries, the web page.
- Application id `agency.freeandy.photo` (was `ai.storyteller.photocraft`): macOS bundle id and
  UTIs, Linux desktop/metainfo/MIME/Flatpak ids, so FreeANDIY builds install next to PhotoCraft.
- Settings directory `FreeANDIY Photo` (macOS, Windows) / `freeandiy-photo` (Linux).
- Executables `freeandiy-photo` and `freeandiy-photo-cli`; the cargo packages keep their names.
- New app icon set (the angel Andy, Free Andy Agency) and DMG background.
- New themes **FreeANDIY Light** (default: paper and ink) and **FreeANDIY Dark**, carried by the
  Studio Light and Pro Medium Gray theme slots; square corners, hairlines, no shadows.
- UI fonts IBM Plex Sans and IBM Plex Mono (OFL 1.1).

### Removed
- The ArtCraft name, wordmark and logos (`docs/brand/`), as their terms require of forks.
- The ArtCraft Discord and website links (Help menu, title bar, start screen, About, installers).
- Release workflows that called `storytold/craft-common-actions` (no licence), nightly perf and
  FreeBSD jobs.

### Added
- About: attribution to upstream PhotoCraft and the Free Andy Agency seal.
- `NOTICE` section and `ATTRIBUTION.md` rows for FreeANDIY's assets and fonts; packages now ship
  `NOTICE`, `ATTRIBUTION.md`, the font licences and the brand terms.
