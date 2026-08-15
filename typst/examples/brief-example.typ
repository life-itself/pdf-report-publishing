// Example document for the BRIEF style.
//
// Real content again: the actual recommendation coming out of this
// project — how Life Itself should publish reports from Markdown, and
// what it would cost. A brief is a document someone has to act on, so the
// example is written as one rather than as a specimen with headings.

#import "../lib/styles/brief.typ": (
  assertion, blockquote, fig, figc, keybox, keyfigure, palette, panel,
  rail-note, report, runin,
)
#import "diagrams.typ": grid-diagram

#show: report.with(
  title: "Publishing Reports from Markdown",
  subtitle: "A recommendation for Life Itself's report pipeline, and what it costs to adopt",
  authors: "Design research pass",
  date: "2026-08-16",
  summary: [
    Life Itself should typeset reports with Typst, driven from Markdown,
    using one of three specified template styles chosen per document. The
    toolchain is settled; what was missing was a design specification, and
    that is now written. The remaining work is content-side, not
    engineering: choosing which sentences become pull quotes and which
    numbers become key figures.
  ],
)

= The problem

#runin[Markdown in, PDF out, and it has to look considered][A Google Docs
export is not a typeset document. It is ragged, unhyphenated, has one piece
of page furniture (a centred folio) and treats an image as something
dropped between two paragraphs. Reports produced that way read as internal
memos regardless of how good the argument is.]

The gap is not a font gap. Comparing three well-regarded published reports
page by page#footnote[Civilization Research Institute, #emph[Reality
Check] (2025); The Mindfulness Initiative, #emph[Reconnection]; Planetary
Civics Inquiry, #emph[A New Framework for Planetary Futures] (2024). Full
readings in `docs/report-design-principles.md`.] shows they disagree about
almost every choice a template makes — one justifies and two do not, one
uses three type families and one uses one — and agree completely about
discipline.

#assertion[
  The professional look is the consistency, not the choices.
]

#keyfigure(
  "3",
  [reports read page by page, at 46, 87 and 96 pages],
  dy: -34mm,
)

That is good news for a template: it means there is no single correct
design to discover, only a coherent one to specify and then obey.

= The recommendation

#keybox(title: [Adopt Typst with three specified styles, not one])[
  Typst compiles Markdown to PDF in about a second, vendors its own fonts,
  and expresses page furniture directly. Three template styles — Review,
  Essay and Brief — cover the document types Life Itself actually
  publishes. Each is written as a Markdown specification first and
  implemented second, so the design is reviewable by someone who does not
  read code.
]

== Why three and not one

An earlier version of this work aimed at a single strong template. That was
the right instinct and the wrong number. The three document types have
incompatible requirements:

- an evidence review needs a margin rail so a source credit never
  interrupts a sentence;
- a long-form essay needs the fewest possible devices and the most air;
- a brief needs boxes, footnotes and a short measure, because it will be
  read in fragments and acted on.

#rail-note(
  [Every measurement here is specified in `docs/styles/brief.md` §1 and
  implemented in `typst/lib/styles/brief.typ`.],
)

A single template that served all three would be a template that had not
decided what it was. Choosing per document takes about ten seconds and the
choice is written down.

#panel(label: "How to choose", title: [Three questions])[
  Is the reader expected to *check* it — data, citations, sources? Use
  #strong[Review]. \
  Is the reader expected to be *carried through* an argument? Use
  #strong[Essay]. \
  Is the reader expected to *act* on it, and probably to read only some of
  it? Use #strong[Brief].
]

== What each style fixes

#figc(
  grid-diagram(
    (
      ([margin\ 20mm], 20 / 210, false),
      ([text column 118mm], 118 / 210, true),
      ([gut], 8 / 210, false),
      ([rail 44mm], 44 / 210, true),
      ([edge\ 20mm], 20 / 210, false),
    ),
    height: 34mm,
    fill-color: white,
    line-color: palette.muted,
    label-color: palette.muted,
    label-font: "Work Sans",
  ),
  caption: [The Brief grid. The rail is on the right, after the text rather
  than before it: it summarises what has just been read instead of
  annotating what is being read. Boxes and figures may span the whole
  170mm, which is this style's strongest visual event and should stay
  rare.],
  wide: true,
)

= What it costs to adopt

== Engineering: done

The pipeline exists. Markdown is cleaned by a small set of scripts, passed
through Pandoc to Typst markup, and compiled against one of the three
styles. Fonts are vendored under an open licence, so a build produces the
same PDF on any machine.#footnote[Left to itself Typst falls back silently
to whatever the machine has installed — the same source produced Liberation
Sans in one sandbox and a system serif on macOS. Vendoring is not optional.]

== Editorial: the real remaining work

The devices that make the exemplar pages breathe — pull quotes,
standfirsts, key figures, boxed key messages — all require someone to
decide #emph[which] sentence or number gets lifted. That is a content
judgement, and no amount of template work substitutes for it.

#blockquote(attribution: [docs/report-design-principles.md, principle 3])[
  Pick one or two interruption devices per style and use them
  systematically, not decoratively. The device is a voice change — different
  family, size, colour, or ground — not a different piece of content. Prose
  lifted verbatim into a pull quote still works.
]

#keyfigure("~30 min", [per chapter, to choose standfirsts and pull quotes], dy: -30mm)

Budget roughly half an hour per chapter with an author. After that the
template renders the devices for free, and the difference between a page
that reads as a grey slab and one that reads as designed is made.

== What is still open

- The copyright and licence line is placeholder text and needs a real
  decision.
- Print-on-demand trim size, bleed and binding gutter are not addressed;
  all three styles are specified for A4 screen and office print.
- Covers remain bespoke artwork rather than templated, which is probably
  correct but is not written down anywhere as a decision.

= Recommendation

#keybox(
  title: [Ship the three styles; spend the next hour on editorial, not on code],
  label: "Recommendation",
)[
  The specifications in `docs/styles/` are complete and implemented, and
  each has an example PDF built from real content so the claims in the
  specs are checkable rather than asserted. The highest-value next action
  is not another template pass — it is sitting down with an author and
  choosing the pull quotes.
]
