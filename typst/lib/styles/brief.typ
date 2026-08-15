// Style: BRIEF — implementation of docs/styles/brief.md.
//
// Direct, sans-forward, skimmable. Short measure hard left, a worked right
// rail for key figures and labels, boxed key messages, footnotes on every
// page, and a colophon that identifies any single sheet. Derived from PCI's
// *Planetary Futures* and the Mindfulness Initiative's boxes; see
// docs/report-design-principles.md.

#import "../util.typ": A4, box-counter, fig-counter, hairline, rail-right

// ---- Grid (spec §1) ---------------------------------------------------
#let EDGE = 20mm
#let TEXT-W = 118mm
#let GUT = 8mm
#let RAIL = 44mm
#let TOP = 22mm
#let BOT = 34mm
#let FULL-W = TEXT-W + GUT + RAIL // 170mm — the widest an object may run

// ---- Colour (spec §3) -------------------------------------------------
#let palette = (
  page: rgb("#F6F6F4"),
  ink: rgb("#16191C"),
  muted-ink: rgb("#454B50"),
  muted: rgb("#6E767C"),
  accent: rgb("#12464F"),
  tint: rgb("#E4EDEE"),
  highlight: rgb("#C1701A"),
  rule: rgb("#D5D8D6"),
)

// ---- Type (spec §2) ---------------------------------------------------
#let fonts = (
  display: "Outfit",
  body: "Work Sans",
  mono: "DM Mono",
)

// Measured line-height constants (docs/typst-cookbook.md):
// Work Sans 0.66, Outfit 0.694, DM Mono 0.70.
#let BODY-SIZE = 10pt
#let BODY-LEAD = 0.84em // 1.50x

// ---- Right rail (spec §4, §5) -----------------------------------------
#let rail(body, dy: 0pt) = rail-right(body, width: RAIL, gutter: GUT, dy: dy)

// A short label or annotation in the rail.
#let rail-note(body, dy: 0pt) = rail(
  text(font: fonts.body, size: 8pt, fill: palette.muted, hyphenate: false)[
    #set par(leading: 0.47em, justify: false)
    #body
  ],
  dy: dy,
)

// A key figure: a number the body text has already given, restated large.
// The rail restates; it never introduces (spec §5).
#let keyfigure(value, label, dy: 0pt) = rail(
  {
    set par(leading: 0.3em, justify: false)
    text(font: fonts.display, size: 26pt, weight: 600, fill: palette.highlight)[#value]
    v(0.25em)
    text(font: fonts.body, size: 7.5pt, fill: palette.muted, hyphenate: false)[
      #set par(leading: 0.47em)
      #label
    ]
  },
  dy: dy,
)

// ---- Boxes (spec §5) --------------------------------------------------
// The signature interruption: a solid accent panel spanning the full
// 170mm, with a tracked label, a display title, and reversed body. The
// 0.8pt outline offset down-and-right gives depth without a shadow and
// survives greyscale printing.
#let keybox(title: none, label: auto, body) = {
  box-counter.step()
  block(above: 1.6em, below: 1.6em, breakable: false, {
    let draw = {
      let lab = if label == auto {
        context [KEY MESSAGE #box-counter.get().first()]
      } else { label }
      block(width: FULL-W, fill: palette.accent, inset: 8mm, {
        set text(font: fonts.body, size: 9.4pt, fill: palette.page)
        set par(justify: false, leading: 0.79em)
        if lab != none {
          text(size: 7.5pt, weight: 600, tracking: 0.16em, fill: palette.page.darken(18%))[
            #upper(lab)
          ]
          v(0.7em, weak: true)
        }
        if title != none {
          text(font: fonts.display, size: 15pt, weight: 400)[#title]
          v(0.8em, weak: true)
        }
        body
      })
    }
    // The offset outline has to know the panel's height, and a `place`d box
    // with `height: 100%` resolves against the page, not against the block
    // — which draws a rule down the whole page. Measure the panel instead.
    context {
      let h = measure(draw).height
      place(dx: 2mm, dy: 2mm, box(
        width: FULL-W,
        height: h,
        stroke: 0.8pt + palette.accent,
      ))
      draw
    }
  })
}

// The quiet variant: tint fill, ink text, no offset outline.
#let panel(title: none, label: none, body, width: FULL-W) = block(
  above: 1.4em,
  below: 1.4em,
  breakable: false,
  block(width: width, fill: palette.tint, inset: 8mm, {
    set text(font: fonts.body, size: 9.4pt, fill: palette.ink)
    set par(justify: false, leading: 0.79em)
    if label != none {
      text(size: 7.5pt, weight: 600, tracking: 0.16em, fill: palette.accent)[#upper(label)]
      v(0.7em, weak: true)
    }
    if title != none {
      text(font: fonts.display, size: 15pt, weight: 400, fill: palette.accent)[#title]
      v(0.8em, weak: true)
    }
    body
  }),
)

// ---- Assertion line (spec §5) -----------------------------------------
// A single claim standing between two paragraphs. No quote marks, no rule
// — cheaper than a pull quote and it does not break the argument's flow.
#let assertion(body) = block(above: 1.2em, below: 1.2em, {
  set par(justify: false, leading: 0.66em) // 1.35x on 13pt
  set text(hyphenate: false)
  text(font: fonts.display, size: 13pt, fill: palette.ink)[#body]
})

// A run-in head: bold, ends with a period, body continues on the same line.
#let runin(term, body) = par({
  text(weight: 700)[#term.]
  h(0.5em)
  body
})

