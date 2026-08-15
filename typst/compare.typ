// Style comparison — the same page of content, once per template style.
//
// This replaces `typst/specimen.typ`, which was the wrong artefact twice
// over. It varied only the *fonts* across its four pages, so it asked for
// a judgement about a design while holding colour, furniture and layout
// fixed — and it drew its own preset label into the page footer, which
// overrode the real footer and made the page furniture, the thing most
// worth looking at, invisible.
//
// This one:
//   - varies colour, furniture, grid and type together, because those are
//     what a style is;
//   - renders every page through each style's real `report()` function, so
//     the header, footer, folio and colophon on each page are the genuine
//     ones and nothing is drawn over them;
//   - puts the style's name on its own page, in that style's own palette
//     and display face, so the label is itself a sample rather than an
//     annotation sitting on top of one.
//
// One known artefact: because this file concatenates three documents into
// one, the Essay and Brief nameplate pages inherit a running head naming
// the previous style's chapter. Inside a real single-style document the
// running head is correct; it is left visible here rather than special-
// cased, because special-casing furniture in a comparison is exactly the
// mistake this file exists to undo.
//
// Build: typst compile --font-path fonts --root . typst/compare.typ \
//          output/style-comparison.pdf

#import "lib/styles/review.typ" as review
#import "lib/styles/essay.typ" as essay
#import "lib/styles/brief.typ" as brief
#import "lib/util.typ": box-counter, chapter-counter, fig-counter, hairline

// Each style's pages are a fresh sample, so its counters start again.
#let reset-counters = {
  chapter-counter.update(0)
  fig-counter.update(0)
  box-counter.update(0)
}

// ---- The shared content -----------------------------------------------
// Identical prose in all three, so what differs on the page is the design
// and only the design. The devices differ, because the devices *are* part
// of the design — each style renders the quotation and the interruption
// with its own furniture.

#let TITLE = [What a Style Actually Is]

#let CLAIM = [
  A template style is a grid, a palette, a set of page furniture and a
  type pairing, decided together. Change one of them alone and you have
  not made a variant — you have made an inconsistency.
]

#let P1 = "Three well-typeset reports read page by page turn out to disagree about almost every choice a template makes. One justifies its text and two set it ragged. One uses three type families, one uses two, and one uses barely more than one. One works its wide margin hard, one explains it and one simply commits to leaving it empty."

#let P2 = [
  What they share is not a choice at all. Each has decided what its pages
  say about themselves — where the folio sits, what the running foot
  carries, how a figure is captioned and sourced — and then repeated that
  decision without variation across between forty-six and ninety-six
  pages. The professional look is the consistency.
]

#let P3 = [
  This is why a comparison that varies only the typeface answers the wrong
  question. Set the same paragraph in four faces and the differences are
  real but small, and none of them is the difference between a document
  that reads as designed and one that does not.
]

#let QUOTE = [
  The practical test when adding anything to a template: does this element
  appear on at least ten pages, in exactly the same place, doing exactly
  the same job? If not, it is decoration, and it will cheapen the pages
  that do not have it.
]

#let QUOTE-ATTR = [docs/report-design-principles.md, principle 10]

// A style's name page: set in that style's own palette and display face,
// so the label is a sample rather than a caption.
#let nameplate(name, one-liner, use-for, display-font, ink, accent, muted) = {
  v(30mm)
  hairline(accent, len: 26mm, weight: 1.2pt)
  v(6mm)
  text(font: display-font, size: 46pt, fill: ink)[#name]
  v(8mm)
  block(width: 92mm, {
    set par(justify: false, leading: 0.72em)
    text(font: display-font, size: 13pt, fill: muted)[#one-liner]
  })
  v(6mm)
  block(width: 92mm, {
    set par(justify: false, leading: 0.62em)
    text(size: 9.5pt, fill: muted)[Use it for: #use-for]
  })
  pagebreak()
}

// ---- 1. Review ---------------------------------------------------------
#review.report(
  title: "Style Comparison",
  subtitle: "The same content in three template styles",
  publisher: "Life Itself Research",
  authors: "Design research pass",
  date: "2026.08.16",
  wordmark: "Life Itself Research",
  front-matter: false,
)[
  #reset-counters
  #nameplate(
    [Review],
    [Sober and institutional. A serif body pushed right off a working left rail that carries sources, figure topics and the folio.],
    [evidence reports, research reviews, state-of-the-field documents.],
    review.fonts.body,
    review.palette.ink,
    review.palette.accent,
    review.palette.muted,
  )

  = #TITLE

  #review.lead[#CLAIM]

  #P1

  #P2

  #review.note[The rail is the Review style's signature: it exists so that a source credit never has to interrupt a sentence.]

  #review.blockquote(attribution: QUOTE-ATTR)[#QUOTE]

  #P3

  #review.inventory(lead: [What varies between these three pages], (
    [the grid — where the text column sits and what, if anything, works the margin],
    [the palette, and how many jobs colour is asked to do],
    [the page furniture: masthead, rail, folio, running foot, colophon],
    [the type pairing, which is the part a font specimen would have shown on its own],
  ))
]

// ---- 2. Essay ----------------------------------------------------------
#essay.report(
  title: "Style Comparison",
  subtitle: "The same content in three template styles",
  authors: "Design research pass",
  date: "2026-08-16",
  front-matter: false,
)[
  #reset-counters
  #nameplate(
    [Essay],
    [Literary and warm. A display serif over a reading serif on warm paper, generous margins, and an accent used only on rules and numerals.],
    [long-form argument, essays, book chapters, thought pieces.],
    essay.fonts.display,
    essay.palette.ink,
    essay.palette.accent,
    essay.palette.muted,
  )

  = #TITLE

  #essay.standfirst[#CLAIM]

  #essay.opening(P1)

  #P2

  #essay.pullquote[
    Change one of them alone and you have not made a variant — you have
    made an inconsistency.
  ]

  #P3

  #essay.blockquote(attribution: QUOTE-ATTR)[#QUOTE]
]

// ---- 3. Brief ----------------------------------------------------------
#brief.report(
  title: "Style Comparison",
  subtitle: "The same content in three template styles",
  authors: "Design research pass",
  date: "2026-08-16",
  front-matter: false,
)[
  #reset-counters
  #nameplate(
    [Brief],
    [Direct and sans-forward. A short measure hard left, a worked right rail, boxed key messages and a colophon that identifies any single sheet.],
    [position papers, policy briefs, submissions.],
    brief.fonts.display,
    brief.palette.ink,
    brief.palette.accent,
    brief.palette.muted,
  )

  = #TITLE

  #brief.panel(label: "In brief")[#CLAIM]

  #P1

  #P2

  #brief.assertion[
    The professional look is the consistency, not the choices.
  ]

  #P3

  #brief.keyfigure("10", [pages an element must appear on to earn its place], dy: -28mm)

  #brief.keybox(title: [The test for adding anything to a template], label: "Principle 10")[
    #QUOTE
  ]
]
