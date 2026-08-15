---
updated: 2026-08-16
---

# What makes a report look high-class

Research done before touching the template again, per `NEXT.md` item 1.
The brief was: don't keep iterating blind on one design — go and look at
reports that are genuinely well typeset and work out *what specifically*
they are doing.

## Where the exemplars came from

Rufus's Are.na board — [report-inspirations-for-life-itself](https://www.are.na/rufus-pollock/report-inspirations-for-life-itself)
— has 11 blocks. Most are web essays (Distill, Inkandswitch, Epoch AI,
transformer-circuits) which are interesting for interaction but not for
print typesetting. Three are actual downloadable report PDFs, and those
are what this note is based on:

| Report | Body | Display | Format |
|---|---|---|---|
| [CRI, *Reality Check*](https://civilizationresearchinstitute.org/wp-content/uploads/2025/01/CRI-RealityCheck-1.pdf) | Freight Text Pro | Freight Sans + SF Mono | 96pp, Letter |
| [The Mindfulness Initiative, *Reconnection*](https://www.themindfulnessinitiative.org/) | Oxygen | ITC Avant Garde | 87pp, A4 |
| [PCI, *A New Framework for Planetary Futures*](https://cdn.prod.website-files.com/668400197070c499d03bb489/67124296cf139c5400cf85d8_PCI_PositionPaper_A%20New%20Framework%20for%20Planetary%20Futures%20(2).pdf) | Inter | Inter + DM Mono | 46pp, A4 |

Plus the existing target, `reference/designer-what-is-2r.pdf`.

(Fonts read out of each PDF with `pdffonts`, which is a fast way to find
out what a design you admire is actually set in.)

## What they have in common

**1. A serif body, with the sans confined to furniture.** This is the
single biggest finding, and it directly contradicts the v2 template. CRI —
comfortably the most high-class of the three — sets its body in Freight
Text Pro and uses Freight Sans only for headings, captions and folios.
PCI is the exception (all Inter) and is also the plainest-looking of the
three. The v2 template was sans throughout, matched from the designer
reference, and that is a large part of why it read as flat: a long-form
argument set entirely in a UI sans reads like a slide deck that got out
of hand.

**2. The wide margin does work.** CRI's most distinctive move is a wide
left margin that isn't empty — it carries source credits, marginal notes
and the logo, set small, muted, and right-aligned against the gutter, so
the page has a visible left-hand rail. The v2 template had a 5.3cm left
margin copied from the designer reference with nothing in it. An empty
wide margin doesn't read as generous, it reads as a mistake. Either fill
it or narrow it.

**3. Figures are figures, not images.** In all three, an image is a
composed object: a rule or a frame marking its extent, a caption in a
different (smaller, sans) voice from the body, a number, and often a
data-source line in tiny type below. None of them simply centre a
picture between two paragraphs, which is what v2 did.

**4. One accent colour, used sparingly.** CRI: black text, a single blue
for links and marginalia. Mindfulness: grey-blue for pull quotes and
tinted boxes. The Life Itself palette (maroon / rose / gold) already has
more colours than any of these — the discipline needed is in restraint,
not in more colour.

**5. Something interrupts the prose every few pages.** The Mindfulness
report is 87 pages of continuous argument and stays readable almost
entirely because of pull quotes — 20pt+, accent-coloured, ragged, five or
six lines long, with the speaker beneath — plus tinted summary boxes.
Without a device like this, a long essay becomes an undifferentiated
grey slab, which is what our chapters currently are.

**6. Justified, hyphenated text.** All three justify. The v2 output was
ragged-right with no hyphenation, which is the default in every word
processor and therefore the thing that most reliably signals "not
typeset".

## What the designer reference does that's worth keeping

- Headings outdent past the text column, so they read as a distinct layer
  rather than as bigger paragraphs.
- The palette. It was sampled accurately in the last session and is good.
- Honouring the author's manual page breaks, which give chapters air.

## What it does that we shouldn't copy

- Sans-serif body (see finding 1).
- ALL CAPS headings in a rounded geometric extrabold. Kept as the default
  in the `warm` preset for brand continuity, but it's the loudest option
  of the four and worth a second look — caps at that weight fights the
  restraint that makes the exemplars feel expensive.
- The very wide empty left margin (see finding 2).

## How this landed in the template

| Finding | Change in v3 |
|---|---|
| Serif body | Every preset in `theme.typ` pairs a serif body with a sans display face |
| Working margin | 32mm margin column carrying figure numbers, captions, chapter numbers, folios |
| Real figures | `fig()` / `figrow()` in `report.typ`, fed by `scripts/figures.py` |
| Restraint | Palette unchanged; accents confined to emphasis, links and figure numbers |
| Interruptions | `pullquote()` and `standfirst()` available (not yet used in this essay — see NEXT.md) |
| Justified + hyphenated | `set par(justify: true)` + `hyphenate: true`, with hyphenation off on headings |

## On choosing a pairing

`output/type-specimen.pdf` renders the same real page of the essay in all
four presets, one per page, through the same code path the report uses.
The intent is to pick by looking at type doing the job — a chapter
opening, a subhead, justified body at the real measure, a bold run, an
italic run, a captioned figure — rather than from font names.

Reading of the four, for what it's worth:

- **`editorial` (Work Sans / Literata)** — the most like CRI. Literata is
  designed for long-form screen and print reading and holds up best over
  30 pages. My recommendation if the report is meant to be *read*.
- **`display` (Fraunces / Source Serif 4)** — the most obviously
  beautiful and the most magazine-like. Best if the report is meant to be
  *shown*.
- **`warm` (Baloo 2 / Spectral)** — closest to the existing brand, since
  Baloo 2 stands in for the reference's rounded geometric face. Current
  default, on brand-continuity grounds rather than because it is the best
  typography of the four.
- **`modern` (Outfit / Source Serif 4)** — competent and neutral; the one
  that would raise no objections and excite nobody.

All four are open-licence (SIL OFL) and vendored in `fonts/`, so builds
don't depend on what happens to be installed on a given machine.
