---
updated: 2026-08-16
---

# What makes a report look like a report

Template-independent principles, extracted by reading pages of three
exemplar reports (`reference/exemplars/`) rather than by reading design
advice. Every claim below points at a page you can open and check.

This is the layer *above* the template styles. `docs/styles/*.md` each pick
a position on these principles; this document is what they are picking
between. If a style spec and this document disagree, this document is the
one that was reasoned from evidence.

The companion documents:

- `docs/typography-research.md` — the earlier, narrower pass: which fonts
  the exemplars use and why a serif body matters. Still true; this
  supersedes it in scope.
- `docs/typst-cookbook.md` — how to build any of this in Typst.

## The exemplars

| Short name | Report | Format |
|---|---|---|
| **CRI** | Civilization Research Institute, *Reality Check* (Jan 2025) | 96pp, Letter |
| **MI** | The Mindfulness Initiative, *Reconnection* | 87pp, A4 |
| **PCI** | Planetary Civics Inquiry, *A New Framework for Planetary Futures* (Apr 2024) | 46pp, A4 |

They are usefully different from each other. CRI is the most expensively
typeset and the most conventional: serif body, wide working margin,
scholarly furniture. MI is the most *designed*: colour-led, sans
throughout, chapter openers that behave like magazine spreads. PCI is the
most austere: one sans, one narrow column, footnotes, and a machine-like
colophon — it looks less like a brochure and more like a document of
record. All three read as professional. None of them are doing the same
thing. That is the point: there is no single "good report look", there are
coherent positions, and the failure mode is incoherence rather than a
wrong choice.

---

## 1. Page furniture is what separates a report from a Word document

This is the single biggest finding of this pass, and the one the previous
pass missed. Ask what the *repeating* elements on every page are — the
things that are not content — and all three have a considered, distinctive
set. Our template had a folio and nothing else.

**CRI** (see p.7, p.31, p.57) carries, on every single page:

- the organisation's logo, top-left, inside the margin rail — small,
  letterspaced, grey, three lines
- a two-line centred masthead above the text column: publisher in bold,
  report title beneath in regular, both tiny and muted
- the folio bottom-left in the margin rail, set noticeably *large*
  (~14pt) and light grey — a deliberate, confident piece of type, not an
  apology
- a centred footer: `2025.01.30 | Toxic Chemical Pollution` — publication
  date in **mono**, a pipe, then the current section name in bold sans

**MI** carries exactly one thing: a right-aligned footer reading
`Reconnection: Meeting the Climate Crisis Inside Out    9`, title in bold,
subtitle in regular, folio to the right. No header at all. It is minimal,
but it is *chosen* minimal, consistent to the millimetre across 87 pages.

**PCI** does the most unusual thing: its footer is a **colophon block**, a
mono key/value list repeated on every page —

```
Page:    8
Title:   Position Paper for the Planetary Civics Inquiry: A New
         Framework for Planetary Futures
Date:    April 25, 2024
Authors: Zehra Zaidi & Indy Johar
```

— with the logo to its left. It makes any single printed page
self-identifying, which is exactly the register a policy document wants.

**The principle.** Decide what a page says about itself when it is
photocopied and read alone. At minimum: where am I (folio), what is this
(title), which part of it (section). Set that material in a voice clearly
different from the body — smaller, a different family, muted — and repeat
it without variation. The variation is what reads as amateur, not the
repetition.

**Corollary — furniture survives inversions.** CRI's dark full-bleed
summary page (p.3) keeps every piece of furniture, reversed out in the
same positions. A dark page that drops the folio reads as a mistake; one
that keeps it reads as design.

## 2. Asymmetry, and the margin has to be doing something

All three break the centred single-column page, and each breaks it
differently:

- **CRI**: text column pushed right, leaving a ~32mm **working rail** on
  the left that carries source credits, figure topics, the logo and the
  folio. The rail material is right-aligned against the gutter, small,
  italic and muted, so it reads as a distinct column of annotation.
- **MI**: chapter title and standfirst quotation span nearly the full
  width; the running body is then indented into a narrower column
  well to the right. The left margin on body pages is *empty*, but it is
  empty in a way the chapter openers explain — the reader has seen
  something live there.
- **PCI**: the text column is roughly 55% of the page width, hard left,
  with the entire right third empty. Nothing ever occupies it. It works
  because it is so extreme it is obviously deliberate, and because the
  short measure (~62 characters) is genuinely comfortable.

