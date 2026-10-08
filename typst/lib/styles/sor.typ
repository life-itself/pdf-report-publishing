// Style: SOR — Seeds of Renaissance papers. Implementation of
// docs/styles/sor.md.
//
// The look is decided in the design repo, not here: the anatomy and rules
// in projects/sor-design-system/print.md, the sizes in the --print-* tokens
// of system/tokens.css, and the approved page mockups in examples/print/.
// The values below are copied from those tokens; change them there first.
//
// Content arrives from scripts/sor.lua, which turns the paper's Markdown
// into calls to the devices defined here: opening(), contents-page(),
// summary(), quotation(), epigraph(), plate() and reference().

#import "../util.typ": A4

// ---- Tokens (system/tokens.css) -----------------------------------------
#let colour = (
  page: rgb("#ffffff"), // --print-page: white, unfilled
  ink: rgb("#1b1916"),
  muted: rgb("#5d584f"),
  rule: rgb("#e0dacf"),
  red: rgb("#e5201c"), // footnote marks and links, nothing else
  night: rgb("#171613"), // the back cover
  chalk: rgb("#ece7dc"),
  night-muted: rgb("#a49e93"),
)

// Restora is not yet installed everywhere; Fraunces is the fallback the
// tokens name. Typst warns once per build when it falls back.
#let fonts = (
  display: "Polyamine", // titles: title page, contents, chapter titles
  quote: ("Restora", "Fraunces"), // section heads, quotations, epigraphs
  body: "Bricolage Grotesque Text", // static text cut; see scripts/make-bricolage.py
  label: "Apfel Grotezk", // running heads, folios, figure numbers, labels
)

#let M = (
  top: 22mm,
  bottom: 26mm,
  inner: 24mm,
  outer: 20mm,
)
#let MEASURE = 118mm
#let BLOCK-W = A4.width - M.inner - M.outer // 166mm: plates span it

#let size = (
  title: 30pt,
  h2: 19pt,
  h3: 14pt,
  standfirst: 13pt,
  quote: 15pt,
  epigraph: 11.5pt,
  body: 10.5pt,
  summary: 9.5pt,
  caption: 8.5pt,
  note: 8pt,
  label: 7pt,
)
#let LH = 14.5pt // the baseline
#let TRACK = 0.16em

// Line boxes are exactly 1em tall, so `leading` is the gap that makes up
// a line pitch: lh(10.5pt, 14.5pt) gives lines 14.5pt apart.
#let lead(fs, lh) = lh - fs

// ---- Small pieces ---------------------------------------------------------

#let lbl(body, fill: colour.muted, weight: 400) = text(
  font: fonts.label,
  size: size.label,
  tracking: TRACK,
  weight: weight,
  fill: fill,
  number-type: "lining",
  hyphenate: false,
  upper(body),
)

#let wordmark(sz) = text(font: fonts.display, size: sz)[Seeds #text(
    font: fonts.quote,
    style: "italic",
    size: 0.82em,
  )[of] Renaissance]

// Recorded at every opening, read by the furniture.
#let opening-mark(short) = [#metadata(short) <sor-opening>]
#let numbering-style = state("sor-numbering", none)

// Every part starts on a new page. No recto rule and so no blank pages:
// the paper is one PDF read on screen (print.md, "One PDF").
#let new-part() = pagebreak(weak: true)
#let bare-mark = [#metadata(none) <sor-bare>] // a page with no furniture

#let page-label(loc) = {
  let style = numbering-style.at(loc)
  if style == none { return none }
  numbering(style, counter(page).at(loc).first())
}

// ---- Furniture -------------------------------------------------------------
// One layout on every page, since the PDF is read a page at a time, and
// the width of the text column: the paper's title at its left edge, the
// chapter and folio at its right. Openings carry only the folio, at the foot.
// Pages outside the numbering, and the title page and imprint, carry nothing.
#let furniture(title) = context {
  let pg = here().page()
  if numbering-style.get() == none { return }
  if query(<sor-bare>).any(m => m.location().page() == pg) { return }
  let folio = lbl(fill: colour.ink, counter(page).display(numbering-style.get()))
  let width = MEASURE
  if query(<sor-opening>).any(m => m.location().page() == pg) {
    place(top + left, dx: M.inner, dy: A4.height - 14mm - 2mm, box(width: width, align(right, folio)))
    return
  }
  let before = query(selector(<sor-opening>).before(here()))
  let chapter = if before.len() > 0 { before.last().value } else { none }
  place(top + left, dx: M.inner, dy: 12mm, box(width: width, {
    lbl(title)
    h(1fr)
    if chapter != none and chapter != [] { lbl(chapter); h(6mm) }
    folio
  }))
}

