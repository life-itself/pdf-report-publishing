---
name: pdf-report
description: Use when turning Markdown (often a Google Docs export) into a typeset PDF report — essays, evidence reviews, policy briefs. Picks one of three specified template styles, builds it with Typst, and produces a PDF that reads as designed rather than as a word-processor export.
---

# Typeset a report from Markdown

This skill is a map, not a method. The method is written down in
`docs/`, and the whole value of this repository is in those documents —
the principles extracted from three well-typeset reports, and the three
template styles that take positions on them. **Read them; do not
improvise a design.**

## The one-paragraph version

Choose a style (Review, Essay or Brief). Read its spec. Clean the
Markdown, convert it with Pandoc, compile it against that style's Typst
implementation. Then do the editorial pass — choosing which sentences
become pull quotes and which numbers become key figures — because that is
the part no template can do and the part that makes the difference.

## Step 1 — Choose the style

Ask what the document is *for*:

| The reader is expected to… | Style | Character |
|---|---|---|
| **check** it — data, citations, sources | **Review** | Serif body, working left rail for sources, mono apparatus, justified |
| be **carried through** an argument | **Essay** | Display serif over reading serif, warm paper, pull quotes, prose indents |
| **act** on it, reading only some of it | **Brief** | Two sans faces, short measure, key-message boxes, footnotes, colophon |

A document that wants all three has not decided what it is. Pick the
dominant mode.

Show the user `output/style-comparison.pdf` if they want to choose by
looking. It renders the same page of content in all three styles, through
the real templates, with the real page furniture intact.

## Step 2 — Read the spec

**This is not optional and it is not skimmable.** Read, in order:

1. `docs/report-design-principles.md` — the ten principles the styles are
   positions on, each cited to a page of an exemplar report you can open.
   Read this even if you have read it before; it is what stops a design
   decision from being a guess.
2. `docs/styles/<style>.md` — the chosen style in full: grid in
   millimetres, type scale in points, palette with a named job per colour,
   page furniture, structural elements, setting rules, and an explicit
   list of what would break the style.
3. `docs/typst-cookbook.md` — only when you hit a mechanical problem
   (leading, rails, drop caps, footnotes, tables, counters). It is a
   reference, not a read-through.

If the spec and the implementation disagree, the spec is the artefact and
the implementation is the proof — fix whichever is wrong, and say which.

## Step 3 — Prepare the Markdown

A Google Docs export is not clean Markdown. `scripts/` recovers what the
export lost:

```sh
python3 scripts/clean.py       # manual TOC, escaped punctuation, heading levels
python3 scripts/figures.py     # bare images -> numbered, captioned figures
python3 scripts/quotes.py      # italic paragraphs -> block quotations
python3 scripts/definitions.py # "» **Term**" lines -> definition items
```

Each of these is a *structural* recovery: the author's intent is visible
in the source but not in its markup. See the README's "Known gaps" for the
conventions that are deliberately not guessed at.

## Step 4 — Build

```sh
typst compile --font-path fonts --root . typst/examples/essay-example.typ out.pdf
```

For a real document, copy an example as a starting point — it already
imports the style's devices and shows each in use:

- `typst/examples/review-example.typ`
- `typst/examples/essay-example.typ`
- `typst/examples/brief-example.typ`

The style implementations are `typst/lib/styles/<style>.typ`; the small
amount of shared technique is `typst/lib/util.typ`.

Rebuild every artefact with `typst/build-examples.sh`.

Always pass `--font-path fonts`. Typst falls back silently to system fonts
otherwise, and the same source will produce visibly different PDFs on
different machines.

## Step 5 — The editorial pass

This is the step that gets skipped and it is the one that matters.

Every style has a **signature interruption** — the device that stops a
long argument becoming a grey slab. Review has the inventory list and the
marginal note; Essay has the standfirst and the pull quote; Brief has the
key-message box and the key figure. All of them require someone to decide
*which* sentence or number gets lifted, and that is a content judgement.

Budget about thirty minutes per chapter with an author. Concretely:

- one standfirst per chapter — often an existing `**Claim: …**` paragraph;
- one or two pull quotes per chapter, lifted **verbatim** from the prose
  beside them, never two on a spread;
- key figures only for numbers the body text already states — the rail
  restates, it never introduces;
- a source line on every figure. A figure without one looks unsourced even
  when the text cites it.

## Step 6 — Check it

Render pages and look at them; do not trust that it compiled.

```sh
pdftoppm -png -r 80 out.pdf /tmp/page
```

The checks that catch most of what goes wrong:

- Is the page furniture on **every** page, including inverted, full-bleed
  and back-matter pages, in exactly the same place?
- Does anything overlap? Placed rail material reserves no vertical space
  and will happily sit under a wide figure.
- Are headings hyphenating? (`PARADIG-MATIC` is the classic tell.)
- Does the measure land between 60 and 75 characters?
- Is there a page with nothing on it but body text for three pages
  running? That is where an interruption belongs.

## What not to do

- Do not invent a fourth style. If a document needs one, write the spec
  first, as a Markdown document, and get it read before writing any Typst.
- Do not mix devices across styles. Every spec has a "what would break
  this style" section; those are not stylistic preferences, they are the
  coherence conditions.
- Do not add a colour that cannot be described as "the colour of X".
- Do not add an element that will not appear on at least ten pages doing
  exactly the same job. That is decoration, and it cheapens the pages that
  do not have it.
