---
updated: 2026-08-27
---

# The pipeline

How a Markdown document becomes a typeset PDF. The design side is in
`docs/report-design-principles.md` and `docs/styles/`; this is the
plumbing.

```
source/what-is-2r.md
  │
  ├─ scripts/editorial.py     apply standfirst / pullquote marks (sidecar)
  ├─ scripts/figures.py       bare images   -> numbered, captioned figures
  ├─ scripts/quotes.py        italic paras  -> block quotations
  ├─ scripts/definitions.py   "» **Term**"  -> definition items
  │
  ├─ pandoc                   markdown -> typst markup
  ├─ fixups                   imports, asset paths, bare image widths
  │
  └─ typst compile            typst/essay-main.typ -> output/what-is-2r.pdf
```

Run it with `typst/build.sh`. `typst/build-examples.sh` builds the four
style artefacts instead.

## The recovery passes

A Google Docs export is not clean Markdown. Each pass recovers something
the export lost — a case where the author's intent is visible in the source
but not in its markup.

**`clean.py`** turns a raw export into proper Markdown: strips the manual
hyperlinked TOC, un-escapes Google-Docs punctuation (`\.`, `\-`),
reconstructs the two-level heading structure (`N.` chapters vs `N.M`
subsections — the export flattens both to `#`), and preserves the source's
manual page breaks, which arrive as empty `#` headings and were being
silently discarded by the first version.

**`figures.py`** reconstructs figures. An image gets a number, a caption, a
rule marking its extent, and a width derived from its own pixel dimensions
— Google Docs exports full-width images at 624px, so `px/624` recovers the
size the author chose, rather than stretching everything to the column. A
run of adjacent captioned images becomes one `figrow()`: the
Cimabue/Perugino/Picasso trio is one three-panel figure, not three stacked
full-width images.

**`quotes.py`** recovers block quotations. The essay's four long quotations
were typed as ordinary paragraphs wrapped in italics with the attribution
on its own line — so Markdown sees emphasis, not a quotation, and an early
build rendered them as several hundred words of rose italic. They now set
as proper block quotations.

**`definitions.py`** recovers the six principles typed as `» **Term**` with
the description on the next line — which Markdown sees as a bold run inside
an ordinary paragraph, complete with a stray guillemet.

**`editorial.py`** is the odd one out: it *adds* a judgement the source
never contained rather than recovering one, which is why it reads from a
sidecar. See `docs/decisions.md` and
[#1](https://github.com/life-itself/pdf-report-publishing/issues/1).

Ordering matters — `editorial.py` runs first, on pristine paragraphs,
before anything else rewrites them.

## Two things that will bite you

**Fonts must be vendored.** Left to itself Typst falls back silently to
whatever the machine has: the same source produced Liberation Sans in one
sandbox and a system serif on macOS, with no warning beyond an
`unknown font family` line in a wall of output. Everything lives in
`fonts/` with its OFL text, and every build passes `--font-path fonts`.

**Asset paths resolve relative to the file calling `image()`** — which is
the style library, a directory deeper than the old engine. The build
rewrites asset paths to root-absolute and compiles with `--root .`.

More of this kind of thing in `docs/typst-cookbook.md`.

## Layout

```
source/            cleaned Markdown + image assets
scripts/           the recovery passes above
fonts/             vendored open-licence families + OFL texts
typst/lib/         util.typ + the three style implementations
typst/examples/    one example document per style
typst/compare.typ  the same content in all three styles
docs/              design principles, style specs, decisions, this file
reference/         the exemplar reports and the original designer target
output/            built PDFs, committed so they are viewable without a toolchain
pandoc-latex/      the LaTeX fallback pipeline (see docs/decisions.md)
```

`typst/main.typ`, `typst/report.typ` and `typst/theme.typ` are the
superseded v3 single-template engine, still building
`output/what-is-2r-typst.pdf` via `./build.sh v3`. They go once the Essay
build is signed off.
