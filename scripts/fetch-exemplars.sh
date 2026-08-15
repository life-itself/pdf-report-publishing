#!/usr/bin/env bash
# Re-download the exemplar reports studied in docs/typography-research.md.
#
# The PDFs are committed in reference/exemplars/, so this is only needed to
# refresh them or to check whether a publisher has issued a new edition.
# See reference/exemplars/README.md for what they are and the terms they're
# held under.
set -euo pipefail
cd "$(dirname "$0")/../reference/exemplars"

fetch() {
  local out="$1" url="$2"
  echo "==> $out"
  # -f so an HTML error page never gets written over a good PDF.
  if curl -sfL --max-time 120 -o "$out.tmp" "$url"; then
    if [ "$(file -b --mime-type "$out.tmp")" = "application/pdf" ]; then
      mv "$out.tmp" "$out"
    else
      rm -f "$out.tmp"; echo "    not a PDF — left existing file alone"
    fi
  else
    rm -f "$out.tmp"; echo "    fetch failed — left existing file alone"
  fi
}

fetch cri-realitycheck.pdf \
  "https://civilizationresearchinstitute.org/wp-content/uploads/2025/01/CRI-RealityCheck-1.pdf"
fetch mindfulness.pdf \
  "https://www.themindfulnessinitiative.org/Handlers/Download.ashx?IDMF=8d56bcb4-15a0-4b39-9236-064eb302ef99"
fetch pci-planetary.pdf \
  "https://cdn.prod.website-files.com/668400197070c499d03bb489/67124296cf139c5400cf85d8_PCI_PositionPaper_A%20New%20Framework%20for%20Planetary%20Futures%20(2).pdf"

echo "==> done"
