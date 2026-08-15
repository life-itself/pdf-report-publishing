// Style: REVIEW — implementation of docs/styles/review.md.
//
// Sober, institutional, checkable. Serif body pushed right off a working
// left rail carrying sources, figure topics, chapter numbers and the folio.
// Derived from CRI's *Reality Check*; see docs/report-design-principles.md.
//
// Every constant below is traceable to a line in the spec. If you change
// one, change the spec too — the spec is the artefact, this is the proof.

#import "../util.typ": (
  A4, box-counter, chapter-counter, fig-counter, hairline, label-caps, pad2,
  rail-left, reserve,
)

// ---- Grid (spec §1) ---------------------------------------------------
#let EDGE = 14mm
#let RAIL = 30mm
#let GUT = 8mm
#let TEXT-L = EDGE + RAIL + GUT // 52mm
#let TEXT-W = 138mm
#let TEXT-R = A4.width - TEXT-L - TEXT-W // 20mm
#let TOP = 22mm
#let BOT = 20mm

// ---- Colour (spec §3) -------------------------------------------------
#let palette = (
  page: rgb("#FFFFFF"),
  ink: rgb("#1B2226"),
  muted: rgb("#7C858B"),
  accent: rgb("#2A6E7A"),
  rule: rgb("#D7DCDE"),
  dark: rgb("#16242A"),
  dark-accent: rgb("#8ECFC2"),
)

// ---- Type (spec §2) ---------------------------------------------------
#let fonts = (
  body: "Source Serif 4",
  furniture: "Work Sans",
  mono: "DM Mono",
)

// Leading is specified in the spec as a line-height multiple. Typst's
// `leading` is the *gap*, so leading = multiple − the font's own
// ascender+descender in em. Measured constants: Source Serif 4 = 0.67,
// Work Sans = 0.66, DM Mono = 0.70. See docs/typst-cookbook.md.
#let BODY-SIZE = 10pt
#let BODY-LEAD = 0.75em // 1.42x

// ---- Rail helpers -----------------------------------------------------
#let rail(body, dy: 0pt, align-to: right) = rail-left(
  body,
  width: RAIL,
  gutter: GUT,
  dy: dy,
  align-to: align-to,
)

#let rail-text(body) = text(
  font: fonts.furniture,
  size: 7.5pt,
  fill: palette.muted,
  hyphenate: false,
)[#set par(leading: 0.44em, justify: false); #body]

// A marginal note: any short annotation hung in the rail (spec §5).
#let note(body) = rail(rail-text(emph(body)))

// A source credit: `Source:` muted, the name beneath in accent italic,
// and an optional permission line. The one piece of figure anatomy that
// does not live with the figure (spec §5).
#let credit(name, permission: none, dy: 0pt) = rail(
  rail-text[
    Source: #linebreak()
    #text(fill: palette.accent, style: "italic")[#name]
    #if permission != none [#linebreak() #v(0.35em) #permission]
  ],
  dy: dy,
)

// ---- Figures (spec §5) ------------------------------------------------
// Anatomy, in order: hairline marking the top edge; image; caption below
// prefixed by an accent figure number. Source goes in the rail, except on
// a wide figure where it moves below, right-aligned.
#let figc(
  content,
  caption: none,
  source: none,
  permission: none,
  wide: false,
) = {
  fig-counter.step()
  block(breakable: false, above: 1.7em, below: 1.7em, {
    let w = if wide { TEXT-W + RAIL + GUT } else { TEXT-W }
    let draw = {
      hairline(palette.rule, len: 100%)
      v(0.75em, weak: true)
      content
      v(0.7em, weak: true)
      context text(font: fonts.furniture, size: 8pt, fill: palette.muted, hyphenate: false)[
        #set par(leading: 0.42em, justify: false)
        #text(weight: 600, fill: palette.accent)[FIG.#h(0.35em)#pad2(fig-counter.get().first())]
        #h(0.6em)
        #caption
      ]
      // On a wide figure the rail is occupied by the image, so the credit
      // moves below the caption, right-aligned (spec §5).
      if wide and source != none {
        v(0.5em, weak: true)
        align(right, text(
          font: fonts.furniture,
          size: 7.5pt,
          fill: palette.muted,
          style: "italic",
        )[Source: #text(fill: palette.accent)[#source]#if permission != none [ — #permission]])
      }
    }
    if wide {
      // Push left into the rail. `place` reserves no height, so a hidden
      // copy reserves it (see docs/typst-cookbook.md).
      place(left, dx: -(RAIL + GUT), box(width: w, draw))
      reserve(box(width: w, draw))
    } else {
      if source != none { credit(source, permission: permission, dy: 1.4em) }
      draw
    }
  })
}

// The common case: a figure whose content is an image file.
#let fig(path, width: 100%, ..args) = figc(
  align(center, box(width: width, image(path, width: 100%))),
  ..args,
)

// A row of images that make one argument and therefore share one number.
#let figrow(items, caption: none, source: none) = {
  fig-counter.step()
  block(breakable: false, above: 1.7em, below: 1.7em, {
    hairline(palette.rule, len: 100%)
    v(0.75em, weak: true)
    if source != none { credit(source, dy: 1.4em) }
    grid(
      columns: (1fr,) * items.len(),
      column-gutter: 5mm,
      align: bottom,
      ..items.map(it => image(it.at(0), width: 100%)),
    )
    v(0.45em)
    grid(
      columns: (1fr,) * items.len(),
      column-gutter: 5mm,
      align: top,
      ..items.map(it => text(font: fonts.furniture, size: 7.5pt, fill: palette.muted)[
        #set par(leading: 0.42em, justify: false); #it.at(1)
      ]),
    )
    v(0.7em, weak: true)
    context text(font: fonts.furniture, size: 8pt, fill: palette.muted, hyphenate: false)[
      #set par(leading: 0.42em, justify: false)
      #text(weight: 600, fill: palette.accent)[FIG.#h(0.35em)#pad2(fig-counter.get().first())]
      #h(0.6em)
      #caption
    ]
  })
}