// ---- Devices --------------------------------------------------------------

// Section summary: a boxed standfirst, a fine muted rule, label sitting on it.
#let summary(body) = block(
  width: MEASURE,
  above: LH * 0.5 + 4pt,
  below: LH,
  breakable: false,
  {
    block(
      width: 100%,
      stroke: 0.4pt + colour.muted,
      inset: (x: 10pt, top: 10pt, bottom: 9pt),
      {
        set text(size: size.summary, weight: 500)
        set par(leading: lead(size.summary, 13pt), first-line-indent: 0pt, spacing: 6pt)
        body
      },
    )
    place(top + left, dx: 8pt, dy: -3pt, box(
      fill: colour.page,
      inset: (x: 4pt),
      lbl[In brief],
    ))
  },
)

// Displayed quotation: Restora italic, hanging a little into the side
// column. A long one drops to the epigraph size.
#let quotation(body, attribution: none, long: false) = {
  let fs = if long { size.epigraph } else { size.quote }
  let lh = if long { 15.5pt } else { 19pt }
  block(
    width: if long { MEASURE - 8mm } else { MEASURE + 22mm - 8mm },
    above: LH,
    below: LH,
    inset: (left: 8mm),
    breakable: long,
    {
      set par(justify: false, leading: lead(fs, lh), first-line-indent: 0pt)
      set text(font: fonts.quote, style: "italic", size: fs, hyphenate: false)
      body
      if attribution != none {
        v(6pt, weak: true)
        block(lbl(attribution))
      }
    },
  )
}

// The chapter's epigraph, set by opening(): indented under the title.
#let epigraph(body, attribution: none) = block(
  above: 10mm,
  below: 12mm,
  inset: (left: 30mm),
  width: 30mm + 96mm,
  {
    set par(justify: false, leading: lead(size.epigraph, 15.5pt), first-line-indent: 0pt)
    set text(font: fonts.quote, style: "italic", size: size.epigraph, hyphenate: false)
    body
    if attribution != none {
      v(5pt, weak: true)
      block(lbl(attribution))
    }
  },
)

// Figure as a plate: the width of the text column and aligned with it, no
// rules, number in Apfel, caption below. The figures carry their own
// signature, and their own title at the top left, which then lines up with
// the text.
#let figure-bounds = state("sor-figure-bounds", (:))

// The figure, cropped to its drawn content where its bounds are known
// (scripts/figure-bounds.py), so its edges meet the text's.
#let cropped(path, width) = context {
  let b = figure-bounds.get().at(path.split("/").last(), default: none)
  if b == none { return image(path, width: width) }
  let (x0, y0, x1, y1, w, h) = b
  let full = width * w / (x1 - x0)
  box(width: width, height: full * (y1 - y0) / w, clip: true, place(
    top + left,
    dx: -full * x0 / w,
    dy: -full * y0 / w,
    // both sizes, or Typst fits the image to the clip box and centres it
    image(path, width: full, height: full * h / w),
  ))
}

#let plate(path, number: none, title: none, caption: none) = {
  block(above: LH, below: LH, breakable: false, block(width: BLOCK-W, {
    block(width: MEASURE, cropped(path, MEASURE))
    v(3mm, weak: true)
    grid(
      columns: (14mm, MEASURE),
      lbl(fill: colour.ink, weight: 700)[Fig. #number],
      {
        set text(size: size.caption, style: "italic", fill: colour.muted, hyphenate: false)
        set par(leading: lead(size.caption, 11.5pt), first-line-indent: 0pt, justify: false)
        if title != none { text(style: "normal", weight: 600, fill: colour.ink, title) }
        if caption != none { [ #caption] }
      },
    )
  }))
}

// An entry in a reading list or the bibliography: second lines hang.
#let reference(body) = block(above: 8pt, below: 8pt, {
  set text(size: size.summary)
  set par(hanging-indent: 6mm, first-line-indent: 0pt, leading: lead(size.summary, 13pt))
  body
})

