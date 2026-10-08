#!/usr/bin/env bash
# Build a Seeds of Renaissance paper in the sor style.
#
# Usage:  typst/build-paper.sh wisdom [path/to/paper-dir]
#
# The paper's text lives in its own repo (default for wisdom:
# ../2rbook/wisdom, holding essay.md and assets/). This script:
#
#   1. copies the paper's assets into typst/build/paper/
#   2. writes the essay's frontmatter to typst/build/paper/meta.yaml
#   3. converts essay.md to Typst with scripts/sor.lua
#   4. compiles typst/papers/<name>.typ to output/<name>.pdf
#
# Fonts: the OFL faces are vendored in fonts/. Polyamine and Restora are
# licensed, not redistributable, so they are not committed: put them in
# fonts/licensed/ (gitignored) or install them on the machine.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

NAME="${1:?usage: typst/build-paper.sh <name> [paper-dir]}"
case "$NAME" in
  wisdom) DEFAULT_SRC="../2rbook/wisdom" ;;
  *) DEFAULT_SRC="" ;;
esac
SRC="${2:-$DEFAULT_SRC}"
[ -n "$SRC" ] && [ -f "$SRC/essay.md" ] || { echo "no essay.md in '${SRC}'" >&2; exit 1; }
[ -f "typst/papers/$NAME.typ" ] || { echo "no typst/papers/$NAME.typ" >&2; exit 1; }

BUILD="typst/build/paper"
rm -rf "$BUILD"
mkdir -p "$BUILD" output
cp -R "$SRC/assets" "$BUILD/assets"

echo "==> frontmatter -> meta.yaml"
python3 - "$SRC/essay.md" "$BUILD/meta.yaml" <<'PY'
import sys
text = open(sys.argv[1]).read()
if not text.startswith("---\n"):
    sys.exit("essay.md has no frontmatter")
open(sys.argv[2], "w").write(text.split("\n---\n", 1)[0][4:] + "\n")
PY

echo "==> pandoc + sor.lua -> content.typ"
SOR_ASSET_PREFIX="/$BUILD/" pandoc "$SRC/essay.md" \
  -f markdown+gfm_auto_identifiers-implicit_figures \
  --lua-filter scripts/sor.lua \
  -t typst --wrap=preserve -o "$BUILD/content.body.typ"
{
  echo '#import "/typst/lib/styles/sor.typ": opening, contents-page, summary, quotation, epigraph, plate, reference'
  echo
  cat "$BUILD/content.body.typ"
} > "$BUILD/content.typ"

echo "==> figure bounds (to crop drawn margins)"
FIGS=$(grep -o 'plate("[^"]*\.png"' "$BUILD/content.body.typ" | sed 's/^plate("\///; s/"$//' | sort -u)
python3 scripts/figure-bounds.py "$BUILD/figure-bounds.json" $FIGS

# The cover is the frontmatter's cover_image (a path inside the paper's
# folder); failing that, assets/<name>-cover.{png,jpg,webp}.
COVER=""
CI=$(sed -n 's/^cover_image:[[:space:]]*\([^[:space:]#]*\).*/\1/p' "$BUILD/meta.yaml" | head -1)
if [ -n "$CI" ] && [ "$CI" != "null" ] && [ -f "$SRC/$CI" ]; then
  mkdir -p "$BUILD/$(dirname "$CI")"
  cp "$SRC/$CI" "$BUILD/$CI"
  COVER="/$BUILD/$CI"
fi
[ -n "$COVER" ] || for c in "$SRC/assets/$NAME-cover.png" "$SRC/assets/$NAME-cover.jpg" "$SRC/assets/$NAME-cover.webp"; do
  if [ -f "$c" ]; then COVER="/$BUILD/assets/$(basename "$c")"; break; fi
done

echo "==> typst compile ${COVER:+(cover: ${COVER##*/})}"
# Until Restora is installed every Restora slot warns; say it once instead.
typst compile --font-path fonts --root . \
  ${COVER:+--input cover="$COVER"} \
  "typst/papers/$NAME.typ" "output/$NAME.pdf" 2>&1 \
  | awk '/unknown font family: restora/ { skip = 1; r = 1; next }
         skip && /^$/ { skip = 0; next }
         skip { next }
         { print }
         END { if (r) print "note: Restora not found; set in Fraunces instead (fonts/licensed/ or install it)" }'

echo "==> done: output/$NAME.pdf"