// ---- The signature interruption (spec §5) -----------------------------
// A run of parallel statements set in the furniture sans, one step down,
// introduced by an accent lead-in. The voice changes; the content does not.
#let inventory(lead: none, items) = block(
  breakable: true,
  above: 1.35em,
  below: 1.35em,
  pad(left: 6mm, {
    if lead != none {
      text(font: fonts.furniture, size: 9pt, weight: 600, fill: palette.accent)[#lead]
      v(0.7em, weak: true)
    }
    set text(font: fonts.furniture, size: 9pt, fill: palette.ink)
    set par(justify: false, leading: 0.79em) // 1.45x
    for it in items {
      block(above: 0.75em, below: 0.75em, grid(
        columns: (6mm, 1fr),
        text(fill: palette.muted)[\u{00B7}],
        it,
      ))
    }
  }),
)

// ---- Quotation (spec §5) ----------------------------------------------
#let blockquote(body, attribution: none) = block(
  breakable: true,
  above: 1.5em,
  below: 1.5em,
  pad(x: 8mm, {
    set text(size: 9.4pt)
    set par(justify: true, leading: 0.73em) // 1.40x
    body
    if attribution != none {
      v(0.5em, weak: true)
      set par(justify: false)
      text(font: fonts.furniture, size: 8pt, fill: palette.muted)[\u{2014} #attribution]
    }
  }),
)