**The principle.** A wide margin must be either *worked* (CRI), *explained*
(MI), or *committed to* (PCI). The failure case — which is what v2 of our
template did — is a wide margin that is empty, unexplained and moderate:
it reads as a broken layout rather than as air.

**Measure.** All three land between roughly 60 and 72 characters per line.
That is the whole rule. Every other dimension on the page can be derived
from choosing a measure and a leading first.

## 3. Something interrupts the prose every two or three pages

Long-form argument set as an undifferentiated column becomes grey slab,
and readers put grey slabs down. Each exemplar has a *signature
interruption* and uses it relentlessly:

- **MI**: the standfirst pull quote. Every chapter opens with a
  five-to-eight line quotation set in the display sans at ~20pt in that
  chapter's accent colour, ragged, with the speaker beneath in small grey
  (p.9, p.36, p.50). Mid-chapter it also has tinted boxes (p.20): a solid
  colour panel, white reversed text, a letterspaced small-caps label
  (`BOX 3: EXPLORE FURTHER`), an icon, and a title in large light weight —
  with a thin outline offset down-and-right behind the panel, which reads
  as depth without a drop shadow.
- **CRI**: the change-of-voice list. On p.44 an argument is broken by a
  bulleted list set in the *sans*, smaller, indented, introduced by a
  coloured sans lead-in (`This kind of mind …`). The content is prose but
  the typography says "this is an inventory, read it differently". Also
  the dark full-bleed summary page, and figures every few spreads.
- **PCI**: indented block quotations, plain enlarged assertion lines set
  inline with no quote marks (p.38), and circled numbered lists.

**The principle.** Pick one or two interruption devices per style and use
them systematically, not decoratively. The device is a *voice change* —
different family, size, colour, or ground — not a different piece of
content. Prose lifted verbatim into a pull quote still works.

## 4. Figures are composed objects

None of the three ever centres a picture between two paragraphs. A figure
is a small assembly with a fixed anatomy:

- **CRI**: a hairline rule marks the figure's extent above; a source
  credit sits in the margin rail alongside it, right-aligned, in italic,
  with the source name in the accent colour and the words `Source:` in
  grey; permission notes (`Used by permission.`) get their own line
  beneath. Figures either fit the text column (p.7) or push out into the
  rail to run nearly full-width (p.23), and the rail credit moves to the
  bottom-right when they do.
- **PCI**: the image sits on a light grey panel with generous internal
  padding, captioned below in small grey sans with a figure number, and
  the caption carries a footnote marker into the page's footnote
  apparatus (p.30).
- **CRI p.57** additionally shows a topic label (`Historical GDP`) in the
  rail, plus a right-aligned running line above the figure —
  `Wealth / Economics (Figure 3 of 3)` — that positions the figure in a
  sequence.

**The principle.** Define the anatomy once: extent marker, number,
caption, source, and where each of those lives relative to the grid. Then
every figure in the report is the same object with different contents.
A figure without a source line looks unsourced even when the text cites it.

## 5. One accent colour, and colour carries structure or nothing

- **CRI**: black text, one desaturated blue for links and marginalia, one
  green used *only* on the dark summary page. Three colours in 96 pages.
- **MI**: the most colourful, and still disciplined — each chapter is
  assigned a single accent (maroon, green, teal) which colours that
  chapter's heading, standfirst and boxes, and nothing else. Colour is
  navigation.
- **PCI**: essentially monochrome on a warm off-white ground, with green
  used only for live hyperlinks.

**The principle.** Colour must be doing a *job* — a link is a link, an
accent marks a section, a tint marks a box — and the number of jobs is the
number of colours. Decoration is not a job. Note also that two of the
three do not use a white page: PCI and MI sit on a faint warm grey, which
takes the glare off long reading and makes black text read as softer
without lightening it.

## 6. Typographic contrast comes from family pairs, not from size

- **CRI**: Freight Text Pro (body, serif) / Freight Sans (subheads,
  captions, furniture) / SF Mono (dates, endnotes). Three voices, each
  with one job. Note especially that **chapter openers are set in the
  serif** at ~34pt (p.31) while **subheads are set in the sans** at ~10pt
  bold (p.44) — the hierarchy switches family as it descends, so a
  subhead can never be mistaken for a small chapter title.
- **MI**: ITC Avant Garde (display) / Oxygen (body). Two voices.
- **PCI**: Inter for everything, DM Mono for the colophon and footnote
  furniture. One-and-a-bit voices, and it is the plainest of the three.

