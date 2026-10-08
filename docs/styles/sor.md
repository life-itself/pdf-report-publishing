---
style: sor
updated: 2026-10-08
derived-from: the SoR design system (life-itself/design, projects/sor-design-system/)
---

# Style: SoR (Seeds of Renaissance papers)

> Ink on white, a grounded sans for reading, Polyamine for titles, Restora
> for heads and quotations. For the Seeds of Renaissance paper series.

Unlike the other three styles, this one is **not specified here**. The look
is decided in the design repo and this repo renders it (see
`docs/decisions.md`, "The look comes from the SoR design system"). The
spec is:

| What | Where (design repo, `projects/sor-design-system/`) |
|---|---|
| Page sequence, recto starts, running heads, numbering | `print.md`, "Anatomy of a paper" |
| One white PDF for screen, links, covers in the file | `print.md`, "One PDF, for reading on screen" |
| Series line, credits, what goes on covers | `print.md`, "Covers and credits" |
| Every size, margin and colour | `system/tokens.css`, the `--print-*` block and the base palette |
| What each page looks like | `examples/print/index.html` (approved 2026-10-08) |
| The four faces and their jobs | `type.md` |

Change a value there first, then here. Implementation:
`typst/lib/styles/sor.typ`; a paper's settings: `typst/papers/<name>.typ`;
build: `typst/build-paper.sh <name>`.

## How the paper's Markdown maps to the page

`scripts/sor.lua` reads the structure from conventions in the paper's
Markdown and fails on anything it does not recognise.

| Markdown | Becomes |
|---|---|
| frontmatter | title page, imprint, running heads, colophon: `title`, `subtitle`, `series`, `series_number`, `subseries`, `part`, `authors`, `organisation`, `version`, `published`, `year`, `url`, `licence` |
| frontmatter `cover_image` | page 1, full bleed |
| frontmatter `pdf:` block | text only the PDF uses: `series_about`, `thanks`, `credits`, `back_blurb`, `back_about` (blank lines make paragraphs). Plain text, no Markdown |
| `## Summary`, `## Preface` | prelims: opening on a recto, roman folios |
| `## Annotated contents` + nested list with `— summary` | contents page: entries, summaries, page numbers, links |
| `## Introduction` | opening on a recto, arabic folio 1 |
| `## N. Title: after` | chapter opening: numeral, woodcut, "Chapter N", title, the part after the colon (or after a `?`) in italic |
| first `*“quotation”*` straight under a chapter heading | its epigraph |
| `## Conclusion` | opening on a recto |
| `## Further reading`, `## Bibliography`, `## Appendices` | new page; paragraphs in the first two set as references with hanging lines |
| `###`, `####` | section (Restora 19pt), sub-section (Restora 14pt medium) |
| `<aside class="section-summary">` | summary box, "In brief" on the rule |
| `*“quotation”*` + `― Name` or `- Name` | displayed quotation, Restora italic 15pt; over 60 words, 11.5pt |
| image + `*Fig N: Title. Caption*` | plate: full block width between hairlines, "Fig. N", bold title, italic caption |
| footnotes | at the foot, under a 22mm ink rule; marks in red Apfel |

## Look decisions made while building

The approved mockups left a few things open: plates without rules, a
lighter summary box, long quotations, the Bricolage oblique, tables, and
footnote numbering. They were decided building the Wisdom paper and are
recorded in the design repo, `print.md`, "Settled while building the first
paper". Papers are A4 only (`print.md`, "One PDF, for reading on screen").

## Implementation notes

- **Text column on versos.** The mockups mirror the 24/20mm margins. The
  build keeps the text 24mm from the left edge on every page, so on versos
  it sits 4mm right of the mockup. Typst mirrors margins only as a pair,
  and this layout is a measure plus a side column. The running heads and
  folios do follow the mirrored block. The PDF is read on screen one page
  at a time, where the 4mm can't be seen.
- **The Bricolage oblique** is made by `scripts/make-bricolage.py`, which
  also cuts static text-size instances (see `docs/decisions.md`).
- **Restora** is taken from `fonts/licensed/` or the installed fonts, with
  Fraunces as the fallback. Typst picks the nearest weight it has, so with
  only some cuts installed, heads and quotations come out in those.
- **The cover** is the frontmatter's `cover_image`, or failing that
  `<paper>/assets/<name>-cover.{png,jpg,webp}`.
