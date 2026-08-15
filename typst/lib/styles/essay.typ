// Style: ESSAY — implementation of docs/styles/essay.md.
//
// Literary, warm, unhurried. Fraunces over Literata on warm paper, one
// generous column, mirrored margins, and a vermilion accent that appears
// about five times a chapter. Derived from CRI's chapter openers and the
// Mindfulness Initiative's standfirsts; see
// docs/report-design-principles.md.

#import "../util.typ": A4, chapter-counter, dropcap, fig-counter, hairline

// ---- Grid (spec §1) ---------------------------------------------------
#let INNER = 42mm
#let OUTER = 48mm
#let TOP = 26mm
#let BOT = 26mm
#let TEXT-W = A4.width - INNER - OUTER // 120mm

// ---- Colour (spec §3) -------------------------------------------------
#let palette = (
  page: rgb("#FCFAF6"),
  ink: rgb("#23201C"),
  muted-ink: rgb("#5C554C"),
  muted: rgb("#8A8177"),
  accent: rgb("#B4472A"),
  rule: rgb("#DED7CB"),
)

// ---- Type (spec §2) ---------------------------------------------------
#let fonts = (
  display: "Fraunces",
  body: "Literata",
  furniture: "Work Sans",
)

// Measured line-height constants (see docs/typst-cookbook.md):
// Literata 0.70, Fraunces 0.70, Work Sans 0.66.
#let BODY-SIZE = 10.5pt
#let BODY-LEAD = 0.80em // 1.50x

// ---- Editorial devices (spec §5) --------------------------------------

// The chapter's claim, directly under the title.
#let standfirst(body) = block(above: 0em, below: 2.2em, {
  set par(justify: false, leading: 0.75em, first-line-indent: 0em) // 1.45x
  set text(hyphenate: false)
  text(font: fonts.display, size: 13.5pt, fill: palette.muted-ink, style: "italic")[#body]
})

// The signature interruption: a sentence lifted verbatim out of the prose,
// marked by a change of face and a short accent rule. No quotation marks —
// the type change is the quotation mark.
#let pullquote(body, attribution: none) = block(
  above: 1.4em,
  below: 1.4em,
  breakable: false,
  pad(left: 8mm, {
    hairline(palette.accent, len: 12mm, weight: 1pt)
    v(0.7em, weak: true)
    set par(justify: false, leading: 0.60em, first-line-indent: 0em) // 1.30x on 17pt
    set text(hyphenate: false)
    text(font: fonts.display, size: 17pt, fill: palette.ink, style: "italic")[#body]
    if attribution != none {
      v(0.55em, weak: true)
      text(font: fonts.furniture, size: 8pt, fill: palette.muted)[#attribution]
    }
  }),
)

// A passage quoted *into* the text: smaller than body, indented left only,
// ragged right. The opposite move from a pull quote, and the distinction
// matters — an earlier version of this template set long quotations larger
// and coloured, which was the worst-looking thing in the output.
#let blockquote(body, attribution: none) = block(
  above: 1.2em,
  below: 1.2em,
  pad(left: 8mm, {
    set par(justify: false, leading: 0.75em, first-line-indent: 0em) // 1.45x
    text(size: 9.8pt, fill: palette.muted-ink)[#body]
    if attribution != none {
      v(0.45em, weak: true)
      text(font: fonts.furniture, size: 8pt, fill: palette.muted)[\u{2014} #attribution]
    }
  }),
)

// A definition: term run in, then the gloss.
#let dfn(term, body) = block(above: 1.0em, below: 1.0em, {
  text(font: fonts.display, size: BODY-SIZE, weight: 600, fill: palette.ink)[#term]
  h(1em)
  body
})

// ---- Figures (spec §5) ------------------------------------------------
// No rail in this style, so the source rides on the end of the caption.
#let figc(content, caption: none, source: none) = {
  fig-counter.step()
  block(breakable: false, above: 1.6em, below: 1.6em, {
    content
    v(0.6em, weak: true)
    context text(font: fonts.furniture, size: 8pt, fill: palette.muted, hyphenate: false)[
      #set par(leading: 0.42em, justify: false)
      #text(weight: 600, fill: palette.ink)[Figure #fig-counter.get().first().]
      #h(0.35em)
      #caption
      #if source != none [ #emph[Source: #source]]
    ]
    v(0.6em, weak: true)
    hairline(palette.rule, len: 100%)
  })
}

#let fig(path, width: 100%, ..args) = figc(
  align(left, box(width: width, image(path, width: 100%))),
  ..args,
)

