#!/usr/bin/env bash
# Build every artefact that proves the three template styles:
#
#   output/style-review.pdf      the Review spec, demonstrated
#   output/style-essay.pdf       the Essay spec, demonstrated
#   output/style-brief.pdf       the Brief spec, demonstrated
#   output/style-comparison.pdf  the same content in all three
#
# Run this after changing anything under typst/lib/ or docs/styles/. If a
# spec and its PDF disagree, one of them is wrong and the PDF is the one
# that can be checked.
set -euo pipefail
cd "$(dirname "$0")/.."

export PATH="$PATH:$HOME/tools/typst-x86_64-unknown-linux-musl"

# Fonts are vendored so the same source produces the same PDF on any
# machine. Left to itself Typst falls back silently to whatever is
# installed — see docs/typst-cookbook.md.
TYPST=(typst compile --font-path fonts --root .)

mkdir -p output

for style in review essay brief; do
  echo "==> $style"
  "${TYPST[@]}" "typst/examples/${style}-example.typ" "output/style-${style}.pdf"
done

echo "==> comparison"
"${TYPST[@]}" typst/compare.typ output/style-comparison.pdf

echo "==> done"
ls -la output/style-*.pdf
