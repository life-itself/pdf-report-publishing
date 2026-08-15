// Shared primitives for the three template styles.
//
// Deliberately small. The three styles in `typst/lib/styles/` are genuinely
// different designs — different grids, different furniture, different
// families — and forcing them through one parameterised layout engine
// would make every style harder to read than it is standalone. What lives
// here is only the technique that is identical in all three: hanging
// material in a rail, reserving space for out-of-flow content, hairlines,
// and the counters.
//
// See docs/typst-cookbook.md for why each of these is shaped the way it is.

// ---- Counters ---------------------------------------------------------
// Shared so a style's fig() and a document's cross-references agree.
#let fig-counter = counter("rp-figure")
#let box-counter = counter("rp-box")
#let chapter-counter = counter("rp-chapter")

// Typst's numbering patterns treat any non-counting character as a
// literal, so `display("01")` renders chapter 16 as "016". Pad by hand.
#let pad2(n) = if n < 10 { "0" + str(n) } else { str(n) }

// ---- Rails ------------------------------------------------------------
// A rail is material hung outside the text column. Because `place` is
// out-of-flow it reserves no vertical space, which is what we want for
// annotations that sit *alongside* something — and exactly what we do not
// want for anything that has to push the text down. `reserve` handles the
// second case.

// Hang content in a rail to the LEFT of the text column, right-aligned
// against the gutter so the rail reads as a column edge.
#let rail-left(body, width: 30mm, gutter: 8mm, dy: 0pt, align-to: right) = place(
  left,
  dx: -(width + gutter),
  dy: dy,
  box(width: width, align(align-to, body)),
)

// Hang content in a rail to the RIGHT of the text column, left-aligned
// against the gutter for the same reason, mirrored.
#let rail-right(body, width: 44mm, gutter: 8mm, dy: 0pt, align-to: left) = place(
  right,
  dx: width + gutter,
  dy: dy,
  box(width: width, align(align-to, body)),
)

// Occupy the vertical space `body` would take without drawing it. Pair
// with `place` when out-of-flow content must still push the flow down.
#let reserve(body) = hide(body)

// ---- Rules ------------------------------------------------------------
#let hairline(color, len: 100%, weight: 0.5pt) = line(
  length: len,
  stroke: weight + color,
)

// ---- Small type tricks ------------------------------------------------
// Uppercase plus tracking, which is what "small caps" means in a font
// without a real small-caps axis. Used for labels and running heads.
#let label-caps(body, tracking: 0.14em) = text(tracking: tracking, upper(body))

// ---- Page geometry helper ---------------------------------------------
// A4 in the units the specs are written in.
#let A4 = (width: 210mm, height: 297mm)
