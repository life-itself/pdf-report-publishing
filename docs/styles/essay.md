---
style: essay
updated: 2026-08-16
derived-from: CRI chapter openers + MI standfirsts — see docs/report-design-principles.md
---

# Style: Essay

> Literary, warm, unhurried. A display serif over a reading serif on warm
> paper, a single generous column, and one accent used only on rules and
> numerals. For long-form argument — essays, book chapters, thought
> pieces — where the job is to carry a reader through thirty pages
> without them noticing the typography.

**Character in one sentence:** it should read like a good paperback, not
like a deliverable.

This is the style for the *What is the Second Renaissance?* essay.

## 1. Page grid

A4, 210 × 297 mm, **two-sided**: margins mirror, so the inner margin is
the binding side. If output is single-sided, use the recto values on every
page.

| Margin | Recto (odd) | Verso (even) |
|---|---|---|
| Inner | 42mm (left) | 42mm (right) |
| Outer | 48mm (right) | 48mm (left) |
| Top | 26mm | 26mm |
| Bottom | 26mm | 26mm |

Text column: **120mm**, which at the specified body size is **≈65
characters** — the middle of the comfortable range.

The outer margin is slightly wider than the inner. This is the classical
proportion and it matters: it puts the text block visually centred on the
spread rather than mathematically centred on the leaf, and it leaves the
thumb somewhere to go.

Nothing lives in the margins except the running head and the folio. This
style **commits** to empty margins (principle 2, the PCI position) rather
than working them.

## 2. Type

| Voice | Family | Where |
|---|---|---|
| Display | **Fraunces** | Chapter titles, section heads, pull quotes, drop cap |
| Body | **Literata** | Running prose, block quotations, notes |
| Furniture | **Work Sans** | Running head, folio, captions only |

Fraunces is a high-contrast "soft serif" with an old-style roman feel —
the open-licence stand-in for the kind of face that would otherwise be
Restora. Literata is designed for long-form reading and holds up over
thirty pages better than any of the alternatives vendored here.

| Element | Family | Size | Weight | Leading | Notes |
|---|---|---|---|---|---|
| Chapter number | Fraunces | 11pt | 400 | — | Roman numerals, `accent`, tracked +0.2em, centred above the title |
| Chapter title | Fraunces | 26pt | 500 | 1.15× | Ranged left, hyphenation off, optical size axis at display end |
| Standfirst | Fraunces | 13.5pt | 400 | 1.45× | Italic, `muted-ink`, ragged right, max 4 lines |
| Section head | Fraunces | 13pt | 600 | 1.25× | 1.8em above, 0.6em below |
| Sub-section head | Literata | 10.5pt | 700 | 1.3× | Small; italic if a third level is needed |
| Body | Literata | 10.5pt | 400 | 1.5× | Justified, hyphenated |
| Drop cap | Fraunces | 3 lines | 400 | — | `accent`; first paragraph of a chapter only |
| Block quotation | Literata | 9.8pt | 400 | 1.45× | Indented 8mm left only, 0.9em space around |
| Pull quote | Fraunces | 17pt | 400 | 1.3× | Italic, `ink`, ragged right, 12mm rule in `accent` above |
| Definition term | Fraunces | 10.5pt | 600 | — | Run-in, followed by an em space, then the definition in body |
| Figure caption | Work Sans | 8pt | 400 | 1.35× | `muted`, ranged left under the figure |
| Running head | Work Sans | 7.5pt | 400 | — | Tracked +0.12em, small caps effect via uppercase, `muted` |
| Folio | Work Sans | 9pt | 400 | — | `muted` |
| Footnote | Literata | 8pt | 400 | 1.4× | Hanging number |

Paragraphs after the first in a section are **indented 1.2em with 0.55em
between** — the book convention. Paragraphs immediately after a heading, a
quotation, a figure or the drop-capped opening are not indented, which is
also the book convention: an indent marks a new paragraph, and the first
paragraph after an interruption is not competing with anything above it.

The indent is the single strongest signal that a document is set as prose
rather than assembled as a report, and it is worth the implementation
cost.

## 3. Colour

Four values, plus black-adjacent ink. The style is essentially monochrome;
the accent appears perhaps five times per chapter.

