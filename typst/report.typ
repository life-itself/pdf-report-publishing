// Life Itself / Second Renaissance report template — prototype v2
// Matched against the designer's reference PDF for this same essay
// (2026-pdf-report-publishing/reference/designer-what-is-2r.pdf), which
// Rufus supplied as the target to imitate. Cover palette/logo sampled
// there too. Body is sans-serif throughout (no serif face) — that's the
// designer's choice, not a fallback.
//
// Known gap: the designer's heading face is a rounded geometric sans
// (Fredoka/Baloo/Poppins-ish); this sandbox has no net access to fetch it,
// so headings fall back to Liberation Sans Bold. Swap `sans-bold` below
// once a real font file is available.

#let cream = rgb("#FFFFE3")
#let maroon = rgb("#4C2E2D")   // headings, TOC top level, footer accent
#let ink    = rgb("#3A2C2B")   // body text
#let muted  = rgb("#8A7370")   // footer / de-emphasised text
#let rose   = rgb("#B5677E")   // emphasis / quotes

#let sans = "Liberation Sans"
#let sans-bold = "Liberation Sans"

#let toc-entry(body, page, level) = {
  let (weight, size, color, pad-left, pad-top) = if level == 1 {
    (700, 11.5pt, maroon, 0pt, 7pt)
  } else {
    (400, 9.5pt, ink.lighten(15%), 16pt, 1pt)
  }
  pad(left: pad-left, top: pad-top)[
    #grid(
      columns: (1fr, auto),
      text(font: sans, weight: weight, size: size, fill: color)[#body],
      text(font: sans, weight: weight, size: size, fill: color)[#page],
    )
  ]
}

#let report(
  title: "",
  subtitle: "",
  authors: "",
  date: "",
  logo: none,
  cover-image: none,
  colophon: none,
  body,
) = {
  set document(title: title, author: authors)

  // ---- Cover page --------------------------------------------------
  // Full-bleed bespoke artwork (title/subtitle are baked into the image
  // itself, same as the reference) — this is how the reference report's
  // cover works, and how covers work in general publishing: bespoke per
  // issue, not template-generated. See README for the reusable-template
  // implication.
  set page(paper: "a4", fill: cream, margin: 0pt)
  if cover-image != none {
    image(cover-image, width: 100%, height: 100%, fit: "cover")
  }

  pagebreak()

  // ---- Title / colophon page -----------------------------------------
  // Combines what the cover doesn't carry (authors, date) with a
  // placeholder copyright/licence line — needs a real decision, see
  // README.
  set page(paper: "a4", fill: white, margin: (x: 3.2cm, top: 4.2cm, bottom: 3.2cm))
  set text(font: sans, fill: ink)
  if logo != none {
    image(logo, width: 2.6cm)
    v(2cm)
  }
  text(size: 26pt, weight: 800, fill: maroon)[#title]
  v(0.3cm)
  text(size: 13pt, weight: 400, fill: ink.lighten(10%))[#subtitle]
  v(0.9cm)
  line(length: 2.4cm, stroke: 1.5pt + rgb("#B99A54"))
  v(0.5cm)
  text(size: 10.5pt, weight: 600)[#authors]
  linebreak()
  text(size: 9pt, fill: muted)[#date]
  v(1fr)
  if colophon != none {
    line(length: 2.2cm, stroke: 0.6pt + muted)
    v(0.5cm)
    text(size: 8pt, fill: muted)[#colophon]
  }

  pagebreak()

  // ---- Table of contents --------------------------------------------
  set page(paper: "a4", fill: white, margin: (left: 5.3cm, right: 2.6cm, top: 2.6cm, bottom: 2.3cm))
  text(font: sans, weight: 800, size: 26pt, fill: maroon, tracking: 0.5pt)[CONTENTS]
  v(0.5cm)
  context {
    let heads = query(heading.where(level: 1).or(heading.where(level: 2)))
    for h in heads {
      toc-entry(h.body, str(h.location().page() - 2), h.level)
    }
  }

  pagebreak()

  // ---- Body pages -----------------------------------------------------
  counter(page).update(2)
  set page(
    paper: "a4",
    fill: white,
    margin: (left: 5.3cm, right: 2.6cm, top: 2.4cm, bottom: 2.3cm),
    footer: context {
      set text(size: 8.5pt, font: sans, fill: muted)
      grid(
        columns: (1fr, auto),
        [#text(weight: 700, fill: maroon)[#title:] #subtitle],
        [#counter(page).display()],
      )
    },
  )
  set text(font: sans, size: 10.8pt, fill: ink, lang: "en")
  set par(justify: false, leading: 0.78em, first-line-indent: 0em)

  show emph: it => text(fill: rose, it)

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(0.3cm)
    text(font: sans-bold, size: 23pt, weight: 800, fill: maroon, tracking: 0.3pt)[#upper(it.body)]
    v(0.7cm)
  }

  show heading.where(level: 2): it => {
    v(0.7cm)
    text(font: sans-bold, size: 15pt, weight: 700, fill: maroon)[#it.body]
    v(0.35cm)
  }

  show heading.where(level: 3): it => {
    v(0.5cm)
    text(font: sans-bold, size: 12pt, weight: 700, fill: ink)[#it.body]
    v(0.2cm)
  }

  show image: it => {
    align(center)[#box(width: 82%, it)]
  }

  show link: it => text(fill: rose, it)

  body
}
