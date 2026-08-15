---
updated: 2026-08-16
---

# Next

State: **three template styles, specified and implemented**, with one
example PDF each built from real content, plus a working style comparison.
The sequencing agreed on 2026-08-16 is done end to end.

## What exists now

| Artefact | What it is |
|---|---|
| `docs/report-design-principles.md` | Ten principles extracted from the three exemplar reports, each cited to a page you can open. **This is the deliverable.** |
| `docs/styles/review.md` `essay.md` `brief.md` | Three full specifications — grid, type scale, palette, furniture, elements, setting, and what would break each |
| `docs/typst-cookbook.md` | Technique that holds whichever style is in use |
| `typst/lib/styles/*.typ` | Each spec implemented |
| `output/style-review.pdf` `style-essay.pdf` `style-brief.pdf` | One example per style, from real content |
| `output/style-comparison.pdf` | Same content, all three styles, real furniture on every page |
| `output/what-is-2r.pdf` | **The full 2R essay, 41pp, set in the Essay style** — `typst/build.sh` |
| `skills/pdf-report/SKILL.md` | The wrapper: choose, read, build, edit |

Rebuild everything with `typst/build-examples.sh`.

## The next decisions are Rufus's, not the template's

1. **Look at the three PDFs and say which is wrong.** Colour and type were
   my judgement per the brief; they are cheap to change and expensive to
   argue about in the abstract. Specifically worth a verdict:
   - Review's teal accent (`#2A6E7A`) on white.
   - Essay's vermilion (`#B4472A`) on warm paper `#FCFAF6` — this is the
     "warm and serious" one, and Fraunces is the Restora stand-in.
   - Brief's petrol (`#12464F`) with amber (`#C1701A`) for key figures.
2. **Sign off the essay build.** `output/what-is-2r.pdf` is the whole
   essay in the Essay style. Two known gaps in it, both listed below: the
   editorial devices are unused, and two Google Docs conventions still
   render as ordinary bold paragraphs.
3. **The editorial pass.** The largest remaining *visual* gain, and the
   one no template work can substitute for. There is currently **no way to
   mark it in the Markdown** — that convention needs deciding before the
   work can be done. Measured on this document: only 2 of 16 chapters have
   a syntactically detectable standfirst, and there is no signal at all for
   pull quotes, so this cannot be inferred from the source. See
   `skills/pdf-report/SKILL.md` step 5 for what the choices are.

## Then, in rough order

1. **Retire the v3 engine.** `typst/main.typ`, `typst/report.typ` and
   `typst/theme.typ` still build `output/what-is-2r-typst.pdf` via
   `./build.sh v3`. Delete them once the Essay build is signed off.
2. **Remaining Google Docs conventions.** Bold-line section labels and the
   `Modern → / Postmodern → / Metamodern →` triads still render as
   ordinary bold paragraphs. See README "Known gaps" for why the remaining
   heuristics were left out rather than guessed at. The honest fix is a
   short interactive pass — show the candidates, let a human confirm the
   classification once, record the answers — not a cleverer regex.
3. **Smaller known items.** The copyright/licence line is still
   placeholder text and needs a real decision. Bibliography is confirmed
   possible in Typst but not wired into any style. Print-on-demand trim
   size, bleed and binding gutter are not addressed; all three styles are
   specified for A4. Covers remain bespoke artwork rather than templated,
   which is probably right but is not written down as a decision anywhere.

## Reference material

- `docs/report-design-principles.md` — read this before changing any
  design decision.
- `docs/styles/README.md` — how to choose between the three.
- `docs/typography-research.md` — the earlier, narrower pass (fonts).
  Superseded in scope but still accurate, with one correction marked.
- `reference/exemplars/` — the three source PDFs.
- `reference/designer-what-is-2r.pdf` — the original target. No longer the
  thing to match; the styles depart from it deliberately.
- `CHANGELOG.md` — what happened, dated.
