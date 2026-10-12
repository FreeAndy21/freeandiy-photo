#!/usr/bin/env bash
# Modified-by: FreeANDIY (Free Andy Agency), 2026. New file, not part of upstream PhotoCraft.
#
# Fail if upstream branding leaks into what FreeANDIY ships.
#
#   freeandiy/scripts/check-branding.sh [BINARY_OR_DIR ...]
#
# 1. Source: no ArtCraft / storyteller / getartcraft / Discord / "Crafting Apps" outside the
#    allowed places (licences, NOTICE, ATTRIBUTION, upstream's developer docs, the attribution
#    text), and no "PhotoCraft" in what users read (UI code strings, translations, packaging,
#    the web page).
# 2. Artifacts (optional arguments): the same terms in the strings of built binaries, packages
#    or the web build. Only the attribution sentence may name ArtCraft and PhotoCraft.
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"
fail=0

BANNED='ArtCraft|artcraft|storyteller|getartcraft|discord\.gg|Crafting Apps'
# Where upstream's names may appear: licences and notices (must stay), upstream's developer
# docs (not shipped), credits, code comments about upstream work, and our own freeandiy/ sources.
ALLOW=(':!NOTICE' ':!LICENSE-*' ':!**/LICENSE*' ':!ATTRIBUTION.md' ':!docs/**' ':!book/**' ':!*.md'
  ':!contributors/**' ':!freeandiy/**' ':!crates/ui-egui/src/freeandiy.rs')

echo "== source: upstream brand terms"
if hits="$(git grep -n -I -E "$BANNED" -- . "${ALLOW[@]}" | grep -v -E '^[^:]+:[0-9]+:\s*(//|#|<!--|\*)' || true)" && [ -n "$hits" ]; then
  echo "$hits" | head -50
  echo "FAIL: upstream brand terms above (remove them or add a rule in freeandiy/rules.toml)"
  fail=1
else
  echo "ok"
fi

echo "== source: product name in user-facing files"
# Translations (not comments), packaging, the web page, Rust string literals (not comments).
hits="$(
  {
    git grep -n -I 'PhotoCraft' -- 'crates/ui-egui/src/i18n/*.tsv' | grep -v -E '^[^:]+:[0-9]+:#' || true
    git grep -n -I 'PhotoCraft' -- packaging apps/photocraft-web/index.html ':!*.md' | grep -v -E 'the PhotoCraft authors' || true
    git grep -n -I -E '"[^"]*PhotoCraft[^"]*"' -- '*.rs' ':!xtask/**' ':!freeandiy/**' ':!crates/cms/**' ':!crates/codecs/tests/**' ':!crates/ui-egui/src/freeandiy.rs' \
      | grep -v -E '^[^:]+:[0-9]+:\s*//' | grep -v -E 'the PhotoCraft authors' || true
  } | sort -u
)"
if [ -n "$hits" ]; then
  echo "$hits" | head -50
  echo "FAIL: 'PhotoCraft' where users can read it"
  fail=1
else
  echo "ok"
fi

# The attribution sentence (About) and the copyright line are the only allowed mentions.
ALLOWED_STRINGS='based on the open-source project|affiliated with the ArtCraft team|ArtCraft Team and contributors|the PhotoCraft authors|^PhotoCraft$'
for target in "$@"; do
  echo "== artifact: $target"
  files=()
  if [ -d "$target" ]; then
    while IFS= read -r -d '' f; do files+=("$f"); done < <(find "$target" -type f \( -perm -u+x -o -name '*.wasm' -o -name '*.js' -o -name '*.html' -o -name '*.plist' -o -name '*.desktop' -o -name '*.xml' -o -name '*.json' -o -name '*.exe' -o -name '*.dll' \) -print0)
  else
    files=("$target")
  fi
  bad=0
  for f in "${files[@]}"; do
    hits="$(strings -n 6 "$f" 2>/dev/null | grep -E "$BANNED|PhotoCraft" | grep -v -E "$ALLOWED_STRINGS" | sort -u | head -20 || true)"
    if [ -n "$hits" ]; then
      echo "  $f:"
      echo "$hits" | sed 's/^/    /' | cut -c1-200
      bad=1
    fi
  done
  if [ "$bad" = 1 ]; then
    echo "FAIL: upstream branding in $target"
    fail=1
  else
    echo "ok (${#files[@]} file(s))"
  fi
done

exit "$fail"
