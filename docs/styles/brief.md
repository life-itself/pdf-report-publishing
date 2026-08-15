---
style: brief
updated: 2026-08-16
derived-from: PCI *Planetary Futures* + MI boxes — see docs/report-design-principles.md
---

# Style: Brief

> Direct, sans-forward, skimmable. A short measure hard left, a worked
> right rail for key figures and labels, boxed key messages, footnotes on
> every page and a colophon that identifies any single sheet. For position
> papers, policy briefs and submissions — documents a reader will act on
> and probably won't read end to end.

**Character in one sentence:** it should look like a document of record,
not a brochure — and it should survive being printed, stapled and passed
around one page at a time.

## 1. Page grid

A4, 210 × 297 mm.

```
  0     20mm                     138mm  146mm        190mm  210mm
  |      |                         |     |             |      |
  | edge |      TEXT COLUMN        | gut |  SIDE RAIL  | edge |
  |      |         118mm           | 8mm |     44mm    | 20mm |
```

| Region | From | Width | Contents |
|---|---|---|---|
| Text | 20mm | 118mm | Body, headings, boxes, figures |
| Gutter | 138mm | 8mm | Empty, always |
| Side rail | 146mm | 44mm | Section labels, key figures, marginal definitions, pull statistics |

Vertical: top margin **22mm**, bottom margin **34mm**. The bottom margin
is deep because it holds two things: the footnote block and the colophon.

Measure at the specified body size is **≈62 characters** — the short end
of the range, which is what makes the style skimmable. A reader's eye
returns quickly.

**Key structural difference from Review:** the rail is on the **right**,
after the text, not before it. Review's left rail annotates as you read;
Brief's right rail summarises what you have just read. Boxes and figures
are allowed to span text + gutter + rail (170mm) — that full-width span is
the style's strongest visual event, and it should be rare.

## 2. Type

| Voice | Family | Where |
|---|---|---|
| Display | **Outfit** | Headings, box titles, key figures |
| Body | **Work Sans** | Running prose, lists, captions, rail |
| Apparatus | **DM Mono** | Colophon, footnote numbers, data labels |

Two sans faces, chosen because they are genuinely different species —
Outfit is geometric (circular bowls, single-storey `a` at display sizes),
Work Sans is a grotesque built for text. That is a real contrast, not the
muddle you get from pairing two neighbours. There is **no serif in this
style at all**; the register is contemporary and institutional.

| Element | Family | Size | Weight | Leading | Notes |
|---|---|---|---|---|---|
| Document title | Outfit | 30pt | 600 | 1.1× | Cover only |
| Section head | Outfit | 17pt | 500 | 1.2× | Outline letter/number set in 400 `muted` before it, per MI's de-emphasised numbering |
| Sub-section head | Outfit | 11.5pt | 500 | 1.25× | `accent` |
| Run-in head | Work Sans | 10pt | 700 | — | Ends with a period; body continues on the same line |
| Body | Work Sans | 10pt | 400 | 1.5× | **Ragged right**, hyphenation off |
| Lead-in sentence | Work Sans | 10pt | 700 | 1.5× | First sentence of a paragraph in bold, carrying the paragraph's claim |
| Assertion line | Outfit | 13pt | 400 | 1.35× | A standalone claim between paragraphs; no quote marks, no rule |
| List item | Work Sans | 10pt | 400 | 1.5× | Circled numerals for ordered, en-dash for unordered |
| Block quotation | Work Sans | 9.4pt | 400 | 1.45× | Indented 10mm left, `muted-ink` |
| Box label | Work Sans | 7.5pt | 600 | — | Uppercase, tracked +0.16em |
| Box title | Outfit | 15pt | 400 | 1.2× | |
| Box body | Work Sans | 9.4pt | 400 | 1.5× | |
| Key figure | Outfit | 26pt | 600 | 1.0× | Rail only; `highlight` |
| Key figure label | Work Sans | 7.5pt | 400 | 1.35× | Rail, under the figure, `muted` |
| Rail label | Work Sans | 8pt | 600 | 1.35× | `muted`, ranged left |
| Figure caption | Work Sans | 8pt | 400 | 1.35× | `muted` |
| Footnote | Work Sans | 7pt | 400 | 1.35× | Number in DM Mono 6.5pt superior; URLs allowed to break anywhere |
| Colophon | DM Mono | 7pt | 400 | 1.4× | Key/value, key column 16mm |

Paragraphs separated by **1.4em** (Typst's `par.spacing`, the gap between
paragraph blocks), never indented. A sans at a short measure needs a
clearly visible paragraph break, because there is no indent doing the job.

## 3. Colour

