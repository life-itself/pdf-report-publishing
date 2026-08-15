// Example document for the REVIEW style.
//
// The content is real: it is the evidence behind
// docs/report-design-principles.md. A style specimen made of lorem ipsum
// proves nothing about how a style handles argument, citation and
// apparatus, which is most of what this style exists to handle.

#import "../lib/styles/review.typ": (
  blockquote, credit, dtable, endnotes, fig, figc, figrow, inventory, lead, note,
  backmatter, palette, report, summary-page,
)
#import "diagrams.typ": furniture-diagram, grid-diagram

#show: report.with(
  title: "Reading the Exemplars",
  subtitle: "What three well-typeset reports do that a word processor does not, and what we took from each",
  publisher: "Life Itself Research",
  authors: "Design research pass, August 2026",
  date: "2026.08.16",
  wordmark: "Life Itself Research",
  abstract: [
    Set in the *Review* style. Grid, palette, furniture and every element
    used below are specified in `docs/styles/review.md`; the principles
    they implement are in `docs/report-design-principles.md`.
  ],
)

#summary-page(
  claim: [Three reports, three different answers, and none of the differences
  are about fonts.],
)[
  == The finding

  Comparing the Civilization Research Institute's #emph[Reality Check], the
  Mindfulness Initiative's #emph[Reconnection] and the Planetary Civics
  Inquiry's #emph[A New Framework for Planetary Futures] page by page shows
  that they agree on almost nothing at the level of choice — one justifies
  and two do not, one uses three type families and one uses one, one has a
  worked left margin and one has an empty right third — and agree almost
  completely at the level of discipline.

  What they share is that each has decided what its pages say about
  themselves, and then repeated that decision without variation for between
  46 and 96 pages. The professional look is the consistency, not the
  choices.

  == What follows

  Section 01 sets out the page furniture each report carries. Section 02
  covers the grid, and in particular what a wide margin has to be doing to
  avoid reading as a mistake.
]

= Page Furniture

#lead[
  Ask what the repeating, non-content elements on a page are and the three
  exemplars answer with confidence and at length. Ask the same question of
  an untreated word-processor export and the answer is a centred page
  number. This is the largest single difference between the two, and it is
  almost entirely independent of typeface.
]

The furniture is what a page says about itself when it has been separated
from its document — photocopied, screenshotted, pulled out of a folder
eighteen months later. At minimum a reader needs to know where they are,
what this is, and which part of it they are holding.

#note[The masthead, wordmark, rail folio and mono-dated footer on this page are the Review style's answer, specified in full in `docs/styles/review.md` §4.]

== What each report carries

The three sets are strikingly unequal in size, and all three work.

#inventory(lead: [Reality Check, on every page], (
  [a wordmark at the top of the left rail — letterspaced, grey, three lines],
  [a two-line masthead centred above the text column: publisher in bold, report title beneath],
  [the folio at the foot of the rail, set deliberately large in light grey],
  [a centred footer of publication date in mono, a pipe, and the current section name in bold sans],
))

#emph[Reconnection] carries exactly one element — a right-aligned footer
giving title, subtitle and folio — and it is no less convincing, because it
is identical on all 87 pages. The Planetary Civics paper does the most
unusual thing: its footer is a colophon, a mono key/value block naming the
page, title, date and authors, so that any single sheet identifies itself
completely.

#fig(
  "/typst/assets/duck-rabbit-illusion.png",
  caption: [Furniture is a framing device: it tells the reader what kind of thing they are looking at before they read a word. The same page with institutional furniture and with none is read differently, in the same way the same drawing is read as a duck or a rabbit depending on what you were told to expect.],
  source: [Jastrow, 1899],
  width: 52%,
)

== The rule that follows

Decide the set once, in the spec, and then never vary it. Variation is what
reads as amateur; repetition is what reads as expensive. The corollary is
worth stating because it is where templates usually fail:

