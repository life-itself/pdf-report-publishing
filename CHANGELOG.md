# Changelog

All notable work on this prototype, dated, most recent first.

## 2026-08-15

First working pass at the Markdown → PDF pipeline
([life-itself/community#1269](https://github.com/life-itself/community/issues/1269)),
using the ["What is 2R?"](https://github.com/life-itself/2rbook/blob/main/what-is-2r/essay.md)
essay as a real test document.

![Cover](changelog-assets/2026-08-15-cover.png)
![Body page](changelog-assets/2026-08-15-body-page.png)

**Added**
- Two candidate pipelines: Pandoc+LaTeX (via Tectonic) and Pandoc+Typst.
  Both build clean from the same cleaned Markdown source.
- `scripts/clean.py` — turns the essay's raw Google-Docs export into
  proper Markdown: strips the manual hyperlinked TOC, un-escapes
  Google-Docs punctuation, reconstructs the real two-level heading
  structure (`N.` chapters vs `N.M` subsections — the export had
  flattened both to one level), and preserves the source's manual page
  breaks instead of discarding them.
- Downloaded Rufus's reference PDF (a designer-typeset version of the
  same essay) and matched the Typst template against it directly:
  sampled its colours (maroon headings, dusty-rose italics, warm brown
  body ink), its sans-serif-throughout type treatment, asymmetric
  margins, and footer-only pagination.
- Cover now uses the reference artwork full-bleed (gold sun, swallows,
  botanical illustration) rather than a recreation — an earlier attempt
  to rebuild it from logo + text + cropped illustration pieces looked
  flat, then collided text with artwork, because the two occupy
  overlapping regions of the source image.
- New title/colophon page (page 2): title, subtitle, authors, draft
  date, and a copyright/licence line (placeholder text — needs a real
  decision, see `NEXT.md`).
- Confirmed Typst has native footnote (`#footnote[...]`) and
  bibliography/citation (`#bibliography()`, `#cite()`) support — no
  packages needed — with a standalone test document.

**Decided**
- Going with **Typst** over Pandoc+LaTeX: faster iteration, more
  approachable for non-technical collaborators, and covers what we
  thought might need LaTeX (footnotes, bibliographies) natively. The
  LaTeX pipeline is left working in `pandoc-latex/` as a fallback, not
  getting further design investment.

**Known gaps** — see `NEXT.md` for what's next.
