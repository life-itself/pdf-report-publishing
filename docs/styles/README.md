---
updated: 2026-08-16
---

# Template styles

Three positions on the principles in `docs/report-design-principles.md`.
Each file here is a **specification**, written to be implementable without
seeing the implementation: grid in millimetres, type in points, colour in
hex, and a named list of the elements the style supports.

| Style | Use it for | One-line character |
|---|---|---|
| [`review.md`](review.md) | Evidence reports, research reviews, state-of-the-field documents | Sober and institutional; a working left rail carries sources and notes |
| [`essay.md`](essay.md) | Long-form argument, essays, books, thought pieces | Literary and warm; display serif, generous measure, pull quotes |
| [`brief.md`](brief.md) | Position papers, policy briefs, submissions | Sans-forward and direct; key-message boxes, footnotes, colophon |

All three are:

- **A4** (210 × 297 mm), single-sided page furniture unless noted
- built from **open-licence fonts vendored in `fonts/`**, so a build is
  reproducible on any machine
- **brand-independent** — none of them assume the Life Itself palette.
  Each carries a palette derived from what its exemplar demonstrated,
  and each is written so the palette can be swapped without touching the
  layout.

## The rules that apply to all three

These are shared because breaking them broke earlier versions of this
template.

1. **The page has furniture and the furniture never varies.** Every style
   defines a masthead/footer/folio set that appears on every page
   including inverted and full-bleed ones.
2. **Measure sits between 60 and 75 characters.** The grid is derived from
   that, not the other way round.
3. **Every element on the page belongs to one of exactly three voices**:
   body, display, or furniture. A fourth voice needs a reason written into
   the spec.
4. **A colour must name its job.** If it cannot be described as "the
   colour of X", it does not go in the palette.
5. **Hyphenation is on for body, off for every heading.**
6. **Figures are objects, not images.** Number, caption, source, extent —
   all four or it is not a figure.

## Choosing between them

Ask what the document is *for*.

- If the reader is expected to check it — data, citations, sources — the
  answer is **Review**. The left rail exists so a source credit never
  interrupts a sentence.
- If the reader is expected to be carried through an argument, the answer
  is **Essay**. It has the fewest devices and the most air.
- If the reader is expected to act on it, and probably to read only some
  of it, the answer is **Brief**. Everything in it is built for skimming:
  boxed key messages, short measure, tight sections.

A document that wants all three is a document that has not decided what it
is. Pick the dominant mode.
