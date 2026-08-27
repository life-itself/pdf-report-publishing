---
updated: 2026-08-27
---

# Design decisions

Why this project is built the way it is. Archival: each entry records a
decision that was actually made, when, and what it cost — so the next
person doesn't reopen a settled question without knowing what was already
weighed.

Not a to-do list. Open questions live in `NEXT.md` and in
[issues](https://github.com/life-itself/pdf-report-publishing/issues).

---

## Typst, not Pandoc + LaTeX

**2026-08-15.** Both pipelines were built and both produced a genuinely
presentable report on the first real attempt, cover included. Typst won on:

- **Iteration speed** — sub-second recompiles, source-located error
  messages, no TeX package-download purgatory.
- **Readability** — styling reads like normal code (`show` rules) rather
  than macro archaeology, which matters if a non-technical collaborator is
  ever to touch it.
- **Coverage** — footnotes (`#footnote[…]`) and bibliographies
  (`#bibliography()`, `#cite()`, BibTeX or Hayagriva, APA/Chicago built in)
  are native, which were the two things we thought might force LaTeX.

Against: a smaller ecosystem than LaTeX's — fewer existing citation styles,
less prior art. Nothing this project needs is missing.

**Pandoc + LaTeX (Tectonic)** remains in `pandoc-latex/`, working, as a
fallback if reports ever need print-on-demand-specific packages or exotic
bibliography styles. Tectonic sidesteps the classic "install 4GB of TeX
Live" problem by fetching only the packages actually used. It is not
getting further design investment.

## Three template styles, not one

**2026-08-16.** The earlier aim was a single strong template. Right
instinct, wrong number: the three document types have incompatible
requirements.

- An evidence review needs a margin rail so a source credit never
  interrupts a sentence.
- A long-form essay needs the fewest possible devices and the most air.
- A brief needs boxes, footnotes and a short measure, because it will be
  read in fragments and acted on.

A single template serving all three would be a template that had not
decided what it was. Choosing per document takes seconds and the choice is
written down in `docs/styles/README.md`.

Cost: three implementations to maintain instead of one. Mitigated by
keeping genuinely shared technique in `typst/lib/util.typ` and letting the
styles diverge everywhere else — forcing them through one parameterised
engine would make each harder to read than it is standalone.

## Specs first, implementation second

**2026-08-16.** Each style is written as a Markdown specification — grid in
millimetres, type scale in points, palette with a named job per colour —
*before* any Typst is written, and the spec is the artefact. The
implementation is the proof.

This exists because the previous attempt went wrong in exactly the
opposite direction: a mechanically fine type specimen that was
conceptually wrong, because nobody had written down what the design was
supposed to be doing.

If a spec and its implementation disagree, fix whichever is wrong and say
which. The example PDFs exist so that "the spec says X" is checkable
rather than asserted.

## Palettes are brand-independent

**2026-08-16.** Explicitly *not* derived from the Life Itself brand.
Rufus's steer was to avoid guessing at the brand; the palettes are instead
derived from what each exemplar report demonstrated, and each style is
written so its palette can be swapped without touching layout.

The inherited brown ink from the designer reference is gone. It was never
defended — it came along with the reference and nobody liked it.

## Departing from the designer reference

**2026-08-16.** `reference/designer-what-is-2r.pdf` was the original target
and is no longer the thing to match. What was kept and what was dropped:

**Kept:** headings that outdent past the text column so they read as a
distinct layer; honouring the author's manual page breaks, which give
chapters air.

**Dropped:**

- **Sans-serif body.** Every exemplar that reads as high-class uses a serif
  body with the sans confined to headings and furniture. A long-form
  argument set entirely in a UI sans reads like a slide deck that got out
  of hand.
- **ALL-CAPS headings in a rounded geometric extrabold.** Baloo 2 was
  vendored as the open-licence stand-in for the reference's heading face
  and used by the v3 `warm` preset. The principle that replaced it: if it
  is a sans, use a genuinely good sans; if a serif, a genuinely good serif;
  do not sit between the two.
- **The very wide empty left margin.** 53mm of nothing reads as a mistake,
  not as generosity. Either fill it or narrow it — see principle 2 in
  `docs/report-design-principles.md`.

Palette and layout were originally sampled from the reference by averaging
pixel colour under its rendered glyphs, and compared by eye. Good enough
for a first pass; never pixel-perfect, and now moot.

## Covers are bespoke, not templated

**2026-08-15.** The cover uses the reference artwork full-bleed rather than
a re-creation.

The first attempt rebuilt it from parts — logo, Typst-rendered title, a
couple of cropped illustration fragments — and looked flat, then collided
text with artwork once the illustrations were added back, because the crop
boundaries could not cleanly separate "title text" from "bird artwork":
they occupy overlapping regions of the source image.

Using the artwork directly is pixel-perfect with zero overlap risk. Cost:
this cover is bespoke to this title, not template-driven. That is how
professional covers normally work — designed per issue — but it is worth
flagging, because the rest of the template is meant to be reusable. A
reusable template eventually needs either a designer producing per-report
art, or a simpler generated-cover fallback.

A **title/colophon page** (page 2, after the cover) carries what the cover
does not: title and subtitle repeated smaller, authors, date, and a licence
line.

## Editorial marks live in a sidecar, not inline

**2026-08-16.** Standfirsts and pull quotes are marked in
`source/<doc>.editorial.txt`, not in the Markdown itself.

Two reasons:

1. The source is a Google Docs export and gets re-exported. Inline markers
   die on every re-export; a sidecar survives.
2. A pull quote duplicates body text. Inlining the copy lets it drift out
   of sync with the original during editing.

The sidecar *names* a sentence rather than copying it, so what gets typeset
is the text as it appears in the Markdown — verbatim by construction. A
mark that no longer matches fails the build and names the chapter, which
is what stops the sidecar rotting.

Related: which sentence gets lifted is an editorial judgement and cannot be
inferred. Measured on the 2R essay, only 2 of 16 chapters have a
syntactically detectable standfirst, and of six inline bold runs of 6+
words in the whole document, one is a plausible pull quote.

## Structure recovery guesses conservatively, or not at all

**2026-08-15 onward.** The Google Docs export loses structure the author
plainly intended, and `scripts/` recovers it — but only where the marker is
unambiguous.

`» **Term**` definition items *were* safe to convert, because that marker
means nothing else in the document. Bold-line section labels and the
`Modern → / Postmodern → / Metamodern →` triads were deliberately left
alone: the heuristics that catch them also catch `**Sylvie:**` speaker
labels and the long `**Claim: …**` standfirsts, and guessing wrong is worse
than leaving them plain.

The fix for those is a short interactive pass that records a human's
classification once — the same sidecar-plus-verification shape as the
editorial marks. Tracked in
[#2](https://github.com/life-itself/pdf-report-publishing/issues/2).
