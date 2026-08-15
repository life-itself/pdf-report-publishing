---
style: review
updated: 2026-08-16
derived-from: CRI, *Reality Check* — see docs/report-design-principles.md
---

# Style: Review

> Sober, institutional, checkable. A serif body pushed right off a working
> left rail that carries sources, figure topics, chapter numbers and the
> folio. For evidence reports and research reviews — documents whose
> credibility depends on the reader being able to see where every claim
> came from.

**Character in one sentence:** it should look like it was produced by an
institute rather than by a person, and like every number in it has a
citation attached.

## 1. Page grid

A4, 210 × 297 mm. All measurements from the physical page edge.

```
  0        14mm        44mm  52mm                        190mm   210mm
  |         |           |     |                            |       |
  |  edge   |   RAIL    | gut |        TEXT COLUMN         | outer |
  |         |   30mm    | 8mm |          138mm             | 20mm  |
```

| Region | From | Width | Contents |
|---|---|---|---|
| Rail | 14mm | 30mm | Logo, chapter number, figure topic, source credits, folio. All **right-aligned** against the gutter. |
| Gutter | 44mm | 8mm | Empty, always. |
| Text | 52mm | 138mm | Body, headings, figures (figures may push left into the rail). |

Vertical: top margin **22mm**, bottom margin **20mm**. The masthead sits
in the top margin, the footer and folio in the bottom margin.

Measure at the specified body size is **≈74 characters** — the top of the
comfortable range, which is what CRI does and what a serif at this leading
supports.

## 2. Type

| Voice | Family | Where |
|---|---|---|
| Body | **Source Serif 4** | Running prose, block quotations, chapter openers |
| Furniture | **Work Sans** | Subheads, captions, masthead, footer, rail |
| Apparatus | **DM Mono** | Endnotes, dates in the footer, data labels |

Three voices, each with one job (principle 6). The hierarchy deliberately
**switches family as it descends**: chapter titles are serif, subheads are
sans. A subhead can therefore never be misread as a small chapter title.

| Element | Family | Size | Weight | Leading | Notes |
|---|---|---|---|---|---|
| Chapter title | Source Serif 4 | 30pt | 400 | 1.12× | Outdented into the rail; hyphenation off |
| Chapter number | Work Sans | 9pt | 600 | — | In the rail, right-aligned, muted, tracked +0.08em, zero-padded (`04`) |
| Section head | Work Sans | 10.5pt | 700 | 1.3× | Accent-dark; 1.6em space above, 0.5em below |
| Sub-section head | Work Sans | 9.5pt | 600 | 1.3× | Muted; 1.1em above |
| Body | Source Serif 4 | 10pt | 400 | 1.42× | Justified, hyphenated |
| Lead paragraph | Source Serif 4 | 10pt | 400 | 1.42× | First paragraph after a chapter title gets a 2em first-line indent; no other paragraph is indented |
| Block quotation | Source Serif 4 | 9.4pt | 400 | 1.4× | Indented 8mm both sides, 0.8em space around, no quote marks |
| Inventory list | Work Sans | 9pt | 400 | 1.45× | The change-of-voice device — see §5 |
| Figure caption | Work Sans | 8pt | 400 | 1.35× | |
| Rail note | Work Sans | 7.5pt | 400 | 1.4× | Italic, right-aligned, muted |
| Folio | Work Sans | 13pt | 400 | — | Rail, bottom, muted. Deliberately large. |
| Footer | DM Mono 8pt + Work Sans 8pt/600 | — | — | — | `2026.08.16 | Section Name` |
| Endnote | DM Mono | 7.5pt | 400 | 1.5× | Hanging number in the rail-side indent |

Paragraphs are separated by **1.45em** (Typst's `par.spacing`, which is
the gap between paragraph blocks, not an addition to the leading) and are
not indented, except the lead paragraph after a chapter title. That lead
paragraph is marked explicitly in the source with `#lead[…]` rather than
inferred: a show rule that tracks "am I the first paragraph" needs mutable
state read during layout, which is the kind of thing that fails to
converge.

## 3. Colour

Five values. Each names its job.

| Token | Hex | Job |
|---|---|---|
| `page` | `#FFFFFF` | Paper |
| `ink` | `#1B2226` | All body text |
| `muted` | `#7C858B` | Furniture, rail, captions, folio |
| `accent` | `#2A6E7A` | Links, source names, figure numbers, section heads |
| `rule` | `#D7DCDE` | Hairlines above figures and under the masthead |

Plus one inversion pair, used **only** on a full-bleed summary page:

