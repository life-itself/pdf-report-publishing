# PDF report publishing — pipeline prototype

First pass at the "Markdown → elegant PDF" workflow tracked in
[life-itself/community#1269](https://github.com/life-itself/community/issues/1269)
and [rufuspollock/planning: 2026-pdf-report-publishing-from-markdown](https://github.com/rufuspollock/planning/blob/main/projects/2026-pdf-report-publishing-from-markdown.md).
Not a spec — a working build to see what each toolchain actually produces.

## Sample document

[`life-itself/2rbook`](https://github.com/life-itself/2rbook)'s `what-is-2r/essay.md`
— the "What is the Second Renaissance?" essay (~8,900 words, 12 sections + appendix).
Chosen because it's short-ish, representative, and — usefully — a real
Google-Docs export: escaped punctuation, a manual hyperlinked TOC, stray
empty heading page-breaks. Exactly the messy input the real pipeline has to
handle, not a clean hand-written Markdown file.

## What's here

```
source/                 cleaned Markdown + copied image assets (input to both pipelines)
scripts/clean.py        Google-Docs-export -> clean Markdown: strips the manual TOC,
                         un-escapes \. \- etc., reclassifies heading levels (N.M ->
                         subsection, N. -> chapter with number stripped, matching
                         the designer reference's structure), and turns the export's
                         empty page-break headings into real page breaks
pandoc-latex/            Pandoc -> custom LaTeX template -> Tectonic -> PDF
typst/                   Pandoc -> Typst markup -> custom Typst template -> PDF
                         (this is the live pipeline — see "Decision" below)
reference/               designer-what-is-2r.pdf — Rufus's target reference, a
                         professionally typeset version of this same essay,
                         downloaded from Drive for comparison. Not our output.
output/                  built PDFs (both pipelines, committed so they're
                         viewable without a local toolchain)
```

Run `pandoc-latex/build.sh` or `typst/build.sh` to rebuild. Both read from
the same `source/what-is-2r.md`.

## Decision: Typst

After comparing both pipelines on this sample, **Typst is the direction** —
faster iteration, more approachable for non-technical collaborators to touch
later, and it natively covers the two features that seemed like they'd need
LaTeX: footnotes (`#footnote[...]`, auto-numbered, placed at the bottom of
the page) and bibliographies/citations (`#bibliography("refs.bib")` +
`#cite(<key>)`, reads BibTeX or Typst's own Hayagriva format, ships APA/
Chicago/etc. styles built in — no packages to install). Confirmed with a
throwaway test doc, not yet wired into the real template. The Pandoc+LaTeX
pipeline is left in place working, but isn't getting further design
investment unless something concrete needs it.

## Toolchain (installed to `~/tools`, not system packages)

- **Pandoc 3.9** — Markdown → LaTeX or → Typst markup
- **Tectonic 0.15** — self-contained LaTeX engine (downloads its package
  bundle on first run instead of needing a multi-GB TeX Live install)
- **Typst 0.15** — native typesetting language + compiler, single binary

## Brand

No style guide exists yet (that's [#1276](https://github.com/life-itself/community/issues/1276),
still open). The `typst/` template (v2) is now matched directly against
`reference/designer-what-is-2r.pdf` — a professionally typeset version of
this exact essay that Rufus supplied as the target — rather than just the
cover. Colours and structure were sampled/measured from it directly:

- Cover: uses the actual reference artwork (`2rbook/assets/whitepaper-1-cover.webp`,
  full-bleed) rather than a re-creation — first attempt rebuilt the cover
  from scratch (logo + typst-rendered title + a couple of cropped
  illustration fragments) and it looked flat and slightly wrong: missing
  the gold sun/swallows/botanical artwork entirely in v1, then overlapping
  the title in v2 once the illustrations were added back in (the crop
  boundaries couldn't cleanly separate "title text" from "bird artwork"
  pixel-by-pixel — they occupy overlapping regions of the image). Using
  the artwork directly sidesteps that: pixel-perfect, zero overlap risk.
  Cost: this cover is bespoke to this title, not template-driven — same as
  how professional covers normally work (designed per issue), but worth
  flagging since the rest of the template is meant to be reusable. A new
  **title/colophon page** (page 2, after the cover) now carries what the
  cover doesn't: title/subtitle repeated smaller, authors, draft date, and
  a placeholder copyright/licence line — this is new, not in the
  reference, following up on Rufus's steer to think about that page.
- Body pages: **sans-serif throughout** (not serif — that was my first guess
  and it was wrong; the reference uses one sans family for everything).
  Heading colour `#4C2E2D` (dark maroon), body ink `#3A2C2B`, italics/quotes
  in dusty rose `#B5677E`, footer in muted brown-grey `#8A7370` — all sampled
  by averaging pixel colour under the reference's rendered glyphs.
- Layout: no running header, footer only (bold title + subtitle, page number
  right-aligned); asymmetric margins (wide left ~5.3cm, narrower right
  ~2.6cm); no rule under headings; chapter headings in ALL CAPS with the
  number stripped, sub-numbered headings (`9.1`, `10.2`, ...) keep their
  number and render smaller — this two-level split isn't visible in the raw
  Markdown (Google Docs exports every heading as `#`), `clean.py` now
  reconstructs it from the numbering pattern.
- Page breaks: the reference clearly honours the source's manual page
  breaks (e.g. Back-story starts on its own fresh page) — these exported as
  empty `#` headings in the raw Markdown and were being silently discarded
  by the first version of `clean.py`. Now preserved as real `#pagebreak()`
  calls via Pandoc's raw-block passthrough.

**Remaining gap:** the reference's heading typeface is a rounded geometric
sans (reads like Fredoka / Baloo 2 / Poppins ExtraBold — bubble-shaped
terminals, very distinct from the reference cover's headline down through
every section heading). This sandbox has no network access to fetch Google
Fonts, so headings currently fall back to Liberation Sans Bold, which is
markedly squarer/plainer. **This is the single biggest thing missing for a
close visual match** — swapping it in is a one-line change in
`typst/report.typ` (`sans-bold` variable) once the font file is available;
happy to try again from an environment with net access, or if you can drop
the `.ttf`/`.otf` file(s) in here directly.

## Pandoc+LaTeX vs Typst — first impressions (why Typst won)

Both produced a genuinely presentable report on the first real attempt, cover
included.

**Typst** — much faster to iterate (sub-second recompiles, clear
source-located error messages, no TeX package-download purgatory), styling
reads like normal code (`show` rules) rather than macro archaeology, and
covers footnotes/bibliographies natively (see "Decision" above). Smaller
ecosystem than LaTeX's — fewer existing citation styles, less prior art —
but nothing this project needs is missing.

**Pandoc + LaTeX (Tectonic)** — more ceremony (fontspec/titlesec/fancyhdr/
hyperref plumbing), but the well-worn path if the reports ever need
print-on-demand-specific packages or exotic bibliography styles beyond what
Typst ships. Tectonic itself sidesteps the classic "install 4GB of TeX Live"
pain — fetches only the packages actually used, once, then caches them. Left
working in `pandoc-latex/` as a fallback; not getting further design
investment right now.

## Known gaps / next steps

- **Heading font** — biggest visual gap, see "Brand" above.
- **Copyright/licence line is placeholder text** — needs a real decision
  (All Rights Reserved? CC BY-SA? something else?) before this ships.
- **Cover is bespoke, not templated** — see "Brand" above. Fine for this
  prototype (imitating one specific reference), but a real reusable
  template needs either a designer producing per-report cover art, or a
  simpler generated-cover fallback style for reports without bespoke art.
- No Google Docs → Markdown step exercised yet (source was already
  Markdown) — that's the other half of the real pipeline and its own
  source of lossiness (esp. tables/footnotes/comments).
- No footnotes, tables, or bibliography in this sample essay — Typst's
  support confirmed with a standalone test doc, not yet wired into
  `typst/report.typ`.
- `clean.py` is specific to this one export's quirks (including the
  N./N.M heading-level reconstruction) — a real pipeline needs a more
  general Google-Docs-export cleaner, or this needs to become closer to
  general-purpose.
- Print-on-demand trim size / bleed not addressed (currently A4 for
  on-screen reading).
- Reference comparison was done by eye + pixel-sampling colours from
  rendered PNGs — good enough for a first pass, not pixel-perfect.