// ---- Table (spec §5) --------------------------------------------------
// No verticals, no fill: an ink rule above and below the header, a
// hairline under the last row.
#let dtable(columns: auto, aligns: auto, ..cells) = {
  let all = cells.pos()
  let n = if type(columns) == int { columns } else { columns.len() }
  let rows = int(all.len() / n)
  block(above: 1.5em, below: 1.5em, table(
    columns: columns,
    align: aligns,
    // An ink rule above and below the header row, a hairline under the
    // last row, and nothing else. No verticals, no fill (spec §5).
    stroke: (x, y) => (
      top: if y == 0 { 0.8pt + palette.ink } else if y == 1 { 0.6pt + palette.ink } else { none },
      bottom: if y == rows - 1 { 0.6pt + palette.rule } else { none },
    ),
    inset: (x: 3pt, y: 6pt),
    fill: none,
    ..all
      .slice(0, n)
      .map(c => text(font: fonts.furniture, size: 8.5pt, weight: 600, fill: palette.ink)[#c]),
    ..all.slice(n).map(c => text(size: 9pt)[#c]),
  ))
}

// ---- Lead paragraph (spec §2) -----------------------------------------
// The first paragraph after a chapter title takes a 2em first-line indent
// and no other paragraph does. Marked explicitly rather than inferred:
// a `show par` rule that tracks "am I the first" needs mutable state read
// during layout, which is exactly the sort of thing that fails to converge.
#let lead(body) = par(first-line-indent: (amount: 2em, all: true), body)

// ---- Back matter ------------------------------------------------------
// Notes, bibliography and appendices get a chapter opener but no chapter
// number — they are not part of the argument's sequence. Emitted as a flag
// in the flow rather than as a variant heading so that back-matter
// sections still appear in the contents like everything else.
#let backmatter-state = state("rp-backmatter", false)
#let backmatter = backmatter-state.update(true)

// ---- Endnotes (spec §5) -----------------------------------------------
#let endnotes(items) = {
  set text(font: fonts.mono, size: 7.5pt, fill: palette.ink)
  set par(justify: false, leading: 0.80em) // 1.5x
  for (i, it) in items.enumerate() {
    block(above: 1.1em, below: 1.1em, grid(
      columns: (8mm, 1fr),
      column-gutter: 0pt,
      text(fill: palette.muted)[#(i + 1)],
      it,
    ))
  }
}

// ---- Body rules -------------------------------------------------------
// Factored out so the comparison artefact can render the same content
// through exactly this code path rather than through a mock-up.
#let body-rules(doc) = {
  set text(font: fonts.body, size: BODY-SIZE, fill: palette.ink, lang: "en", hyphenate: true)
  set par(justify: true, leading: BODY-LEAD, spacing: 1.45em)

  show link: it => text(fill: palette.accent, it)
  show strong: it => text(weight: 600, fill: palette.ink, it)

  set list(marker: text(fill: palette.muted)[\u{2022}], indent: 4mm, spacing: 0.9em)
  set enum(indent: 4mm, spacing: 0.9em)

  // Chapter opener (spec §5): zero-padded number in the rail, title in the
  // body serif outdented to the rail's right edge, then a large fixed gap.
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(18mm)
    // The number sits in the rail *above* the title's first line, not
    // beside it: the title outdents all the way to the rail's right edge,
    // so anything level with it would touch. Back matter has no number.
    // Two context blocks, not one: a counter read inside the same context
    // that steps it still sees the pre-step value, because the step takes
    // effect at the location the returned content lands in.
    context { if not backmatter-state.get() { chapter-counter.step() } }
    context {
      if not backmatter-state.get() {
        rail(text(
          font: fonts.furniture,
          size: 9pt,
          weight: 600,
          fill: palette.muted,
          tracking: 0.08em,
        )[#pad2(chapter-counter.get().first())], dy: -6mm)
      }
    }
    set par(justify: false, leading: 0.45em) // 1.12x on 30pt
    set text(hyphenate: false)
    // Outdent 8mm: the title starts at the rail's right edge, so it reads
    // as a layer above the text column rather than as a big paragraph.
    place(left, dx: -GUT, box(width: TEXT-W + GUT, text(
      font: fonts.body,
      size: 30pt,
      weight: 400,
      fill: palette.ink,
    )[#it.body]))
    reserve(box(width: TEXT-W + GUT, text(font: fonts.body, size: 30pt)[#it.body]))
    v(26mm)
  }

  show heading.where(level: 2): it => {
    v(1.6em, weak: true)
    set par(justify: false, leading: 0.64em)
    set text(hyphenate: false)
    text(
      font: fonts.furniture,
      size: 10.5pt,
      weight: 700,
      fill: palette.accent,
    )[#it.body]
    v(0.5em, weak: true)
  }

  show heading.where(level: 3): it => {
    v(1.1em, weak: true)
    set par(justify: false, leading: 0.64em)
    set text(hyphenate: false)
    text(
      font: fonts.furniture,
      size: 9.5pt,
      weight: 600,
      fill: palette.muted,
    )[#it.body]
    v(0.4em, weak: true)
  }

  show image: it => align(center, box(width: 90%, it))

  doc
}

// ---- Page furniture (spec §4) -----------------------------------------
// Masthead centred over the text column; wordmark at the top of the rail;
// folio at the foot of the rail, deliberately large; centred footer of
// mono date + current section name.
//
// `inverse: true` reverses it for the full-bleed summary page — the
// furniture never disappears, it only changes colour (principle 1).
#let make-header(publisher, title, wordmark) = context {
  let fg = palette.muted
  align(center, text(font: fonts.furniture, size: 7.5pt, fill: fg)[
    #set par(leading: 0.30em, justify: false)
    #text(weight: 600)[#publisher] #linebreak() #title
  ])
  if wordmark != none {
    rail(
      text(
        font: fonts.furniture,
        size: 7.5pt,
        fill: fg,
        tracking: 0.14em,
        hyphenate: false,
      )[
        #set par(leading: 0.42em, justify: false)
        #upper(wordmark)
      ],
      align-to: left,
      dy: -0.2em,
    )
  }
}

#let make-footer(date) = context {
  let fg = palette.muted
  // The folio hangs at the foot of the rail: the same left-hand column as
  // the captions and credits, so the page has one continuous edge.
  rail(text(font: fonts.furniture, size: 13pt, fill: fg)[
    #counter(page).display()
  ], dy: -0.35em)
  // Section name = the last level-1 heading at or before this page.
  let hs = query(selector(heading.where(level: 1)).before(here()))
  let section = if hs.len() > 0 { hs.last().body } else { none }
  align(center, text(font: fonts.mono, size: 8pt, fill: fg)[
    #date
    #if section != none [
      #h(0.5em) | #h(0.5em)
      #text(font: fonts.furniture, size: 8pt, weight: 600)[#section]
    ]
  ])
}

// ---- The inverted summary page (spec §5) ------------------------------
#let summary-page(claim: none, label: "Summary", body) = {
  pagebreak(weak: true)
  set page(fill: palette.dark)
  set text(fill: palette.page)
  show heading.where(level: 2): it => {
    v(1.4em, weak: true)
    text(font: fonts.furniture, size: 10.5pt, weight: 700, fill: palette.dark-accent)[#it.body]
    v(0.5em, weak: true)
  }
  v(4mm)
  if label != none {
    rail(text(
      font: fonts.furniture,
      size: 8pt,
      weight: 600,
      fill: palette.muted,
      tracking: 0.14em,
      hyphenate: false,
    )[#upper(label)], dy: 0.5em)
  }
  if claim != none {
    block(width: 100%, {
      set par(justify: false, leading: 0.52em)
      set text(hyphenate: false)
      text(font: fonts.body, size: 19pt, fill: palette.dark-accent)[
        #box(baseline: -0.28em, line(length: 22mm, stroke: 1.2pt + palette.dark-accent))
        #h(0.5em)
        #claim
      ]
    })
    v(10mm)
  }
  body
  pagebreak(weak: true)
}

// ---- The template -----------------------------------------------------
#let report(
  title: "",
  subtitle: "",
  publisher: "",
  authors: "",
  date: "",
  wordmark: none,
  abstract: none,
  contents: true,
  front-matter: true,
  body,
) = {
  set document(title: title, author: authors)
  set page(
    width: A4.width,
    height: A4.height,
    fill: palette.page,
    margin: (left: TEXT-L, right: TEXT-R, top: TOP, bottom: BOT),
    header: make-header(publisher, title, wordmark),
    header-ascent: 8mm,
    footer: make-footer(date),
    footer-descent: 7mm,
  )
  set text(font: fonts.body, size: BODY-SIZE, fill: palette.ink)

  if front-matter {
    // ---- Title page --------------------------------------------------
    v(28mm)
    block(width: TEXT-W + GUT, {
      set par(justify: false, leading: 0.52em)
      text(font: fonts.body, size: 38pt, fill: palette.ink)[#title]
    })
    v(5mm)
    hairline(palette.accent, len: 26mm, weight: 1.2pt)
    v(5mm)
    block(width: 110mm, {
      set par(justify: false, leading: 0.60em)
      text(size: 13pt, fill: palette.muted)[#subtitle]
    })
    v(1fr)
    text(font: fonts.furniture, size: 9.5pt, weight: 600, fill: palette.ink)[#authors]
    linebreak()
    text(font: fonts.mono, size: 8.5pt, fill: palette.muted)[#date]
    if abstract != none {
      v(8mm)
      hairline(palette.rule, len: 26mm)
      v(4mm)
      block(width: 118mm, text(font: fonts.furniture, size: 8.5pt, fill: palette.muted)[
        #set par(justify: false, leading: 0.60em)
        #abstract
      ])
    }
    pagebreak()

    // ---- Contents ------------------------------------------------------
    if contents {
      rail(text(
        font: fonts.furniture,
        size: 8pt,
        weight: 600,
        fill: palette.muted,
        tracking: 0.14em,
      )[CONTENTS])
      v(1mm)
      context {
        let heads = query(heading.where(level: 1).or(heading.where(level: 2)))
        // Sub-heads that appear before the first chapter belong to front
        // matter (the summary page) and would otherwise float at the top of
        // the contents with nothing above them.
        let seen-chapter = false
        for h in heads {
          if h.level == 1 { seen-chapter = true }
          if h.level == 2 and not seen-chapter { continue }
          let pg = counter(page).at(h.location()).first()
          if h.level == 1 {
            block(above: 12pt, below: 0pt, grid(
              columns: (1fr, auto),
              text(font: fonts.body, size: 12pt, fill: palette.ink)[#h.body],
              text(font: fonts.furniture, size: 9pt, fill: palette.muted)[#pg],
            ))
          } else {
            block(above: 5pt, below: 0pt, pad(left: 6mm, grid(
              columns: (1fr, auto),
              text(font: fonts.furniture, size: 9pt, fill: palette.muted)[#h.body],
              text(font: fonts.furniture, size: 8.5pt, fill: palette.muted)[#pg],
            )))
          }
        }
      }
      pagebreak()
    }
  }

  show: body-rules
  body
}
