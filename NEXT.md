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
| `scripts/editorial.py` + `source/what-is-2r.editorial.txt` | Standfirst / pull-quote marks, and the proposals awaiting a human decision |
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
3. **The editorial pass — [#1](https://github.com/life-itself/pdf-report-publishing/issues/1).**
   The largest remaining *visual* gain, and the one no template work can
   substitute for. The mechanism is shipped: marks live in
   `source/what-is-2r.editorial.txt` and are applied by
   `scripts/editorial.py`. **Proposals for every chapter are already in
   that file, commented out** — accepting one is deleting a `#| `. Two
   marks are live already, because they are the authors' own bolded claims
   rather than a judgement call. About five minutes a chapter.

## Then, in rough order

1. **Retire the v3 engine.** `typst/main.typ`, `typst/report.typ` and
   `typst/theme.typ` still build `output/what-is-2r-typst.pdf` via
   `./build.sh v3`. Delete them once the Essay build is signed off.
2. **Remaining Google Docs conventions — [#2](https://github.com/life-itself/pdf-report-publishing/issues/2).**
   Bold-line section labels and the `Modern → / Postmodern → / Metamodern →`
   triads still render as ordinary bold paragraphs (visible on p.20 and
   p.30 of `output/what-is-2r.pdf`). The fix is the same sidecar-plus-
   verification shape as #1, not a cleverer regex — the heuristics that
   catch these also catch speaker labels and standfirsts.
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
