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

// ---- Flattening content to a string -----------------------------------
// Needed by the drop cap, which has to split a paragraph by words and
// therefore cannot work on structured content. Markup decomposes into
// `text`, `space` and `smartquote` elements, so those are the three cases
// that matter; anything else (a link, an emphasis run) is deliberately not
// supported, because a drop cap that silently dropped formatting would be
// worse than one that refuses.
#let plain(c) = {
  if type(c) == str {
    c
  } else if type(c) == content {
    let f = repr(c.func())
    if f == "space" {
      " "
    } else if f == "smartquote" {
      // A single quote is far more often an apostrophe than an
      // opening quote, so that is the safer guess.
      if c.double { "\u{201C}" } else { "\u{2019}" }
    } else if c.has("text") {
      c.text
    } else if c.has("children") {
      c.children.map(plain).join("")
    } else {
      ""
    }
  } else {
    ""
  }
}

// ---- Drop cap ---------------------------------------------------------
// Typst has no text-wrap-around-shape, so a drop cap has to be built by
// hand: size a capital so its cap-height spans exactly N lines, then find
// how much of the paragraph fits alongside it and set that in a narrow
// column, letting the remainder run full width beneath.
//
// `body` is flattened to a string with `plain()`, so the split can be by
// words. That means inline markup inside a drop-capped paragraph is not
// preserved. Chapter openings are the case this exists for, and they are
// plain prose.
//
//   lines:  how many lines the capital spans
//   gap:    space between the capital and the text beside it
//   caps:   how many opening words to set as pseudo-small-caps
#let dropcap(
  body,
  lines: 3,
  gap: 0.32em,
  font: none,
  fill: none,
  caps: 0,
  caps-tracking: 0.06em,
) = layout(size => context {
  let s = plain(body).trim()
  assert(s.len() > 1, message: "dropcap() needs some text to set")
  let cap = s.at(0)
  let rest = s.slice(1)

  // Line height = leading + the font's own ascender-to-descender span.
  let lh = par.leading.to-absolute() + measure[x].height
  let target = lh * lines

  // Size the capital by measuring it: with top-edge "cap-height" and
  // bottom-edge "baseline" a box around it is exactly the cap height, so
  // one probe gives the scale factor.
  let styled(sz) = text(
    size: sz,
    top-edge: "cap-height",
    bottom-edge: "baseline",
    font: if font == none { auto } else { font },
    fill: if fill == none { auto } else { fill },
  )[#cap]
  let probe = measure(styled(100pt)).height
  let capsize = 100pt * (target / probe)
  let capbox = box(styled(capsize))
  let capw = measure(capbox).width
  let gapw = measure(box(width: gap)).width
  let narrow = size.width - capw - gapw

  // Largest prefix of the remaining words that still fits the N lines.
  let words = rest.split(" ")
  let render(n) = {
    let head = words.slice(0, n).join(" ")
    if caps > 0 {
      let cw = calc.min(caps, n)
      text(size: 0.82em, tracking: caps-tracking)[#upper(words.slice(0, cw).join(" "))]
      if n > cw [ #words.slice(cw, n).join(" ")]
    } else [#head]
  }
  let fits(n) = measure(block(width: narrow, render(n))).height <= target + 0.5pt
  let lo = 0
  let hi = words.len()
  while lo < hi {
    let mid = int((lo + hi + 1) / 2)
    if fits(mid) { lo = mid } else { hi = mid - 1 }
  }

  grid(
    columns: (capw + gapw, narrow),
    rows: (target,),
    align: (left + top, left + top),
    capbox,
    block(width: narrow, render(lo)),
  )
  if lo < words.len() {
    block(above: 0pt, below: 0pt, par(words.slice(lo).join(" ")))
  }
})

// ---- Page geometry helper ---------------------------------------------
// A4 in the units the specs are written in.
#let A4 = (width: 210mm, height: 297mm)