| Token | Hex | Job |
|---|---|---|
| `page` | `#FCFAF6` | Warm off-white paper |
| `ink` | `#23201C` | Body text — warm near-black, never pure black |
| `muted-ink` | `#5C554C` | Standfirsts, block quotations |
| `muted` | `#8A8177` | Running head, folio, captions |
| `accent` | `#B4472A` | Chapter numerals, drop cap, pull-quote rule, links |
| `rule` | `#DED7CB` | Hairlines |

The accent is a vermilion: warm without being brown, saturated enough to
register at 11pt, dark enough not to look like highlighter. It is
deliberately **not** used on headings — headings are ink. Colour marks
*structure* (numbers, rules, the drop cap) and nothing else.

The warm paper does real work. Pure white at 10.5pt over 120mm is glary in
print and on screen; `#FCFAF6` reads as softer without lightening the
text, and it makes the vermilion sit down rather than vibrate.

## 4. Page furniture

Deliberately minimal — this style's restraint is the point (principle 1
says furniture must be *chosen*, not that there must be a lot of it).

- **Running head**, in the top margin, aligned to the text column's outer
  edge: on verso pages the report title, on recto pages the current
  chapter title, both uppercase, tracked, `muted`, Work Sans 7.5pt.
- **Folio**, in the bottom margin, centred on the text column, Work Sans
  9pt `muted`.
- **No running head or folio on a chapter opening page** — the opener's
  air is the furniture there. The folio still counts.

That is the entire furniture set. Three elements, no rules, no logo on
interior pages.

## 5. Structural elements

**Chapter opener.** Roman numeral in `accent`, centred over the text
column. Then the chapter title in Fraunces 26pt, ranged left. Then the
standfirst if there is one. Then 14mm of air — which with the numeral and
the standfirst above it puts the body's first line about a third of the
way down the page — then the body opening with a three-line drop cap in
`accent`. The first line after
the drop cap is set in small capitals (uppercase at 0.82em with +0.06em
tracking) for its first four or five words — the classic entry into a
chapter, and cheap to implement.

**Pull quote** — the signature interruption. A sentence lifted verbatim
from the surrounding prose, set in Fraunces 17pt italic, ragged right,
indented 8mm, with a 12mm × 1pt `accent` rule above it and 1.4em of space
either side. No quotation marks — the type change is the quotation mark.
One or two per chapter, never two on a spread. Attribution only if the
quote is from someone other than the author, in Work Sans 8pt `muted`
beneath.

**Standfirst.** The chapter's claim in a sentence or two, Fraunces 13.5pt
italic `muted-ink`, ragged right, directly under the title. Where the
source has a `**Claim: …**` paragraph, that is the standfirst.

**Block quotation.** Indented 8mm on the left only, ragged right, in
Literata 9.8pt `muted-ink`. Attribution on its own line, ranged left,
Work Sans 8pt `muted`, preceded by an em dash.

**Figure.** Image at text-column width or narrower, ranged left; caption
directly beneath in Work Sans 8pt `muted`, with the figure number in the
same size at weight 600 in `ink`. A `rule` hairline under the caption
closes the object. Source, if any, appended to the caption in italic —
this style has no rail to hang it in.

**Footnotes.** At the foot of the page, above a 20mm `rule` hairline,
Literata 8pt, numbers hanging. Prefer footnotes to endnotes: an essay's
asides are part of the reading, not apparatus to be checked.

## 6. Setting

- Justified, `hyphenate: true`, at 120mm in Literata. Preconditions from
  principle 7 all satisfied.
- Hyphenation off on all headings, standfirsts and pull quotes.
- Ragged right on standfirsts, pull quotes and block quotations — the
  short, large, italic settings where justification would open rivers.
- Widow/orphan minimum two lines.
- Honour the author's manual page breaks. Chapters start recto if
  two-sided.

## 7. What would break this style

- Boxes. Any boxed, tinted or ruled panel destroys the register
  immediately. If content needs a box, it needs the Brief style.
- Colouring the headings. Ink headings with a coloured numeral is the
  whole trick; coloured headings turn it into a brochure.
- Losing the paragraph indent in favour of space-between. It is the
  cheapest available signal of "prose" and it costs nothing.
- Adding a third heading level beyond sub-section. If the argument needs
  four levels of nesting, it is a review, not an essay.