// A row of images that make one argument and share one number. Sized to a
// common height rather than a common width: a triptych of pictures with
// ragged tops reads as three images that happen to be adjacent, not as one
// figure.
//
// `ratios` is accepted and ignored: `scripts/figures.py` derives relative
// widths from the source images' pixel dimensions, which is the right
// thing for a width-based row and meaningless for a height-based one.
// Silently accepting it keeps the generated content portable between the
// styles rather than making the Pandoc step style-aware.
#let figrow(items, caption: none, source: none, height: 34mm, ratios: none) = figc(
  {
    // One grid, two rows: images and their sub-captions must share column
    // widths, and the widths are decided by the images.
    grid(
      columns: (auto,) * items.len(),
      column-gutter: 4mm,
      row-gutter: 0.55em,
      align: (bottom, top),
      ..items.map(it => image(it.at(0), height: height)),
      ..items.map(it => text(font: fonts.furniture, size: 7.5pt, fill: palette.muted)[
        #set par(leading: 0.42em, justify: false); #it.at(1)
      ]),
    )
  },
  caption: caption,
  source: source,
)

// The opening of a chapter: a three-line drop cap in the accent, and the
// first few words in pseudo-small-caps. See util.typ for why the body is
// flattened to a string.
//
// `above` is the opener's air: the spec asks for the body to start about a
// third of the way down a chapter's first page, and this is where most of
// that comes from.
#let opening(body, caps: 4, above: 2mm) = { v(above); dropcap(
  body,
  lines: 3,
  font: fonts.display,
  fill: palette.accent,
  caps: caps,
) }

