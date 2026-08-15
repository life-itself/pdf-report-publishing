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
fonts/                   the seven open-licence families the template uses, vendored
                         with their OFL texts — see fonts/README.md
typst/report.typ         layout engine: page grid, margin column, figures, devices
typst/theme.typ          palette + the four type presets
typst/specimen.typ       one page of real content per preset, for choosing between them
pandoc-latex/            Pandoc -> custom LaTeX template -> Tectonic -> PDF
typst/                   Pandoc -> Typst markup -> custom Typst template -> PDF
                         (this is the live pipeline — see "Decision" below)
reference/               designer-what-is-2r.pdf — Rufus's target reference, a
                         professionally typeset version of this same essay,
                         downloaded from Drive for comparison. Not our output.
docs/                    typography-research.md — what the exemplar reports do, and
                         why v3 makes the choices it does
output/                  built PDFs (both pipelines, committed so they're
                         viewable without a local toolchain)
```

Run `typst/build.sh` to rebuild, optionally with a type preset:

```sh
typst/build.sh              # default preset (warm)
typst/build.sh editorial    # any of: warm | editorial | modern | display
```

`pandoc-latex/build.sh` still builds the fallback LaTeX pipeline. Both read
from the same `source/what-is-2r.md`.

To compare the four type presets side by side:

```sh
typst compile --font-path fonts typst/specimen.typ output/type-specimen.pdf
```

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

## Design (template v3)

No style guide exists yet (that's [#1276](https://github.com/life-itself/community/issues/1276),
still open). v2 was matched structurally against
`reference/designer-what-is-2r.pdf` and got the palette and page shape
right, but read as flat. v3 is a typesetting pass informed by three other
reports off Rufus's Are.na board — see `docs/typography-research.md` for
what they do and why. The three changes that matter:

**1. Serif body, sans for headings and furniture.** Every exemplar that
reads as high-class does this; v2 was sans throughout, which is a large
part of why a long-form argument read like an overgrown slide deck. Four
type presets live in `typst/theme.typ`; `output/type-specimen.pdf` shows
the same real page in each. Current default is `warm` (Baloo 2 / Spectral)
on brand-continuity grounds — Baloo 2 stands in for the reference's
rounded geometric heading face — but `editorial` (Work Sans / Literata) is
the better typography and `display` (Fraunces / Source Serif 4) the more
beautiful. **This is the open question for Rufus.**

**2. The wide left margin does work now.** A 32mm margin column carries
figure numbers, captions, chapter numbers and folios, giving the page a
left-hand rail. v2 inherited the reference's 5.3cm left margin and left it
empty, which reads as a mistake rather than as generosity.

**3. Justified and hyphenated.** v2 was ragged-right and unhyphenated —
the word-processor default, and the thing that most reliably signals "not
typeset". Hyphenation is explicitly disabled on headings.

Page grid (A4, 210mm): 18mm edge · 32mm margin column · 8mm gutter · 122mm
text (~72 characters) · 30mm outer.

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

- **Which type preset** — the one live design decision. See "Design"
  above and `output/type-specimen.pdf`.
- **Copyright/licence line is placeholder text** — needs a real decision
  (All Rights Reserved? CC BY-SA? something else?) before this ships.
- **Cover is bespoke, not templated** — see "Design" above. Fine for this
  prototype (imitating one specific reference), but a real reusable
  template needs either a designer producing per-report cover art, or a
  simpler generated-cover fallback style for reports without bespoke art.
- **Some Google Docs conventions are still un-recovered.** Section labels
  typed as bold lines (`**Features**`, `**Relationship with truth**`) are
  really headings; the `» **Term**` + description items in chapter 11 are
  really a definition list; the `Modern → … / Postmodern → … /
  Metamodern → …` triads are really a small table. All three currently
  render as ordinary bold paragraphs. Left alone deliberately — the
  heuristics needed to catch them also catch things that aren't them
  (`**Sylvie:**` speaker labels, the long `**Claim: …**` standfirsts), and
  guessing wrong is worse than leaving them plain.
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