#let blockquote(body, attribution: none) = block(
  above: 1.2em,
  below: 1.2em,
  pad(left: 10mm, {
    set par(justify: false, leading: 0.79em)
    text(size: 9.4pt, fill: palette.muted-ink)[#body]
    if attribution != none {
      v(0.4em, weak: true)
      text(size: 8pt, fill: palette.muted)[\u{2014} #attribution]
    }
  }),
)

// ---- Figures (spec §5) ------------------------------------------------
// Image on a tint panel; caption below in muted sans. Sources go to the
// footnotes — this style sends everything checkable to the foot of the page.
#let figc(content, caption: none, wide: false) = {
  fig-counter.step()
  block(breakable: false, above: 1.5em, below: 1.5em, {
    let w = if wide { FULL-W } else { TEXT-W }
    let draw = {
      block(width: w, fill: palette.tint, inset: 6mm, content)
      v(0.55em, weak: true)
      context text(font: fonts.body, size: 8pt, fill: palette.muted, hyphenate: false)[
        #set par(leading: 0.47em, justify: false)
        #text(weight: 600)[Figure #fig-counter.get().first().]
        #h(0.35em)
        #caption
      ]
    }
    box(width: w, draw)
  })
}

#let fig(path, width: 100%, ..args) = figc(
  align(center, box(width: width, image(path, width: 100%))),
  ..args,
)

