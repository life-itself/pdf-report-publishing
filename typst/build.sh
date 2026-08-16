#!/usr/bin/env bash
# Build the Typst pipeline: cleaned Markdown -> figures -> Typst -> PDF.
#
# Usage:  ./build.sh [engine]
#   essay  (default)  the Essay style — typst/lib/styles/essay.typ
#                     -> output/what-is-2r.pdf
#   v3                the superseded single-template engine, typst/report.typ
#                     -> output/what-is-2r-typst.pdf
#                     Kept until the Essay build is signed off; see NEXT.md.
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
ROOT="$(cd .. && pwd)"

SRC="../source/what-is-2r.md"
MARKS="../source/what-is-2r.editorial.txt"
ENGINE="${1:-essay}"

case "$ENGINE" in
  essay)
    MAIN="essay-main.typ"
    OUT="../output/what-is-2r.pdf"
    # An `include`d file gets its own scope, so the generated content has to
    # import the devices it calls. The Essay style has no margin rail and so
    # no note(); the generator scripts never emit one.
    IMPORTS='#import "lib/styles/essay.typ": fig, figrow, blockquote, dfn, standfirst, pullquote, opening'
    # image() resolves relative to the file that calls it, which for the
    # style libraries is typst/lib/styles/ — so asset paths have to be
    # root-absolute and the compile needs --root.
    ASSET_PREFIX="/typst/assets/"
    ;;
  v3)
    MAIN="main.typ"
    OUT="../output/what-is-2r-typst.pdf"
    IMPORTS='#import "report.typ": fig, figrow, note, pullquote, blockquote, dfn, standfirst'
    ASSET_PREFIX="assets/"
    ;;
  *)
    echo "unknown engine: $ENGINE (expected 'essay' or 'v3')" >&2
    exit 1
    ;;
esac

mkdir -p build

# Four passes over the Markdown before Pandoc sees it. Three recover
# something the Google Docs export lost — an image's caption, a quotation's
# identity as a quotation, a definition list's structure — all cases where
# the author's intent is visible in the source but not in its markup.
#
# The fourth applies editorial marks, which are *not* in the source at all
# and cannot be inferred from it: see issue #1. It runs first, on pristine
# paragraphs, before the other passes rewrite anything.
echo "==> editorial: apply standfirst / pullquote marks"
python3 ../scripts/editorial.py "$SRC" "$MARKS" build/marked.md

echo "==> figures: bare markdown images -> captioned figures"
python3 ../scripts/figures.py build/marked.md build/with-figures.md

echo "==> quotes: italic paragraphs -> block quotations"
python3 ../scripts/quotes.py build/with-figures.md build/with-quotes.md

echo "==> definitions: '>> **Term**' lines -> definition items"
python3 ../scripts/definitions.py build/with-quotes.md build/prepared.md

echo "==> pandoc: markdown -> typst content"
pandoc build/prepared.md -t typst -o content.typ --wrap=preserve

echo "==> fixups: imports, asset paths, bare images"
IMPORTS="$IMPORTS" ASSET_PREFIX="$ASSET_PREFIX" python3 - <<'PY'
import os, re

with open("content.typ") as f:
    text = f.read()

# Pandoc emits bare images for anything figures.py didn't claim; give them a
# sane width rather than letting them stretch to the column.
text = re.sub(r'image\("([^"]+)"\)', r'image("\1", width: 100%)', text)

# Rewrite asset paths for the engine being built. The generator scripts emit
# "assets/x.png" because that is where the v3 engine resolves from; the style
# libraries live a directory deeper and need root-absolute paths.
prefix = os.environ["ASSET_PREFIX"]
if prefix != "assets/":
    text = re.sub(r'"(?:\.\./)?assets/', '"' + prefix, text)

with open("content.typ", "w") as f:
    f.write(os.environ["IMPORTS"] + "\n\n" + text)
PY

mkdir -p assets
cp -f ../source/assets/*.png assets/
cp -f ../source/brand/*.png assets/

echo "==> typst compile ($ENGINE)"
mkdir -p ../output
typst compile --font-path "$FONT_DIR" --root "$ROOT" "$MAIN" "$OUT"

echo "==> done: ${OUT#../}"