Six values. This is the most colourful of the three styles and it is still
disciplined: colour is either structure or emphasis, and emphasis appears
at most twice per page.

| Token | Hex | Job |
|---|---|---|
| `page` | `#F6F6F4` | Cool off-white paper |
| `ink` | `#16191C` | Body text |
| `muted-ink` | `#454B50` | Block quotations, box body on tint |
| `muted` | `#6E767C` | Furniture, captions, rail labels, colophon |
| `accent` | `#12464F` | Sub-heads, box ground, rules — the structural colour |
| `tint` | `#E4EDEE` | Panel fill (a 10% wash of `accent`) |
| `highlight` | `#C1701A` | Key figures and live links **only** |
| `rule` | `#D5D8D6` | Hairlines |

On `accent` ground, text reverses to `page`. `highlight` never touches
body text; if a number matters enough to be `highlight`, it belongs in the
rail as a key figure.

## 4. Page furniture

- **Colophon**, bottom-left, below the footnote block, in DM Mono 7pt
  `muted` — a key/value block:

  ```
  Page:    8
  Title:   A New Framework for Planetary Futures
  Date:    2026-08-16
  Authors: …
  ```

  The wordmark sits to its left if there is one. This makes any single
  sheet self-identifying, which is the whole point of the style.

- **Section label**, top of the right rail, ranged left, Work Sans 8pt/600
  `muted`: the current section's name. Updates per section.
- **Rule**, a 118mm `rule` hairline under the top margin across the text
  column only — the one horizontal line on an ordinary page.
- No centred header, no separate folio: the page number lives in the
  colophon. That is deliberate and it is what makes the footer read as a
  record rather than as decoration.

## 5. Structural elements

**Key-message box** — the signature interruption. A solid `accent` panel
spanning the full 170mm, with 8mm internal padding, containing: a label
line (`KEY MESSAGE 3`, or `BOX 3: EVIDENCE`) in uppercase tracked Work
Sans 7.5pt/600 at 70% opacity; a title in Outfit 15pt; then body in Work
Sans 9.4pt — all reversed to `page`. A 0.8pt `accent` outline offset 2mm
down and right sits behind the panel, giving depth without a shadow (MI's
trick, and it survives greyscale printing). 1.6em of space above and
below.

**Tinted panel.** The quiet variant: `tint` fill, `ink` text, no offset
outline, same padding and geometry. For summaries and definitions where a
solid panel would be too loud. A page may carry one solid box *or* two
tinted panels, never both.

**Key figure.** In the right rail: a number in Outfit 26pt `highlight`,
with a label beneath in Work Sans 7.5pt `muted`, aligned to the top of the
paragraph that supports it. Maximum two per page. Every key figure must be
a number that also appears in the body text — the rail restates, it does
not introduce.

**Assertion line.** A single claim on its own between two paragraphs, in
Outfit 13pt, ranged left, 1.2em space either side, no quote marks and no
rule. PCI's device (p.38). Cheaper than a pull quote and it does not
interrupt the argument's flow.

**Outline headings.** Sections carry a letter or number in Outfit 17pt/400
`muted` set before the title, which is 17pt/500 `ink`. Numbers locate;
they do not shout.

**Figure.** Image on a `tint` panel with 6mm padding, at text-column width
or spanning the full 170mm. Caption below the panel in Work Sans 8pt
`muted`, beginning `Figure 6.` in weight 600. A source is a footnote
marker on the caption, resolved in the page's footnote block — this style
sends everything checkable to the footnotes.

**Footnotes.** At the foot of the text column, above a 40mm `rule`
hairline, Work Sans 7pt, hanging numbers in DM Mono. URLs set to break at
any character; they will be long and that is fine. Footnotes, never
endnotes — a brief is read in fragments, and an endnote in a fragment is
useless.

## 6. Setting

- **Ragged right, hyphenation off.** At 62 characters in a sans, that is
  the correct setting (principle 7), and the ragged edge here is a
  deliberate match to PCI and MI.
- Optical rag: no line shorter than 55% of measure, achieved by allowing
  a slightly loose word-space tolerance rather than by manual breaks.
- Widow/orphan minimum two lines; boxes never break across pages.
- Sections do not force a page break — a brief should be dense.

## 7. What would break this style

- Adding a serif. Anywhere. The style's coherence is that it is entirely
  sans; one serif pull quote would read as a mistake.
- Using `highlight` for anything but key figures and links. It is the
  loudest thing on the page and it only works because it is rationed.
- Justifying the body. At this measure in a sans it produces visible
  rivers within three lines.
- Boxes on every page. The box is an interruption; if everything is
  interrupted, nothing is.
- Putting the page number anywhere but the colophon. The colophon *is*
  the folio here, and splitting them halves the effect of both.