| Token | Hex | Job |
|---|---|---|
| `dark` | `#16242A` | Inverted page ground |
| `dark-accent` | `#8ECFC2` | The key claim on an inverted page |

Nothing else is coloured. Body text is never accent-coloured; bold is
bold, not blue.

## 4. Page furniture

Present on **every** page, including inverted ones, in exactly these
positions.

- **Masthead**, centred over the text column, in the top margin: two
  lines, `Publisher` in Work Sans 7.5pt/600 and `Report title` in Work
  Sans 7.5pt/400 beneath, both `muted`, leading 1.25×.
- **Logo/wordmark**, top of the rail, left-aligned to the rail's left
  edge (the one exception to right-aligned rail material): Work Sans
  7.5pt/400, tracked +0.14em, uppercase, `muted`, up to three lines.
- **Folio**, bottom of the rail, right-aligned: Work Sans 13pt, `muted`.
- **Footer**, centred under the text column: publication date in DM Mono
  8pt `muted`, a `|`, then the current section name in Work Sans 8pt/600
  `muted`.

The footer's section name updates at each chapter. That is the only
element on the page that changes as you read, and it is the reason the
furniture is worth having.

## 5. Structural elements

**Chapter opener.** Zero-padded number in the rail, sitting *above* the
title's first line rather than level with it — the title outdents all the
way to the rail's right edge, so anything level with it would touch. Title
in the body serif at 30pt, outdented to start at the rail's right edge —
i.e. 8mm left of the text column — over as many lines as it needs. Then
26mm of air before the lead paragraph, which carries a 2em first-line
indent; with the 18mm above the title, that puts the body's first line
about a third of the way down the page. No rule, no colour.

**Inventory list** — the signature interruption. A run of parallel
statements set as a list in Work Sans 9pt, indented 6mm from the text
column, with a lead-in line above it in Work Sans 9pt/600 `accent`
(e.g. *This kind of mind …*). Markers are a thin mid-dot in `muted`.
Space of 1.2em above and below. Use it where prose would otherwise
enumerate; do not use it for ordinary bullet lists, which stay in the
body serif.

**Marginal note.** Any short annotation hung in the rail, right-aligned,
Work Sans 7.5pt italic `muted`, vertically aligned with the line it
annotates. Source credits are a special case: the word `Source:` in
`muted`, the source name beneath in `accent` italic, and a permission
line (`Used by permission.`) beneath that if needed.

**Figure.** Anatomy, in order: a `rule` hairline the full width of the
text column marking the figure's top; the image; the caption below in
Work Sans 8pt, prefixed by `FIG. 04` in Work Sans 8pt/600 `accent`. The
source credit does **not** go under the caption — it goes in the rail,
aligned with the top of the image. Figures may push left into the rail to
run 176mm wide; when they do, the source credit moves to bottom-right,
below the figure, right-aligned.

**Table.** No vertical rules, no fill. A 0.6pt `ink` rule above and below
the header row and a 0.6pt `rule` hairline below the last row. Header in
Work Sans 8.5pt/600; cells in DM Mono 8.5pt if numeric, Source Serif 9pt
if textual. Numeric columns right-aligned on the decimal.

**Inverted summary page.** Full-bleed `dark`. Furniture reversed to
`muted` at 70% opacity. The key claim set in Source Serif 4 at 19pt in
`dark-accent`, preceded by a 22mm × 1.2pt rule on the same line as its
first words (a hanging dinkus). Body beneath in `page` at normal size.
Use once, for an executive summary.

**Endnotes.** A chapter's worth per page-run at the back, under a section
head. Numbers hang 8mm left of the note text, in DM Mono 7.5pt `muted`;
note bodies in DM Mono 7.5pt `ink`. Multiple sources within one note are
separate paragraphs with 0.5em between.

## 6. Setting

- Justified, `hyphenate: true`, in the body serif at 138mm. This is the
  one style of the three that justifies, and it satisfies all three
  preconditions from principle 7 (serif, hyphenation, long measure).
- Hyphenation **off** on every heading, the masthead and the footer.
- Widow/orphan control: minimum two lines either side of a page break.
- A chapter always starts on a new page.
- Back matter (notes, bibliography, appendices) gets the chapter opener
  without a number: it is not part of the argument's sequence.

## 7. What would break this style

- Filling the rail with decoration instead of annotation. An empty rail is
  bad; a rail full of ornament is worse.
- Adding a second accent colour. The whole effect is one cool accent
  against black on white.
- Setting the subheads in the serif. The family switch down the hierarchy
  is what makes three heading levels legible without size inflation.
- Ragged-right body. At 138mm the ragged edge is too loose to read as
  intentional.