// ---- Openings -------------------------------------------------------------
// kind: "prelim" (summary, preface: roman, recto), "introduction" (recto,
// arabic numbering starts at 1), "chapter" (numbered, recto), "conclusion"
// (recto), "back" (further reading, bibliography, appendices: new page).
#let opening(
  kind: "chapter",
  number: none,
  title: [],
  after: none,
  epigraph: none,
  body,
) = {
  if kind == "back" { pagebreak(weak: true) } else { new-part() }
  if kind == "introduction" {
    numbering-style.update("1")
    counter(page).update(1)
  }
  opening-mark(title)
  // The heading is the bookmark and the link target; the page shows the
  // opening below instead.
  body
  if kind == "back" {
    v(8mm)
    block(below: 10mm, text(font: fonts.display, size: size.title)[#title])
    return
  }
  v(-4mm) // the opening starts 18mm down, above the text block
  block(height: 92pt * 1.0, width: 100%, {
    if number != none {
      text(font: fonts.display, size: 92pt, top-edge: "cap-height", bottom-edge: "baseline")[#number]
    }
    if kind == "chapter" {
      place(top + right, dx: BLOCK-W - MEASURE, dy: 4mm, image("/typst/sor-assets/woodcut-scatter.svg", width: 46mm))
    }
  })
  v(16mm)
  block(width: 140mm, {
    set par(justify: false, first-line-indent: 0pt)
    set text(hyphenate: false)
    if number != none { block(below: 3mm, lbl[Chapter #number]) }
    block(text(font: fonts.display, size: size.title, top-edge: "cap-height", bottom-edge: "descender")[#title])
    if after != none {
      block(above: 3mm, text(font: fonts.quote, style: "italic", size: 16pt)[#after])
    }
  })
  if epigraph != none { epigraph } else { v(12mm) }
}

// ---- Contents (annotated) -------------------------------------------------
#let contents-page(entries) = {
  new-part()
  opening-mark[Contents]
  [#heading(level: 1)[Contents] <contents>]
  v(8mm)
  block(below: 8mm, text(font: fonts.display, size: size.title)[Contents])
  let pg(target) = context {
    let loc = locate(label(target))
    link(loc, page-label(loc))
  }
  let entry-link(target, body) = link(label(target), body)
  block(width: MEASURE + 30mm, {
    set par(first-line-indent: 0pt, justify: false, leading: 2.5pt)
    set text(hyphenate: false)
    let i = 0
    while i < entries.len() {
      let e = entries.at(i)
      let children = ()
      let j = i + 1
      while j < entries.len() and entries.at(j).level > e.level {
        children.push(entries.at(j))
        j += 1
      }
      block(
        width: 100%,
        breakable: false,
        above: 0pt,
        below: 0pt,
        stroke: (top: 0.5pt + colour.rule),
        inset: (top: 4.5pt, bottom: 5pt),
        grid(
          columns: (9mm, 1fr, 10mm),
          pad(top: 2.5pt, lbl(if e.number != none { e.number } else { "·" })),
          {
            entry-link(e.target, text(weight: 600, size: 10.5pt, e.title))
            if e.summary != none {
              block(above: 2pt, text(size: 8pt, fill: colour.muted, e.summary))
            }
            for c in children {
              block(above: 5pt, grid(
                columns: (1fr, 10mm),
                {
                  entry-link(c.target, text(weight: 500, size: 9.5pt, c.title))
                  if c.summary != none {
                    block(above: 2pt, text(size: 8pt, fill: colour.muted, c.summary))
                  }
                },
                pad(top: 2pt, align(right, lbl(pg(c.target)))),
              ))
            }
          },
          pad(top: 2.5pt, align(right, lbl(fill: colour.ink, pg(e.target)))),
        ),
      )
      i = j
    }
  })
}

// ---- Fixed pages ----------------------------------------------------------

#let title-page(meta) = page(margin: 0pt, {
  bare-mark
  set par(first-line-indent: 0pt, justify: false)
  set text(hyphenate: false)
  place(top + left, dx: M.inner, dy: 30mm, wordmark(13pt) + h(3mm) + lbl[No. #meta.series-number])
  place(top + left, dx: M.inner, dy: 74mm, block(width: 140mm, text(font: fonts.display, size: size.title)[#meta.title]))
  place(top + left, dx: M.inner, dy: 108mm, block(width: 120mm, {
    set par(leading: lead(size.standfirst, 17pt))
    text(font: fonts.quote, size: size.standfirst)[#meta.subtitle]
  }))
  place(top + left, dx: M.inner, dy: 124mm, lbl[#meta.subseries · Part #meta.part])
  place(bottom + left, dx: M.inner, dy: -34mm, {
    text(size: 11pt, weight: 500)[#meta.authors.join(" & ")]
    linebreak()
    lbl(meta.organisation)
  })
})

// Verso of the title page: small print at the foot, the rest left empty.
#let imprint-page(meta, imprint) = {
  set par(first-line-indent: 0pt, justify: false, leading: lead(size.note, 11pt))
  set text(size: size.note, hyphenate: false)
  bare-mark
  v(1fr)
  block(width: 110mm, below: 9mm, text(fill: colour.muted, imprint.about))
  grid(
    columns: (24mm, 110mm - 24mm),
    row-gutter: 5pt,
    ..imprint.rows.map(((k, v)) => (pad(top: 1pt, lbl(k)), v)).flatten(),
  )
}

// The one night: blurb, a short about, the mark on its disc, a colophon.
#let back-cover(meta, back) = page(margin: 0pt, fill: colour.night, {
  opening-mark[]
  numbering-style.update(none)
  set text(fill: colour.chalk, hyphenate: false)
  set par(first-line-indent: 0pt, justify: false)
  // the paper torn off along the top edge
  let edge = ((100, 52), (97, 70), (93, 48), (89, 66), (84, 55), (80, 74), (75, 51), (71, 62), (66, 46), (61, 70), (57, 58), (52, 76), (47, 50), (43, 64), (38, 49), (33, 72), (29, 57), (24, 68), (19, 47), (15, 63), (10, 52), (6, 71), (3, 55), (0, 64))
  place(top + left, polygon(
    fill: colour.page,
    (0mm, 0mm),
    (A4.width, 0mm),
    ..edge.map(((x, y)) => (A4.width * x / 100, 9mm * y / 100)),
  ))
  place(top + left, dx: 22mm, dy: 40mm, block(width: 120mm, {
    set par(leading: lead(17pt, 22pt))
    text(font: fonts.quote, size: 17pt, back.blurb)
  }))
  place(top + left, dx: 22mm, dy: 96mm, block(width: 100mm, {
    set par(leading: lead(9.5pt, 14pt), spacing: 7pt + lead(9.5pt, 14pt))
    set text(size: 9.5pt)
    back.about
  }))
  place(bottom + left, dx: 22mm, dy: -26mm, grid(
    columns: (24mm, auto),
    column-gutter: 4mm,
    align: horizon,
    image("/typst/sor-assets/sor-mark-inverted.png", width: 24mm),
    {
      set par(leading: 2pt)
      text(font: fonts.display, size: 20pt)[Seeds #text(font: fonts.quote, style: "italic", size: 0.82em)[of] \ Renaissance]
    },
  ))
  // the studio's logo, in its night colours, with the colophon above it
  place(bottom + right, dx: -22mm, dy: -26mm, image("/typst/sor-assets/life-itself-studio-on-night.png", width: 38mm))
  place(bottom + right, dx: -22mm, dy: -26mm - 16.2mm - 7mm, block(width: 64mm, align(right, {
    set par(leading: lead(size.label, 11pt))
    for line in back.colophon { lbl(fill: colour.night-muted, line); linebreak() }
  })))
})

// ---- Body rules -----------------------------------------------------------

#let body-rules(doc) = {
  set text(
    font: fonts.body,
    size: size.body,
    weight: 350,
    fill: colour.ink,
    lang: "en",
    region: "GB",
    hyphenate: true,
    top-edge: 0.8em,
    bottom-edge: -0.2em,
    number-type: "old-style",
  )
  set par(
    justify: false,
    leading: lead(size.body, LH),
    spacing: lead(size.body, LH) + LH * 0.5, // half a line between paragraphs
    first-line-indent: 0pt,
  )
  show strong: set text(weight: 600)

  // Red for links out of the paper; links within it (contents, notes) stay ink.
  show link: it => if type(it.dest) == str { text(fill: colour.red, it) } else { it }

  set list(indent: 0pt, body-indent: 5mm, spacing: lead(size.body, LH))
  set enum(indent: 0pt, body-indent: 5mm, spacing: lead(size.body, LH))
  show list: set block(above: LH * 0.5, below: LH * 0.5)
  show enum: set block(above: LH * 0.5, below: LH * 0.5)

  // Footnotes: marks in red Apfel; notes under a short ink rule, numbers hanging.
  show footnote: set text(fill: colour.red, font: fonts.label, weight: 700, number-type: "lining")
  // a hair of space, so two marks in a row read as 19 20, not 1920
  show footnote: it => h(1.2pt, weak: true) + it
  set super(size: 6pt)
  set footnote.entry(
    separator: line(length: 22mm, stroke: 0.5pt + colour.ink),
    clearance: LH,
    gap: 2.5pt,
    indent: 0pt,
  )
  show footnote.entry: it => {
    let n = counter(footnote).at(it.note.location()).first()
    set text(size: size.note, weight: 350, number-type: "lining")
    set par(leading: lead(size.note, 11pt), first-line-indent: 0pt, justify: false, hanging-indent: 0pt)
    grid(
      columns: (5mm, 1fr),
      pad(top: 0.5pt, link(it.note.location(), text(font: fonts.label, size: 6.5pt, weight: 700)[#n])),
      it.note.body,
    )
  }

  // Inside the text, heads are Restora: `###` sections, `####` sub-sections.
  // Tables: small, ruled in hairlines, no fills.
  show table: set text(size: size.caption, hyphenate: false)
  show table: set par(leading: lead(size.caption, 11.5pt), first-line-indent: 0pt)
  set table(stroke: (x, y) => (top: if y == 0 { 0.6pt + colour.ink } else { 0.5pt + colour.rule }, bottom: 0.5pt + colour.rule), inset: (x: 4pt, y: 5pt))
  show table: set block(above: LH, below: LH)
  show table.cell.where(y: 0): set text(weight: 600)

  show heading: set text(hyphenate: false)
  show heading.where(level: 1): it => block(height: 0pt, above: 0pt, below: 0pt, hide(it.body))
  show heading.where(level: 2): it => block(width: MEASURE, above: LH, below: LH * 0.5, sticky: true, {
    set par(leading: lead(size.h2, LH * 1.5), justify: false, first-line-indent: 0pt)
    text(font: fonts.quote, weight: 400, size: size.h2, it.body)
  })
  show heading.where(level: 3): it => block(width: MEASURE, above: LH, below: LH * 0.4, sticky: true, {
    set par(leading: lead(size.h3, LH * 1.25), justify: false, first-line-indent: 0pt)
    text(font: fonts.quote, weight: 500, size: size.h3, it.body)
  })

  doc
}

// ---- The template ---------------------------------------------------------
// meta: the paper's frontmatter (title, subtitle, series-number, subseries,
// part, authors, organisation). cover: a finished image, placed as page 1.
// imprint: (about: content, rows: ((label, content), ...)).
// back: (blurb, about, colophon: (line, ...)).
#let paper(meta: (:), cover: none, imprint: none, back: none, figures: (:), doc) = {
  set document(title: meta.title, author: meta.authors)
  set page(
    width: A4.width,
    height: A4.height,
    fill: colour.page,
    margin: (left: M.inner, right: A4.width - M.inner - MEASURE, top: M.top, bottom: M.bottom),
    foreground: furniture(meta.title),
  )
  show: body-rules
  figure-bounds.update(figures)

  if cover != none {
    page(margin: 0pt, image(cover, width: 100%, height: 100%, fit: "cover"))
  }

  // Prelims are numbered in roman from the title page.
  numbering-style.update("i")
  counter(page).update(1)
  title-page(meta)
  if imprint != none { imprint-page(meta, imprint) }

  doc

  // The back cover is the last page and a verso.
  if back != none { back-cover(meta, back) }
}
