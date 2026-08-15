#!/usr/bin/env bash
# Build the Typst pipeline: cleaned Markdown -> figures -> Typst -> PDF.
#
# Usage:  ./build.sh [style]
#   style  one of the presets in theme.typ (warm | editorial | modern |
#          display). Defaults to whatever main.typ specifies.
set -euo pipefail
cd "$(dirname "$0")"

# Toolchain: typst + pandoc. Prefer whatever is on PATH (Homebrew on macOS);
# fall back to the ~/tools layout used by the original sandbox.
export PATH="$PATH:$HOME/tools/typst-x86_64-unknown-linux-musl:$HOME/tools/pandoc-3.9/bin"

# Report fonts are vendored in ../fonts so builds don't depend on what
# happens to be installed on the machine — the first pass at this silently
# fell back to a system serif on one machine and Liberation Sans on
# another, producing two different-looking PDFs from the same source.
FONT_DIR="$(cd ../fonts && pwd)"

SRC="../source/what-is-2r.md"
STYLE="${1:-}"

mkdir -p build

# Two structural passes over the Markdown before Pandoc sees it, each
# recovering something the Google Docs export lost: an image's caption,
# and a quotation's identity as a quotation. Both are cases where the
# author's intent is visible in the source but not in its markup.
echo "==> figures: bare markdown images -> captioned figures"
python3 ../scripts/figures.py "$SRC" build/with-figures.md

echo "==> quotes: italic paragraphs -> block quotations"
python3 ../scripts/quotes.py build/with-figures.md build/with-quotes.md

echo "==> definitions: '>> **Term**' lines -> definition items"
python3 ../scripts/definitions.py build/with-quotes.md build/prepared.md

echo "==> pandoc: markdown -> typst content"
pandoc build/prepared.md -t typst -o content.typ --wrap=preserve

# content.typ is `include`d, and Typst gives an included file its own scope,
# so the figure helpers have to be imported there rather than inherited
# from main.typ. Any bare image Pandoc still emits gets a sane width.
python3 - <<'PY'
import re
with open("content.typ") as f:
    text = f.read()
text = re.sub(r'image\("([^"]+)"\)', r'image("\1", width: 100%)', text)
header = '#import "report.typ": fig, figrow, note, pullquote, blockquote, dfn, standfirst\n\n'
with open("content.typ", "w") as f:
    f.write(header + text)
PY

mkdir -p assets
cp -f ../source/assets/*.png assets/
cp -f ../source/brand/*.png assets/

echo "==> typst compile"
mkdir -p ../output
TYPST_ARGS=(--font-path "$FONT_DIR")
if [ -n "$STYLE" ]; then TYPST_ARGS+=(--input style="$STYLE"); fi
typst compile "${TYPST_ARGS[@]}" main.typ ../output/what-is-2r-typst.pdf

echo "==> done: output/what-is-2r-typst.pdf"
