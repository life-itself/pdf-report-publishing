---
updated: 2026-08-16
---

# Typst cookbook

Generic Typst technique for report typesetting: things that hold whichever
template style is in use. Separated from the style specs deliberately —
"how do I hang a caption in the margin" is a different kind of knowledge
from "this style uses a serif at 10pt".

Written against **Typst 0.15.1**. Everything here is in use in
`typst/lib/`; the file and function that uses it is named so you can go
and look.

## Contents

1. [Fonts](#fonts)
2. [Leading, and why your line height is wrong](#leading-and-why-your-line-height-is-wrong)
3. [Rails: material outside the text column](#rails-material-outside-the-text-column)
4. [Counters](#counters)
5. [Page furniture that knows where it is](#page-furniture-that-knows-where-it-is)
6. [Figures](#figures)
7. [Boxes and panels](#boxes-and-panels)
8. [Drop caps](#drop-caps)
9. [Footnotes and endnotes](#footnotes-and-endnotes)
10. [Tables that don't look like spreadsheets](#tables-that-dont-look-like-spreadsheets)
11. [Paragraph indents](#paragraph-indents)
12. [Composing several styles in one document](#composing-several-styles-in-one-document)
13. [Still unwritten](#still-unwritten)

---

## Fonts

### Vendor them

Left to its own devices Typst falls back silently to whatever the machine
has. The same source produced Liberation Sans in one sandbox and a system
serif on macOS — two visibly different PDFs, with no warning beyond an
`unknown font family` line in a wall of output. Vendor everything in
`fonts/` and pass `--font-path fonts`.

Check what a font path actually exposes, and exclude the system's:

```sh
typst fonts --font-path fonts --ignore-system-fonts
```

### Variable fonts work

Typst 0.15 instantiates variable font axes correctly, so a single
`Literata[opsz,wght].ttf` covers the whole weight range and
`text(weight: 700)` does what you expect. This matters because most Google
Fonts families now ship **only** as variable files. Verify before relying
on it — earlier Typst versions did not:

```typst
#text(font: "Literata", weight: 400)[400] \
#text(font: "Literata", weight: 700)[700]
```

Note the limit: Typst maps `weight`, `style` and `stretch` onto axes, but
there is no way to reach a custom axis. Fraunces' `SOFT` and `WONK` axes,
for instance, stay at their defaults.

Download straight from the repo rather than the download endpoint, which
is bot-blocked and returns a non-zip:

```sh
curl -O "https://raw.githubusercontent.com/google/fonts/main/ofl/literata/Literata%5Bopsz,wght%5D.ttf"
```

Italics are separate files and are easy to forget until something renders
as a synthesised slant. `Fraunces-Italic[SOFT,WONK,opsz,wght].ttf` had to
be fetched separately from `Fraunces[...]`.

## Leading, and why your line height is wrong

Typst's `par(leading:)` is the **gap between lines**, not the line height.
The line height is `leading + (top-edge − bottom-edge)`, and the second
term depends on the font's own metrics — so the same `leading: 0.65em`
gives a different line height in every family.

Measure it once per font rather than guessing:

```sh
# Set six lines at 10pt with a known leading, then read the baselines.
typst compile --font-path fonts probe.typ probe.pdf
pdftotext -bbox probe.pdf - | grep -o 'yMin="[0-9.]*"'
```

Measured at 10pt with `leading: 0.65em`, for the faces vendored here:

| Family | Line height | Metric constant |
|---|---|---|
| Work Sans | 13.10pt | 0.66 |
| Source Serif 4 | 13.20pt | 0.67 |
| Outfit | 13.44pt | 0.694 |
| Literata | 13.50pt | 0.70 |
| Fraunces | 13.50pt | 0.70 |
| DM Mono | 13.50pt | 0.70 |

So to hit a target line height of *N*× the font size:

```
leading = (N − constant) em
```

1.5× in Literata is `leading: 0.80em`; 1.42× in Source Serif 4 is
`leading: 0.75em`. The style files carry these as comments next to each
value, because a bare `0.75em` is unreadable six months later.

## Rails: material outside the text column

Set the page's left (or right) margin to where the *text* should start,
then hang rail material back into the margin with `place` at a negative
`dx`. `typst/lib/util.typ` has both directions:

```typst
#let rail-left(body, width: 30mm, gutter: 8mm, dy: 0pt, align-to: right) = place(
  left,
  dx: -(width + gutter),
  dy: dy,
  box(width: width, align(align-to, body)),
)
```

Right-hand rails mirror it: `place(right, dx: width + gutter)` puts the
box's left edge exactly one gutter beyond the text column.

**`place` reserves no vertical space.** That is what you want for a
caption or a source credit sitting *alongside* something. Anything that
must push the flow down has to emit a hidden copy of itself:

```typst
place(left, dx: -(RAIL + GUT), box(width: w, draw))
hide(box(width: w, draw))    // reserves the height the placed copy occupies
```

Used by the wide figure in `typst/lib/styles/review.typ`, which pushes
left into the rail to run 176mm.

**Placed content is drawn in flow order.** Anything emitted later that
covers the same coordinates will paint over it. A rail note placed just
before a full-width figure disappears behind the figure's panel — the fix
is to place it beside a paragraph, not beside a wide object.

## Counters

`counter.display("01")` **does not zero-pad.** Typst's numbering patterns
treat any character that is not a counting symbol as a literal, so `"01"`
means "the literal `0`, then a counter", and chapter 16 renders as `016`.
Pad by hand — `pad2` in `util.typ`.

**A counter read in the same `context` that steps it sees the old value.**
The step takes effect at the location its returned content lands in, which
is after the read. Use two context blocks:

```typst
context { if not backmatter.get() { chapter-counter.step() } }
context { ... chapter-counter.get().first() ... }   // now correct
```

## Page furniture that knows where it is

A running foot naming the current section is a query against the document,
evaluated inside the footer's own `context`:

```typst
#let make-footer(date) = context {
  let hs = query(selector(heading.where(level: 1)).before(here()))
  let section = if hs.len() > 0 { hs.last().body } else { none }
  ...
}
```

Page parity, for verso/recto running heads:

```typst
context {
  let pg = here().page()
  if calc.odd(pg) { align(right, head) } else { align(left, head) }
}
```

Suppressing furniture on chapter-opening pages means knowing which pages
those are — again a query, this time over the whole document:

```typst
let openers = query(heading.where(level: 1)).map(h => h.location().page())
if here().page() in openers { return }
```

For mirrored margins, `page(binding: left)` plus
`margin: (inside:, outside:, top:, bottom:)`.

## Figures

A figure is an assembly with a fixed anatomy, so write one function that
takes arbitrary content and a thin wrapper for the common image case:

```typst
#let figc(content, caption: none, source: none, wide: false) = { ... }
#let fig(path, width: 100%, ..args) = figc(
  align(center, box(width: width, image(path, width: 100%))),
  ..args,
)
```

That also means a figure can be a diagram drawn in Typst rather than an
imported picture — see `typst/examples/diagrams.typ`, which draws the page
grids the specs describe.

**Image paths resolve relative to the file containing the `image()` call**,
not to the file that called the function. Since `image()` lives in the
style library, example documents pass root-absolute paths
(`/typst/assets/x.png`) and the build passes `--root .`.

**A row of images needs one grid, not two.** Images and their sub-captions
must share column widths, and if the columns are `auto` the widths come
from the images — so a separate caption grid with `1fr` columns will not
line up. Put both rows in one grid. Size a triptych to a common *height*
rather than a common width: ragged tops read as three adjacent pictures
rather than as one figure.

## Boxes and panels

The offset-outline trick (a thin rule offset down-and-right behind a solid
panel) gives depth without a shadow and survives greyscale printing. The
trap is the height:

```typst
// WRONG — `height: 100%` in a placed box resolves against the *page*,
// drawing a rule down the whole sheet.
place(dx: 2mm, dy: 2mm, box(width: W, height: 100%, stroke: ...))

// RIGHT — measure the panel first.
context {
  let h = measure(draw).height
  place(dx: 2mm, dy: 2mm, box(width: W, height: h, stroke: ...))
  draw
}
```

`measure` needs the content to have a determinate width, which a
`block(width: W, ...)` does.

## Drop caps

Typst has no text-wrap-around-shape, so a drop cap has to be constructed.
`dropcap` in `util.typ` does it in four steps:

1. **Size the capital by measuring it.** With `top-edge: "cap-height"` and
   `bottom-edge: "baseline"`, a box around a letter is exactly its cap
   height, so one probe at 100pt gives the scale factor for any target:

   ```typst
   let probe = measure(text(size: 100pt, top-edge: "cap-height",
                            bottom-edge: "baseline")[#cap]).height
   let capsize = 100pt * (target / probe)
   ```

   Note `100pt * (target / probe)` and not `100pt * target / probe` —
   Typst evaluates left to right and refuses to multiply two lengths.

2. **Work out the target.** `lines × (par.leading.to-absolute() +
   measure[x].height)`, read inside a `context`.

3. **Binary-search how many words fit** beside the capital, using
   `measure(block(width: narrow, ...)).height <= target`.

4. **Emit a two-column grid** with the capital and that prefix, then the
   remainder as an ordinary paragraph at full width.

The catch is that step 3 splits on words, so the paragraph has to be a
string. `plain()` in `util.typ` flattens markup: content decomposes into
`text`, `space` and `smartquote` elements, and

```typst
#repr([Hello world — a "test".])
// sequence([Hello world], [ ], [— a], [ ], ["], [test], ["], [.])
```

is how you find that out. Inline formatting inside a drop-capped paragraph
is not preserved — the function is for chapter openings, which are plain
prose.

## Footnotes and endnotes

Real footnotes work and are worth using:

```typst
show footnote.entry: it => {
  set text(size: 8pt)
  set par(justify: false, leading: 0.70em, first-line-indent: 0em)
  it
}
set footnote.entry(
  separator: line(length: 20mm, stroke: 0.5pt + rule-colour),
  gap: 0.7em,
  clearance: 1.6em,   // space between body text and the footnote block
  indent: 6mm,        // hanging indent for the number
)
show footnote: it => text(font: mono, size: 0.65em, fill: accent, it)
```

Endnotes have no built-in support and do not need any: they are a list
with hanging numbers, which is a two-column grid per item.

## Tables that don't look like spreadsheets

No verticals, no fill; rules only where they separate something. The
stroke closure gets `(x, y)`, so compute the row count outside it:

```typst
let rows = int(cells.len() / n)
table(
  columns: columns,
  stroke: (x, y) => (
    top: if y == 0 { 0.8pt + ink } else if y == 1 { 0.6pt + ink } else { none },
    bottom: if y == rows - 1 { 0.6pt + rule } else { none },
  ),
  inset: (x: 3pt, y: 6pt),
  fill: none,
  ...
)
```

`table.header` and `table.footer` interact with a stroke closure in ways
that are easy to get wrong; plain cells plus an explicit closure is easier
to reason about.

## Paragraph indents

For the book convention (indent every paragraph except the first):

```typst
set par(first-line-indent: (amount: 1.2em, all: false))
```

`all: false` means "not the first paragraph after a block-level element",
which correctly leaves the paragraph after a heading, a figure or a
quotation unindented.

Two consequences worth knowing:

- **Headings inherit it.** A heading is a paragraph, so it picks up the
  indent unless every heading show rule sets `first-line-indent: 0em`. The
  symptom is a heading that looks 1.2em off the left margin for no reason.
- **A paragraph after any custom block is treated as a first paragraph.**
  If a device is implemented as a `block`, the text after it will not
  indent. That happens to match the convention, but it is worth knowing it
  is a consequence rather than a decision.

To indent a single paragraph — the Review style's lead paragraph — call
`par(first-line-indent: (amount: 2em, all: true), body)` explicitly. A
show rule that tracks "am I the first paragraph" needs mutable state read
during layout, which is exactly the kind of thing that fails to converge.

## Composing several styles in one document

`set` rules are scoped to their enclosing block, so several complete
templates can be concatenated in one file — which is how
`typst/compare.typ` renders three styles with three different page setups,
palettes and furniture in a single PDF:

```typst
#review.report(front-matter: false)[ ... ]
#essay.report(front-matter: false)[ ... ]
#brief.report(front-matter: false)[ ... ]
```

Two things to know:

- **Counters are global.** Reset the ones you share at the start of each
  block, or chapter II of the second style will follow chapter 01 of the
  first.
- **Queries are global too.** A running head that names "the last level-1
  heading before this page" will happily name a heading belonging to the
  previous style.

## Still unwritten

- Bibliography and citation (`bibliography()` confirmed working in a
  throwaway document, never wired into a template).
- Section-opener pages and part dividers.
- Widow/orphan control beyond `block(breakable: false)`.
- Print-on-demand: trim size, bleed, gutter for binding.