// ---- Body rules -------------------------------------------------------
#let body-rules(doc) = {
  // Ragged right, hyphenation off: at 62 characters in a sans this is the
  // correct setting, and justifying here opens rivers within three lines
  // (docs/report-design-principles.md, principle 7).
  set text(font: fonts.body, size: BODY-SIZE, fill: palette.ink, lang: "en", hyphenate: false)
  set par(justify: false, leading: BODY-LEAD, spacing: 0.70em + 0.7em)

  show link: it => text(fill: palette.highlight, it)
  show strong: it => text(weight: 700, it)

  set list(marker: text(fill: palette.accent)[\u{2013}], indent: 4mm, spacing: 0.8em)
  set enum(indent: 4mm, spacing: 0.8em, numbering: n => text(fill: palette.accent)[#n.])

  // Footnotes at the foot of every page, never endnotes: a brief is read
  // in fragments, and an endnote in a fragment is useless.
  show footnote.entry: it => {
    set text(font: fonts.body, size: 7pt, fill: palette.muted-ink)
    set par(justify: false, leading: 0.68em)
    it
  }
  set footnote.entry(
    separator: hairline(palette.rule, len: 40mm),
    gap: 0.6em,
    clearance: 1.8em,
    indent: 5mm,
  )
  show footnote: it => text(font: fonts.mono, size: 0.65em, fill: palette.accent, it)

  // Outline headings: the number locates, it does not shout (spec §5).
  show heading.where(level: 1): it => {
    v(2.0em, weak: true)
    set par(justify: false, leading: 0.60em)
    set text(hyphenate: false)
    context {
      let n = counter(heading).get().first()
      text(font: fonts.display, size: 17pt, weight: 400, fill: palette.muted)[
        #numbering("A.", n)#h(0.45em)
      ]
      text(font: fonts.display, size: 17pt, weight: 500, fill: palette.ink)[#it.body]
    }
    v(0.7em, weak: true)
  }

  show heading.where(level: 2): it => {
    v(1.4em, weak: true)
    set par(justify: false, leading: 0.60em)
    set text(hyphenate: false)
    text(font: fonts.display, size: 11.5pt, weight: 500, fill: palette.accent)[#it.body]
    v(0.45em, weak: true)
  }

  show heading.where(level: 3): it => {
    v(1.0em, weak: true)
    set par(justify: false)
    set text(hyphenate: false)
    text(font: fonts.body, size: 10pt, weight: 700, fill: palette.ink)[#it.body]
    v(0.3em, weak: true)
  }

  show image: it => align(center, box(width: 100%, it))

  doc
}

// ---- Page furniture (spec §4) -----------------------------------------
// A hairline under the top margin across the text column only; the current
// section's name at the top of the rail; and a colophon at the foot in
// place of a folio — the page number lives in the colophon, which is what
// makes the footer read as a record rather than as decoration.
#let make-header() = context {
  hairline(palette.rule, len: TEXT-W)
  let hs = query(selector(heading.where(level: 1)).before(here()))
  if hs.len() > 0 {
    rail(text(
      font: fonts.body,
      size: 8pt,
      weight: 600,
      fill: palette.muted,
      hyphenate: false,
    )[#set par(leading: 0.47em, justify: false); #hs.last().body], dy: -0.35em)
  }
}

#let make-footer(title, date, authors, wordmark) = context {
  let row(k, v) = grid(
    columns: (16mm, 1fr),
    text(fill: palette.muted)[#k], text(fill: palette.muted-ink)[#v],
  )
  set text(font: fonts.mono, size: 7pt)
  set par(leading: 0.40em, justify: false)
  grid(
    columns: (if wordmark == none { 0mm } else { 22mm }, 1fr),
    if wordmark == none { [] } else { image(wordmark, width: 16mm) },
    {
      row("Page:", counter(page).display())
      row("Title:", title)
      row("Date:", date)
      row("Authors:", authors)
    },
  )
}

// ---- The template -----------------------------------------------------
#let report(
  title: "",
  subtitle: "",
  authors: "",
  date: "",
  wordmark: none,
  summary: none,
  front-matter: true,
  body,
) = {
  set document(title: title, author: authors)
  set page(
    width: A4.width,
    height: A4.height,
    fill: palette.page,
    margin: (left: EDGE, right: EDGE + GUT + RAIL, top: TOP, bottom: BOT),
    header: make-header(),
    header-ascent: 7mm,
    footer: make-footer(title, date, authors, wordmark),
    footer-descent: 6mm,
  )
  set heading(numbering: "A.1")
  set text(font: fonts.body, size: BODY-SIZE, fill: palette.ink)

  if front-matter {
    // The cover is the first page of the document, not a separate object:
    // a brief that opens with a title page the reader has to turn past is
    // a brief that wastes its most-read page.
    v(10mm)
    block(width: FULL-W, {
      set par(justify: false, leading: 0.42em)
      set text(hyphenate: false)
      text(font: fonts.display, size: 30pt, weight: 600, fill: palette.ink)[#title]
    })
    v(4mm)
    block(width: FULL-W - 20mm, {
      set par(justify: false, leading: 0.60em)
      text(font: fonts.display, size: 14pt, weight: 400, fill: palette.muted)[#subtitle]
    })
    v(7mm)
    hairline(palette.accent, len: FULL-W, weight: 1pt)
    v(8mm)
    if summary != none {
      panel(label: "In brief", summary)
    }
  }

  show: body-rules
  body
}