**The principle.** Two families with clearly different jobs beat one
family at six sizes. If you use only one family, it must be a good enough
one to carry the whole document, and you should expect the result to read
as austere rather than as rich — which may be exactly right for a brief.

Two subsidiary observations worth keeping:

- **A mono face is the cheapest way to buy "document of record".** CRI
  sets its endnotes entirely in mono (p.70, p.88); PCI sets its colophon
  in mono. In both cases it makes apparatus feel like apparatus.
- **Numbers in headings can be de-emphasised rather than emphasised.**
  MI p.50 sets `2.2.3` in a lighter weight before `Nature Connection` in
  bold, so the number locates without shouting.

## 7. Justification is a choice, not a mark of quality

The previous research pass claimed all three justify. That is wrong, and
worth correcting because it drove a template decision:

- **CRI** justifies, with hyphenation, in a serif. It is the only one.
- **MI** is ragged right throughout.
- **PCI** is ragged right throughout.

Both ragged-right reports are set in a sans. That is the actual rule:
**justified text needs a serif, hyphenation and a decent measure to avoid
rivers; a sans at a short measure should be set ragged.** Justified sans
with no hyphenation — the word-processor default — is the combination that
reads as untypeset, and it reads that way because of the loose word
spacing, not because of the flush edge.

## 8. Scholarly apparatus is a design element

- **PCI** runs true **footnotes at the foot of every page**, tiny, under a
  short hairline rule, with URLs allowed to wrap and break. It is the
  single strongest signal in that document that it expects to be checked.
- **CRI** runs endnotes, in mono, with hanging numbers and multiple
  sources grouped per note (p.70, p.88).
- **MI** runs numbered references, sans, hanging indent (p.66, p.80).

**The principle.** Decide footnote vs endnote per style, and typeset it
properly — hanging numbers, a rule or a heading that separates apparatus
from argument, and a size drop of at least 2pt. Apparatus that looks like
body text at 90% is worse than no apparatus.

## 9. Openers do the structural work

Chapter openers are where all three spend their budget, because an opener
is what tells the reader the document has parts.

- **CRI p.31**: heading in the display serif at ~34pt over two lines,
  **outdented left past the text column** into the rail, roughly a third
  of the page of air above the body, and — a nice quirk — a first-line
  indent on the *opening* paragraph only, with subsequent paragraphs
  separated by space instead.
- **MI p.36**: full-width coloured display heading, then the standfirst
  quotation, then attribution, then the body drops in at ~40% down the
  page in a narrower column.
- **CRI p.3**: a whole-page inversion for the executive summary — full
  bleed dark ground, the key claim set large in the accent colour,
  preceded by a short rule as a hanging dinkus.

**The principle.** An opener needs (a) a large vertical gap it never
apologises for, (b) a change of scale of at least 3× body size, and
(c) something that isn't the title — a number, a rule, a standfirst, a
colour — so the page has two events on it rather than one.

## 10. Restraint reads as expensive

Everything above can be summarised as: the professional-looking reports
are doing *fewer* things, more consistently, than an amateur one. CRI has
three colours, three families and one page layout. What makes it look
costly is that every page obeys the same rules to the millimetre.

The practical test when adding anything to a template: **does this element
appear on at least ten pages, in exactly the same place, doing exactly the
same job?** If not, it is decoration, and it will cheapen the pages that
do not have it.

---

## What this implies for our three styles

| Principle | **Review** | **Essay** | **Brief** |
|---|---|---|---|
| Furniture | Full CRI set: masthead, rail, mono-dated footer | Quiet: verso title / recto chapter, centred folio | Colophon footer, section rail label |
| Grid | Text right, 32mm working rail | Symmetric-ish, generous margins, no rail | Narrow measure hard left, wide right void |
| Interruption | Marginal notes + figures | Standfirst + pull quote + drop cap | Key-message box + tinted panel |
| Colour | One cool accent, links only | One warm accent, rules and numerals only | Two: structural tint + emphasis |
| Families | Serif body, sans furniture, mono apparatus | Display serif headings, serif body | Geometric sans headings, grotesque body |
| Setting | Justified, hyphenated | Justified, hyphenated | Ragged right |
| Apparatus | Endnotes, mono | Footnotes, serif | Footnotes, sans |

Each column is written out in full in `docs/styles/`.