#blockquote(
  attribution: [docs/report-design-principles.md, principle 1],
)[
  Furniture survives inversions. The dark full-bleed summary page in
  #emph[Reality Check] keeps every piece of furniture, reversed out in the
  same positions. A dark page that drops the folio reads as a mistake; one
  that keeps it reads as design.
]

The summary page in this document is built the same way, which is the only
honest way to check the claim.

= The Grid

#lead[
  All three exemplars break the centred single column, and each breaks it
  differently. The interesting part is not that they are asymmetric but
  that each asymmetry is justified by something.
]

#figc(
  grid-diagram(
    (
      ([edge\ 14mm], 14 / 210, false),
      ([rail\ 30mm], 30 / 210, true),
      ([gutter], 8 / 210, false),
      ([text column 138mm], 138 / 210, true),
      ([outer\ 20mm], 20 / 210, false),
    ),
    fill-color: palette.rule.lighten(35%),
    line-color: palette.muted,
    label-color: palette.muted,
  ),
  caption: [The Review grid at A4. The shaded bands carry content; the two margins and the gutter never do. Because the rail is 30mm and the outer margin 20mm, the text block sits visibly right of centre — which is what makes the rail read as a column rather than as slack.],
)

== Three positions on the same problem

#dtable(
  columns: (auto, 1fr, auto),
  aligns: (left, left, right),
  [Report], [What the wide margin does], [Measure],
  [#emph[Reality Check]], [Works it — sources, figure topics, wordmark, folio], [c. 77 ch],
  [#emph[Reconnection]], [Explains it — chapter openers span it, body pages do not], [c. 72 ch],
  [#emph[Planetary Futures]], [Commits to it — the right third is never used], [c. 65 ch],
)

#note[Character counts measured from rendered pages at 80dpi, not taken from the publishers.]

The failure case is the fourth option: a wide margin that is empty,
unexplained and moderate. That reads as a broken layout rather than as air,
and it is what an earlier version of this template did with a 53mm left
margin inherited from a designer reference and then left blank.

== What we took

#inventory(lead: [The Review style's grid, and why], (
  [a 30mm rail at 14mm from the page edge, because rail material needs to be a column, not an indent],
  [an 8mm gutter that is always empty, because a rail without a gutter is a two-column layout],
  [a 138mm text column, giving about 74 characters — the top of the comfortable range, which is where #emph[Reality Check] sits],
  [a 20mm outer margin, narrower than the rail side, so the page reads as pushed right rather than centred],
))

#fig(
  "/typst/assets/paradigmatic-features-landscape.png",
  caption: [A wide figure pushes left into the rail to run the full 176mm. When it does, the source credit moves below the caption and ranges right, because the rail is occupied.],
  source: [Life Itself],
  wide: true,
)

== Measure first

Everything above is downstream of one decision. Choose a measure between 60
and 75 characters and a leading to go with it, and the rest of the grid —
column width, margins, where the rail can go — is determined. Choosing
margins first and discovering the measure afterwards is how a page ends up
at 90 characters, which no amount of good typeface choice will rescue.

#backmatter
= Notes

#endnotes((
  [Civilization Research Institute, #emph[Reality Check], January 2025.
  96pp, Letter. Freight Text Pro / Freight Sans / SF Mono.
  https://civilizationresearchinstitute.org/],
  [The Mindfulness Initiative, #emph[Reconnection: Meeting the Climate
  Crisis Inside Out]. 87pp, A4. Oxygen / ITC Avant Garde.
  https://www.themindfulnessinitiative.org/],
  [Planetary Civics Inquiry, #emph[A New Framework for Planetary Futures],
  April 2024. 46pp, A4. Inter / DM Mono.],
  [Fonts read out of each PDF with `pdffonts`; grids and sizes measured
  from pages rendered at 80dpi with `pdftoppm`. Page-level readings are
  recorded in `docs/report-design-principles.md`.],
))
