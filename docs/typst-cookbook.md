---
updated: 2026-08-16
status: stub — started 2026-08-16, to be filled out as the template styles are built
---

# Typst cookbook

Generic Typst technique for report typesetting: things that hold whichever
template style is in use. Separated from the style specs deliberately —
"how do I hang a caption in the margin" is a different kind of knowledge
from "this style uses a serif at 10pt".

Written against **Typst 0.15.1**.

## Gotchas found the hard way

These each cost real time in the 2026-08-16 session. None of them are
guessable from the docs.

### Variable fonts work — the whole Google Fonts catalogue is available

Typst 0.15 instantiates variable font axes correctly, so a single
`Literata[opsz,wght].ttf` covers the full weight range and
`text(weight: 700)` does what you expect. This matters because most
Google Fonts families now ship **only** as variable files, with no static
instances. Verify before relying on it — earlier Typst versions did not:

```typst
#text(font: "Literata", weight: 400)[400] \
#text(font: "Literata", weight: 700)[700]
```

Download straight from the repo rather than the download endpoint, which
is bot-blocked and returns a non-zip:

```sh
curl -O "https://raw.githubusercontent.com/google/fonts/main/ofl/literata/Literata%5Bopsz,wght%5D.ttf"
```

Check what a `--font-path` actually exposes with
`typst fonts --font-path fonts`.

### `counter.display("01")` does not zero-pad

Typst's numbering patterns treat any character that isn't a counting
symbol as a **literal**. So `"01"` means "the literal `0`, then a counter",
and chapter 16 renders as `016`. Pad by hand:

```typst
#context {
  let n = counter("chapter").get().first()
  let label = if n < 10 { "0" + str(n) } else { str(n) }
  ...
}
```

### `include` gives the included file its own scope

An `#include "content.typ"` does **not** inherit imports from the
including file. If generated content calls helper functions, the generated
file must import them itself — in this pipeline the build script prepends
the import line to Pandoc's output.

### Vendor the fonts

Left to its own devices Typst falls back silently to whatever the machine
has. The same source produced Liberation Sans in one sandbox and a system
serif on macOS — two visibly different PDFs, no warning beyond a
`unknown font family` line in a wall of output. Vendor everything in
`fonts/` and pass `--font-path`.

### Hyphenation must be turned off on headings

`set text(hyphenate: true)` applies to headings too, and produces
`PARADIG-MATIC`. Disable it inside each heading show rule.

## Page grid with a working margin column

The asymmetric-margin-plus-margin-column layout (see
`docs/typography-research.md`) is built by setting the page's left margin
to where the *text* column should start, then hanging margin material back
into it with `place` at a negative `dx`:

```typst
#let EDGE = 18mm, MARGIN-W = 32mm, GUTTER = 8mm
#let TEXT-L = EDGE + MARGIN-W + GUTTER
#let MARGIN-DX = -(MARGIN-W + GUTTER)

#let marginal(body, dy: 0pt) = place(
  left, dx: MARGIN-DX, dy: dy,
  box(width: MARGIN-W, align(right, body)),
)
```

Because `place` is out-of-flow it reserves no vertical space — fine for
captions and folios that sit alongside something else, but anything that
needs to *push* content down must also emit a `hide(...)` copy of itself
to reserve the space. See `pullquote` in `typst/report.typ`.

## To be written

- Footnotes and bibliography (confirmed working in a throwaway doc, never
  wired into a real template).
- Tables that don't look like spreadsheets.
- Section-opener pages.
- Running headers, and how to vary them by section.
- Widow/orphan control and `block(breakable:)`.
- Print-on-demand: trim size, bleed, gutter for binding.