// ---- Body rules -------------------------------------------------------
#let body-rules(doc) = {
  set text(font: fonts.body, size: BODY-SIZE, fill: palette.ink, lang: "en", hyphenate: true)
  // Paragraphs indent and do not space apart: the book convention, and the
  // single strongest signal that a document is set as prose rather than
  // assembled as a report. `all: false` means the first paragraph after a
  // heading, quotation or figure is not indented, which is exactly right.
  set par(
    justify: true,
    leading: BODY-LEAD,
    spacing: 0.55em,
    first-line-indent: (amount: 1.2em, all: false),
  )

  show link: it => text(fill: palette.accent, it)
  show strong: it => text(weight: 600, it)

  set list(marker: text(fill: palette.accent)[\u{2022}], indent: 5mm, spacing: 0.7em)
  set enum(indent: 5mm, spacing: 0.7em)

  // Footnotes, not endnotes (spec §5).
  show footnote.entry: it => {
    set text(size: 8pt, fill: palette.ink)
    set par(justify: false, leading: 0.70em, first-line-indent: 0em)
    it
  }
  set footnote.entry(
    separator: hairline(palette.rule, len: 20mm),
    gap: 0.7em,
    clearance: 1.6em,
    indent: 6mm,
  )

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    chapter-counter.step()
    v(6mm)
    context align(center, text(
      font: fonts.display,
      size: 11pt,
      fill: palette.accent,
      tracking: 0.2em,
    )[#numbering("I", chapter-counter.get().first())])
    v(9mm)
    set par(justify: false, leading: 0.45em, first-line-indent: 0em) // 1.15x on 26pt
    set text(hyphenate: false)
    text(font: fonts.display, size: 26pt, weight: 500, fill: palette.ink)[#it.body]
    // The opener's air is emitted here rather than left to whatever comes
    // next, so a chapter that has no standfirst and no drop-capped opening
    // — which is most of them until the editorial pass is done — still
    // gets the gap the spec asks for.
    v(12mm)
  }

  show heading.where(level: 2): it => {
    v(1.8em, weak: true)
    set par(justify: false, leading: 0.55em, first-line-indent: 0em)
    set text(hyphenate: false)
    text(font: fonts.display, size: 13pt, weight: 600, fill: palette.ink)[#it.body]
    v(0.6em, weak: true)
  }

  show heading.where(level: 3): it => {
    v(1.2em, weak: true)
    set par(justify: false, leading: 0.60em, first-line-indent: 0em)
    set text(hyphenate: false)
    text(font: fonts.body, size: 10.5pt, weight: 700, fill: palette.ink)[#it.body]
    v(0.35em, weak: true)
  }

  show image: it => align(left, box(width: 100%, it))

  doc
}

// ---- Page furniture (spec §4) -----------------------------------------
// Three elements and no more: a running head on the outer edge (report
// title verso, chapter title recto), a centred folio, and nothing on a
// chapter-opening page.
#let make-header(title) = context {
  let pg = here().page()
  let openers = query(heading.where(level: 1)).map(h => h.location().page())
  if pg in openers { return }
  let hs = query(selector(heading.where(level: 1)).before(here()))
  let chapter = if hs.len() > 0 { hs.last().body } else { none }
  let label = if calc.odd(pg) and chapter != none { chapter } else { title }
  let f = text(
    font: fonts.furniture,
    size: 7.5pt,
    fill: palette.muted,
    tracking: 0.12em,
    hyphenate: false,
  )[#upper(label)]
  if calc.odd(pg) { align(right, f) } else { align(left, f) }
}

#let make-footer() = context {
  let pg = here().page()
  let openers = query(heading.where(level: 1)).map(h => h.location().page())
  if pg in openers { return }
  align(center, text(font: fonts.furniture, size: 9pt, fill: palette.muted)[
    #counter(page).display()
  ])
}

// ---- The template -----------------------------------------------------
#let report(
  title: "",
  subtitle: "",
  authors: "",
  date: "",
  epigraph: none,
  colophon: none,
  cover-image: none,
  contents: true,
  front-matter: true,
  body,
) = {
  set document(title: title, author: authors)

  // ---- Cover -----------------------------------------------------------
  // Bespoke full-bleed artwork with the title baked in, as on the designer
  // reference. Not templated — see README. Page one is the cover, so the
  // folio the rest of the document shows already counts it.
  if cover-image != none {
    set page(
      width: A4.width,
      height: A4.height,
      margin: 0pt,
      fill: palette.page,
      header: none,
      footer: none,
    )
    image(cover-image, width: 100%, height: 100%, fit: "cover")
    pagebreak()
  }

  set page(
    width: A4.width,
    height: A4.height,
    fill: palette.page,
    binding: left,
    margin: (inside: INNER, outside: OUTER, top: TOP, bottom: BOT),
    header-ascent: 10mm,
    footer-descent: 10mm,
  )
  set text(font: fonts.body, size: BODY-SIZE, fill: palette.ink)

  // Front matter carries no running head and no folio: a title page with a
  // running head on it reads as a page that got away from its template.
  if front-matter {
    // ---- Title page ----------------------------------------------------
    v(34mm)
    block(width: 100%, {
      set par(justify: false, leading: 0.45em)
      set text(hyphenate: false)
      text(font: fonts.display, size: 34pt, weight: 500, fill: palette.ink)[#title]
    })
    v(6mm)
    hairline(palette.accent, len: 18mm, weight: 1.2pt)
    v(6mm)
    block(width: 92mm, {
      set par(justify: false, leading: 0.72em)
      text(font: fonts.display, size: 14pt, fill: palette.muted-ink, style: "italic")[#subtitle]
    })
    if epigraph != none {
      v(16mm)
      block(width: 88mm, {
        set par(justify: false, leading: 0.75em)
        text(size: 9.8pt, fill: palette.muted-ink)[#epigraph]
      })
    }
    v(1fr)
    text(font: fonts.furniture, size: 9pt, fill: palette.ink)[#authors]
    linebreak()
    text(font: fonts.furniture, size: 8.5pt, fill: palette.muted)[#date]
    if colophon != none {
      v(8mm)
      block(width: 100mm, text(font: fonts.furniture, size: 7.5pt, fill: palette.muted)[
        #set par(justify: false, leading: 0.55em)
        #colophon
      ])
    }
    pagebreak()

    // ---- Contents -------------------------------------------------------
    if contents {
      v(10mm)
      text(
        font: fonts.furniture,
        size: 8pt,
        fill: palette.muted,
        tracking: 0.14em,
        hyphenate: false,
      )[CONTENTS]
      v(6mm)
      context {
        let heads = query(heading.where(level: 1))
        for (i, h) in heads.enumerate() {
          let pg = counter(page).at(h.location()).first()
          block(above: 11pt, below: 0pt, grid(
            columns: (10mm, 1fr, auto),
            text(font: fonts.display, size: 9pt, fill: palette.accent, tracking: 0.1em)[
              #numbering("I", i + 1)
            ],
            text(font: fonts.display, size: 12pt, fill: palette.ink)[#h.body],
            text(font: fonts.furniture, size: 9pt, fill: palette.muted)[#pg],
          ))
        }
      }
      pagebreak()
    }
  }

  // Furniture starts with the body (spec §4).
  set page(header: make-header(title), footer: make-footer())
  show: body-rules
  body
}
