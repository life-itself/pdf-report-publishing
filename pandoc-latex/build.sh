#!/usr/bin/env bash
# Build the Pandoc + LaTeX (via Tectonic) pipeline prototype.
set -euo pipefail
cd "$(dirname "$0")"

export PATH="/home/user/tools/pandoc-3.9/bin:/home/user/tools:$PATH"

SRC="../source/what-is-2r.md"

mkdir -p ../output
ln -sfn ../source/assets assets

echo "==> pandoc: markdown -> tex"
pandoc "$SRC" \
  --template=template.tex \
  --pdf-engine=tectonic \
  -o ../output/what-is-2r-latex.pdf \
  -V toc-title="Contents"

echo "==> done: output/what-is-2r-latex.pdf"
