// Life Itself report template — v3.
//
// v2 matched the designer reference structurally (cover, colours, margins,
// caps headings, footer) but read as flat: sans-serif throughout, ragged
// text with no hyphenation, images dropped in centred with no caption
// treatment, and a 5.3cm left margin that was simply empty.
//
// v3 keeps the palette and the asymmetric page, and changes three things:
//
//   1. Serif body, sans headings. Every one of the exemplar reports that
//      reads as high-class does this (see theme.typ / the research doc).
//   2. The wide left margin becomes a *working margin column* — figure
//      captions, chapter numbers and marginal notes live there, hung
//      opposite the text they annotate. This is the move that makes CRI's
//      Reality Check look designed rather than merely typeset; an empty
//      wide margin just looks like a mistake.
//   3. Figures are real figures: numbered, captioned, with rules, and with
//      a row form for image sequences that belong together.
//
// Layout metrics (A4, 210mm wide):
//     18mm  edge
//     32mm  margin column   (captions, numbers, notes)
//      8mm  gutter
//    122mm  text column     (~72 characters at 10.2pt Spectral)
//     30mm  outer margin
//
// The page's left margin is set to 58mm (18+32+8) so the text column falls
// where it should; margin-column material is then hung back into it with
// `place`, which is why MARGIN-DX below is negative.

#import "theme.typ": palette, preset, furniture

#let EDGE      = 18mm
#let MARGIN-W  = 32mm
#let GUTTER    = 8mm
#let TEXT-L    = EDGE + MARGIN-W + GUTTER   // 58mm
#let TEXT-R    = 30mm
#let MARGIN-DX = -(MARGIN-W + GUTTER)       // hang back into the margin

// Figure counter, shared by fig() and figrow().
#let figure-counter = counter("li-figure")

// ---------------------------------------------------------------------
// Margin column
// ---------------------------------------------------------------------

// Hang arbitrary content in the left margin, right-aligned against the
// gutter so it reads as a column edge rather than floating text.
#let marginal(body, dy: 0pt) = {
  place(
    left,
    dx: MARGIN-DX,
    dy: dy,
    box(width: MARGIN-W, align(right, body)),
  )
}

// A marginal note: small, muted, in the furniture sans.
#let note(body) = marginal(
  text(font: furniture, size: 7.5pt, fill: palette.muted, hyphenate: false)[
    #set par(leading: 0.55em, justify: false)
    #body
  ],
)

// ---------------------------------------------------------------------
// Figures
// ---------------------------------------------------------------------

// A single figure. The caption hangs in the margin column, aligned to the
// top of the image — so the eye reads number, caption, image left to right
// without the caption interrupting the text column's rhythm.
//
//   width:  fraction of the text column. Defaults to full width; narrow
//           images should be given a smaller value rather than being
//           stretched, which is what made the old output look amateur.
#let fig(path, caption: none, width: 100%) = {
  figure-counter.step()
  block(
    breakable: false,
    above: 1.6em,
    below: 1.6em,
    {
      // Hairline across the text column marks the figure's top edge and
      // separates it from the paragraph above.
      line(length: 100%, stroke: 0.5pt + palette.rule)
      v(0.7em, weak: true)
      // The number is always shown, caption or not — it is what lets the
      // text refer to "Fig. 3" at all, and an unlabelled image in a report
      // is just decoration.
      context marginal(
        text(font: furniture, size: 7.5pt, fill: palette.muted, hyphenate: false)[
          #set par(leading: 0.55em, justify: false)
          #text(weight: 600, fill: palette.maroon)[Fig. #figure-counter.display()]
          #if caption != none [#linebreak() #caption]
        ],
        dy: 0.2em,
      )
      align(center, box(width: width, image(path, width: 100%)))
    },
  )
}

