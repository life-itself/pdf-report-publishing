#!/usr/bin/env bash
# Build the Typst pipeline prototype: cleaned Markdown -> Typst content -> PDF.
set -euo pipefail
cd "$(dirname "$0")"

export PATH="/home/user/tools/typst-x86_64-unknown-linux-musl:/home/user/tools/pandoc-3.9/bin:$PATH"

SRC="../source/what-is-2r.md"

echo "==> pandoc: markdown -> typst content"
pandoc "$SRC" -t typst -o content.typ --wrap=preserve

# Constrain every image to a sane width (pandoc emits bare image("path")).
python3 - <<'PY'
import re
with open("content.typ") as f:
    text = f.read()
text = re.sub(r'image\("([^"]+)"\)', r'image("\1", width: 100%)', text)
with open("content.typ", "w") as f:
    f.write(text)
PY

mkdir -p assets
cp -f ../source/assets/*.png assets/
cp -f ../source/brand/*.png assets/

echo "==> typst compile"
mkdir -p ../output
typst compile main.typ ../output/what-is-2r-typst.pdf

echo "==> done: output/what-is-2r-typst.pdf"
