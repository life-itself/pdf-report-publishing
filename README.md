# PDF report publishing — pipeline prototype

First pass at the "Markdown → elegant PDF" workflow tracked in
[life-itself/community#1269](https://github.com/life-itself/community/issues/1269).
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
scripts/figures.py       bare Markdown images -> numbered, captioned `#fig()` /
                         `#figrow()` calls (see "Figures" below)
scripts/quotes.py        italic paragraphs -> `#blockquote()` calls (see "Quotes")
scripts/definitions.py   `» **Term**` lines -> `#dfn()` calls (see "Definition lists")
fonts/                   the seven open-licence families the template uses, vendored
                         with their OFL texts — see fonts/README.md
docs/                    the design work — principles, three style specs, Typst
                         technique. This is where the value of the repo is.
typst/lib/util.typ       the small amount of technique the three styles share
typst/lib/styles/*.typ   the three styles implemented
typst/examples/*.typ     one example document per style, built from real content
typst/compare.typ        the same content in all three styles, real furniture intact
typst/build-examples.sh  builds all four style PDFs
skills/pdf-report/       SKILL.md — choose a style, read its spec, build, edit
typst/report.typ         v3 single-template layout engine (superseded, still builds
typst/theme.typ           output/what-is-2r-typst.pdf — see NEXT.md)
pandoc-latex/            Pandoc -> custom LaTeX template -> Tectonic -> PDF
reference/exemplars/     the three published reports the design is derived from
reference/               designer-what-is-2r.pdf — Rufus's original target reference.
                         The styles now depart from it deliberately.
output/                  built PDFs, committed so they're viewable without a
                         local toolchain
```

Build the style artefacts:

```sh
typst/build-examples.sh
```

Build the full 2R essay through the v3 single-template engine:

```sh
typst/build.sh              # still the only path that runs the Markdown pipeline
```

`pandoc-latex/build.sh` still builds the fallback LaTeX pipeline. Both read
from the same `source/what-is-2r.md`.

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

## Design: three template styles

The design work is documented, not just implemented. Read in this order:

1. **`docs/report-design-principles.md`** — ten principles extracted by
   reading pages of three published reports
   (`reference/exemplars/`), each claim cited to a page you can open.
   The largest finding: **page furniture** is what separates a report from
   a Word document, and it is almost entirely independent of typeface.
2. **`docs/styles/README.md`** and the three specs beside it — Review,
   Essay and Brief. Each is a full specification: grid in millimetres,
   type scale in points, palette with a named job per colour, page
   furniture, structural elements, setting rules, and an explicit list of
   what would break the style.
3. **`docs/typst-cookbook.md`** — the mechanical reference.

| Style | Use it for | Character |
|---|---|---|
| **Review** | Evidence reports, research reviews | Serif body pushed right off a working left rail carrying sources; mono apparatus; justified |
| **Essay** | Long-form argument, essays, book chapters | Display serif over reading serif on warm paper; standfirsts, pull quotes, drop caps, prose indents |
| **Brief** | Position papers, policy briefs | Two sans faces, short measure, key-message boxes, footnotes, mono colophon |

Each has an example PDF built from real content — `output/style-*.pdf` —
so the specs are checkable rather than asserted.
`output/style-comparison.pdf` shows the same page of content in all three,
rendered through each style's real template so the page furniture is
genuine.

All three are brand-independent by design: the palettes are derived from
what the exemplars demonstrated, not from the Life Itself brand, and each
is written so its palette can be swapped without touching the layout.

### Figures

`scripts/figures.py` runs before Pandoc and reconstructs figures the export
lost. An image gets a number, a caption hung in the margin column, a rule
marking its top edge, and a width derived from its own pixel dimensions
(Google Docs exports full-width images at 624px, so `px/624` recovers the
size the author chose) rather than being stretched to the column. A run of
adjacent captioned images becomes one `#figrow()` — the
Cimabue/Perugino/Picasso trio is now a single three-panel figure with
equal-height panels, sized by aspect ratio, instead of three stacked
full-width images.

### Quotes

`scripts/quotes.py` recovers block quotations. The essay's four long
quotations were typed as ordinary paragraphs wrapped in italics, with the
attribution on its own line — so Markdown saw emphasis, not a quotation,
and v2 rendered them as several hundred words of rose italic. They now set
as block quotations: roman, one step down from body size, with a hung
quotation mark in the margin and the attribution in the furniture sans.

### Definition lists

`scripts/definitions.py` recovers the six principles in chapter 11, typed
in the export as `» **Term**` with the description on the next line. They
now set as definition items — a gold marker hung in the gutter, the term
in the furniture sans, the gloss justified beneath — instead of six
bold-then-text lumps with a stray `»` still in them.

### Devices not yet used

`pullquote()`, `standfirst()` and `note()` exist in `typst/report.typ` but
nothing in this essay invokes them, because using them means making
editorial choices about *which* sentences to lift — see `NEXT.md`.

### Inherited from v2 (unchanged, and still right)

Colours and structure were sampled/measured from the designer reference
directly:

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
- Palette: heading colour `#4C2E2D` (dark maroon), italics/quotes in dusty
  rose `#B5677E`, footer in muted brown-grey `#8A7370` — all sampled by
  averaging pixel colour under the reference's rendered glyphs. Body ink
  was `#3A2C2B`; v3 darkens it to `#2E2422`, which was washed out once the
  body moved to a serif.
  (The reference is sans-serif throughout. v3 deliberately departs from it
  here — see "Design" above.)
- Layout: no running header, footer only (title + subtitle, page number);
  asymmetric margins; no rule under headings; chapter headings in ALL CAPS
  with the number stripped, sub-numbered headings (`9.1`, `10.2`, ...) keep
  their number and render smaller — this two-level split isn't visible in
  the raw Markdown (Google Docs exports every heading as `#`), `clean.py`
  reconstructs it from the numbering pattern. v3 keeps the asymmetry but
  puts the wide margin to work and moves the folio into it.
- Page breaks: the reference clearly honours the source's manual page
  breaks (e.g. Back-story starts on its own fresh page) — these exported as
  empty `#` headings in the raw Markdown and were being silently discarded
  by the first version of `clean.py`. Now preserved as real `#pagebreak()`
  calls via Pandoc's raw-block passthrough.

**Resolved since v2:** the reference's heading typeface is a rounded
geometric sans (bubble-shaped terminals, distinct from the cover headline
down through every section heading). v2 had no network access to fetch it
and fell back to Liberation Sans Bold. **Baloo 2** is now vendored in
`fonts/` as the open-licence stand-in and is what the default `warm`
preset uses. It is a close read of the reference, though whether we want
to keep matching the reference here is exactly the open question above —
caps in a rounded extrabold is the loudest of the four presets.

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

- **Which style the 2R essay ships in**, and whether the three palettes
  are right. See "Design" above, `output/style-comparison.pdf`, and
  `NEXT.md` for the specific verdicts worth having.
- **The full essay still builds through the superseded v3 engine**
  (`typst/report.typ`), not through `typst/lib/styles/essay.typ`. Porting
  it means pointing the Pandoc step at the new device names.
- **The editorial pass has not been done** — choosing which sentences
  become standfirsts and pull quotes. This is the largest remaining visual
  gain and no template work substitutes for it.
- **Copyright/licence line is placeholder text** — needs a real decision
  (All Rights Reserved? CC BY-SA? something else?) before this ships.
- **Cover is bespoke, not templated** — see "Design" above. Fine for this
  prototype (imitating one specific reference), but a real reusable
  template needs either a designer producing per-report cover art, or a
  simpler generated-cover fallback style for reports without bespoke art.
- **Some Google Docs conventions are still un-recovered.** Section labels
  typed as bold lines (`**Features**`, `**Relationship with truth**`) are
  really headings; the `Modern → … / Postmodern → … / Metamodern → …`
  triads are really a small table. Both currently render as ordinary bold
  paragraphs. Left alone deliberately — the heuristics needed to catch
  them also catch things that aren't them (`**Sylvie:**` speaker labels,
  the long `**Claim: …**` standfirsts), and guessing wrong is worse than
  leaving them plain. The `» **Term**` definition items *were* safe to
  convert, because that marker is unambiguous.
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