// A row of related images that belong together as one figure — the
// Cimabue / Perugino / Picasso sequence is the case this exists for.
// Each gets its own sub-caption beneath; the row shares one figure number
// in the margin, because it is one argument, not three.
//
//   items: array of (path, caption) pairs
//   ratios: optional column widths, defaulting to equal
#let figrow(items, caption: none, ratios: none) = {
  figure-counter.step()
  let cols = if ratios == none { (1fr,) * items.len() } else { ratios }
  block(
    breakable: false,
    above: 1.6em,
    below: 1.6em,
    {
      line(length: 100%, stroke: 0.5pt + palette.rule)
      v(0.7em, weak: true)
      // The number is always shown, caption or not — it is what lets the
      // text refer to "Fig. 3" at all, and an unlabelled image in a report
      // is just decoration.
      context marginal(
        text(font: furniture, size: 7.5pt, fill: palette.muted, hyphenate: false)[
          #set par(leading: 0.55em, justify: false)
          #text(weight: 600, fill: palette.maroon)[Fig. #figure-counter.display()]
          #if caption != none [#linebreak() #caption]
        ],
        dy: 0.2em,
      )
      grid(
        columns: cols,
        column-gutter: 5mm,
        align: bottom,
        ..items.map(it => {
          // Images in a row are aligned on their baselines and sized to
          // the column, so a tall narrow image and a wide short one still
          // read as a set.
          image(it.at(0), width: 100%)
        }),
      )
      v(0.5em)
      grid(
        columns: cols,
        column-gutter: 5mm,
        align: top,
        ..items.map(it => text(
          font: furniture,
          size: 7.5pt,
          fill: palette.muted,
          hyphenate: false,
        )[#set par(leading: 0.55em, justify: false); #it.at(1)]),
      )
    },
  )
}

// ---------------------------------------------------------------------
// Editorial devices
// ---------------------------------------------------------------------

// A pull quote: large, rose, ragged, set full-bleed across margin +
// text column so it visibly interrupts the page. Borrowed from the
// Mindfulness Initiative report, where these are the main thing keeping
// 87 pages of continuous prose readable.
#let pullquote(body, attribution: none) = block(
  above: 2.2em,
  below: 2.2em,
  breakable: false,
  {
    place(left, dx: MARGIN-DX, box(width: MARGIN-W + GUTTER + 100%, {
      set par(justify: false, leading: 0.62em)
      text(size: 19pt, fill: palette.rose, weight: 400)[#body]
      if attribution != none {
        v(0.6em)
        text(font: furniture, size: 8.5pt, fill: palette.muted)[— #attribution]
      }
    }))
    // Reserve the vertical space the placed box occupies.
    hide(block(width: MARGIN-W + GUTTER + 100%, {
      set par(justify: false, leading: 0.62em)
      text(size: 19pt)[#body]
      if attribution != none { v(0.6em); text(size: 8.5pt)[— #attribution] }
    }))
  },
)

// A block quotation. Distinct from `pullquote`: a pull quote is a short
// phrase lifted *out* of the text for emphasis and set large; a block
// quotation is a long passage quoted *into* the text and should be set
// smaller than body, not larger.
//
// This exists because the essay's four long quotations were arriving as
// whole paragraphs wrapped in Markdown emphasis, which the template's
// `show emph` rule then rendered as several hundred words of rose italic
// — the worst-looking thing in the v2 output. Here they get: a hung
// quotation mark in the margin column, roman (not italic) text one step
// down from body size, and the attribution in the furniture sans.
#let blockquote(body, attribution: none) = block(
  above: 1.8em,
  below: 1.8em,
  breakable: true,
  {
    // Set in the furniture sans: at 34pt the serif faces' left double
    // quote is steeply angled and reads as a pair of slashes.
    marginal(text(
      font: furniture, size: 34pt, weight: 600, fill: palette.rose.lighten(45%),
    )[\u{201C}], dy: -6pt)
    set par(justify: true, leading: 0.78em)
    text(size: 0.94em, fill: palette.ink.lighten(8%))[#body]
    if attribution != none {
      v(0.5em)
      set par(justify: false)
      text(font: furniture, size: 8pt, fill: palette.muted)[#attribution]
    }
  },
)

// A standfirst: the bolded "Claim: ..." paragraph that opens several
// chapters of this essay. Treating it as a deck rather than just another
// bold paragraph gives each chapter an opening beat.
#let standfirst(body) = block(
  above: 0.4em,
  below: 1.6em,
  {
    set par(justify: false, leading: 0.72em)
    text(size: 12pt, fill: palette.maroon, weight: 400)[#body]
  },
)

// ---------------------------------------------------------------------
// Body type rules
// ---------------------------------------------------------------------

// Everything that decides how a *body page* reads, as a show rule taking
// a type preset. Factored out of report() so specimen.typ can render the
// same excerpt in each preset and be guaranteed it is showing the real
// design rather than a mock-up that has drifted.
#let body-rules(p, doc) = {
  set text(font: p.body, size: p.body-size, fill: palette.ink, lang: "en")
  // Justified with hyphenation. The v2 output was ragged-right and
  // unhyphenated, which is the single most word-processor-ish thing a
  // long-form document can do; a justified serif column with hyphenation
  // is what makes a page read as typeset.
  set par(justify: true, leading: p.leading, first-line-indent: 0em, spacing: 1.5em)
  set text(hyphenate: true)

  show emph: it => text(fill: palette.rose, it)
  show link: it => text(fill: palette.rose, it)
  show strong: it => text(weight: 600, fill: palette.maroon, it)

  // Chapter openings: number hung in the margin column, title in the text
  // column, generous air above. The number comes from the heading's own
  // order rather than the stripped source numbering.
  let chapter = counter("chapter")
  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    chapter.step()
    v(6mm)
    // Zero-padded by hand: Typst's numbering patterns treat a leading "0"
    // as a literal character, so `display("01")` renders chapter 16 as
    // "016" rather than "16".
    context {
      let n = chapter.get().first()
      let label = if n < 10 { "0" + str(n) } else { str(n) }
      marginal(text(
        font: furniture, size: 8pt, weight: 600, fill: palette.muted, tracking: 1.2pt,
      )[#label], dy: 6pt)
    }
    // Chapter titles are allowed to run past the text column into the
    // outer margin — the left margin is spoken for by the chapter number,
    // so the extra measure has to come from the right. Hyphenation off: a
    // hyphenated display line ("PARADIG-MATIC") is the most obvious tell
    // of an unattended template.
    set par(justify: false, leading: 0.72em)
    set text(hyphenate: false)
    block(width: 100% + 20mm, text(
      font: p.heading,
      size: 24pt,
      weight: p.heading-weight,
      fill: palette.maroon,
      tracking: p.heading-track,
    )[#if p.heading-case == "upper" { upper(it.body) } else { it.body }])
    v(7mm)
  }

  show heading.where(level: 2): it => {
    v(7mm, weak: true)
    set par(justify: false)
    set text(hyphenate: false)
    text(font: p.heading, size: 13.5pt, weight: p.heading-weight, fill: palette.maroon)[#it.body]
    v(2.5mm, weak: true)
  }

  show heading.where(level: 3): it => {
    v(5mm, weak: true)
    set par(justify: false)
    set text(hyphenate: false)
    text(font: furniture, size: 10pt, weight: 600, fill: palette.ink)[#it.body]
    v(1.5mm, weak: true)
  }

  // Any bare image that slipped through without going via fig() still gets
  // sane treatment rather than being stretched to the column.
  show image: it => align(center, box(width: 88%, it))

  doc
}

// ---------------------------------------------------------------------
// The template
// ---------------------------------------------------------------------

#let report(
  title: "",
  subtitle: "",
  authors: "",
  date: "",
  logo: none,
  cover-image: none,
  colophon: none,
  style: "warm",
  body,
) = {
  let p = preset(style)
  set document(title: title, author: authors)

  // ---- Cover ---------------------------------------------------------
  // Bespoke full-bleed artwork; title and subtitle are baked into the
  // image, as on the reference. See README for why this is not templated.
  set page(paper: "a4", fill: palette.cream, margin: 0pt)
  if cover-image != none {
    image(cover-image, width: 100%, height: 100%, fit: "cover")
  }
  pagebreak()

  // ---- Title / colophon ----------------------------------------------
  set page(paper: "a4", fill: white, margin: (left: TEXT-L, right: TEXT-R, top: 40mm, bottom: 24mm))
  set text(font: p.body, fill: palette.ink)

  if logo != none {
    marginal(image(logo, width: 22mm))
  }
  text(font: p.heading, size: 30pt, weight: p.heading-weight, fill: palette.maroon)[#title]
  v(0.35cm)
  text(size: 13pt, fill: palette.ink.lighten(15%), style: "italic")[#subtitle]
  v(1.1cm)
  line(length: 26mm, stroke: 1.2pt + palette.gold)
  v(0.5cm)
  text(font: furniture, size: 9.5pt, weight: 600, fill: palette.ink)[#authors]
  linebreak()
  text(font: furniture, size: 8.5pt, fill: palette.muted)[#date]
  v(1fr)
  if colophon != none {
    line(length: 22mm, stroke: 0.5pt + palette.rule)
    v(0.4cm)
    text(font: furniture, size: 7.5pt, fill: palette.muted)[
      #set par(leading: 0.6em, justify: false)
      #colophon
    ]
  }
  pagebreak()

  // ---- Contents ------------------------------------------------------
  set page(paper: "a4", fill: white, margin: (left: TEXT-L, right: TEXT-R, top: 26mm, bottom: 24mm))
  marginal(text(
    font: furniture, size: 8pt, weight: 600, fill: palette.muted, tracking: 1.2pt,
  )[CONTENTS])
  v(2mm)
  context {
    let heads = query(heading.where(level: 1).or(heading.where(level: 2)))
    for h in heads {
      let pg = str(h.location().page() - 2)
      if h.level == 1 {
        block(above: 13pt, below: 0pt, grid(
          columns: (1fr, auto),
          text(font: p.heading, size: 11.5pt, weight: p.heading-weight, fill: palette.maroon)[#h.body],
          text(font: furniture, size: 9pt, fill: palette.muted)[#pg],
        ))
      } else {
        block(above: 5pt, below: 0pt, pad(left: 6mm, grid(
          columns: (1fr, auto),
          text(font: p.body, size: 9.5pt, fill: palette.ink.lighten(20%))[#h.body],
          text(font: furniture, size: 8.5pt, fill: palette.muted)[#pg],
        )))
      }
    }
  }
  pagebreak()

  // ---- Body ----------------------------------------------------------
  counter(page).update(2)
  set page(
    paper: "a4",
    fill: white,
    margin: (left: TEXT-L, right: TEXT-R, top: 26mm, bottom: 24mm),
    footer: context {
      set text(font: furniture, size: 7.5pt, fill: palette.muted)
      // Folio hangs in the margin column, opposite the running title —
      // it reads as part of the same left-hand rail as the captions.
      place(left, dx: MARGIN-DX, box(width: MARGIN-W, align(right)[
        #text(size: 9pt, weight: 600, fill: palette.maroon)[#counter(page).display()]
      ]))
      text(weight: 600, fill: palette.muted)[#title]
      h(0.6em)
      text(fill: palette.rule.darken(20%))[|]
      h(0.6em)
      [#subtitle]
    },
  )

  show: body-rules.with(p)
  body
}
