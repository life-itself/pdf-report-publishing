---
updated: 2026-08-16
---

# Next

State: template **v3**. The typesetting pass asked for on 2026-08-15 is
done — research first (`docs/typography-research.md`), then serif body,
working margin column, real figures, real block quotations, justified and
hyphenated text. `output/what-is-2r-typst.pdf` is the current build;
`output/type-specimen.pdf` shows the four type presets on the same page of
real content.

## The one thing that needs Rufus

**Pick a type preset.** Open `output/type-specimen.pdf` — four pages, same
content, one preset each. Then `typst/build.sh <preset>`.

- `warm` (Baloo 2 / Spectral) — current default. Closest to the existing
  brand: Baloo 2 is the open-licence stand-in for the reference PDF's
  rounded geometric heading face. Chosen as default for brand continuity,
  not because it's the best typography of the four — ALL-CAPS in a rounded
  extrabold is the loudest option and somewhat fights the restraint that
  makes the exemplar reports feel expensive.
- `editorial` (Work Sans / Literata) — closest to CRI's *Reality Check*.
  Literata is built for long-form reading and holds up best over 30 pages.
  **My recommendation if the report is meant to be read.**
- `display` (Fraunces / Source Serif 4) — the most beautiful and most
  magazine-like. Best if the report is meant to be shown.
- `modern` (Outfit / Source Serif 4) — neutral and competent; would raise
  no objections and excite nobody.

This is the gate on everything below: the skill-packaging question in
particular isn't worth doing until the design is settled.

## Then, in rough order

1. **Editorial devices that need editorial judgement.** `pullquote()`,
   `standfirst()` and `note()` are built and styled but unused, because
   using them means deciding *which* sentences to lift out — a content
   call, not a template one. The obvious candidates: the `**Claim: …**`
   paragraphs that open several chapters are natural standfirsts, and each
   chapter could carry one pull quote. Worth 30 minutes with Rufus or
   Rosie picking them, after which the template renders them for free.
   This is probably the largest remaining *visual* gain — the exemplars'
   pages breathe mainly because something interrupts the prose every few
   pages, and ours still don't.
2. **Remaining Google Docs conventions.** Bold-line section labels,
   the `» **Term**` definition items in chapter 11, and the
   `Modern → / Postmodern → / Metamodern →` triads all still render as
   ordinary bold paragraphs. See README "Known gaps" for why the
   heuristics were left out rather than guessed at. The honest fix is
   probably a short interactive pass — show the candidates, let a human
   confirm the classification once, record the answers — rather than a
   cleverer regex.
3. **Package as a skill.** Rufus's steer was
   [zarazhangrui/frontend-slides](https://github.com/zarazhangrui/frontend-slides)
   as the *shape*: `SKILL.md` as workflow map, supporting reference files
   loaded on demand, repeatable output quality. He was explicit that we
   want **one strong template**, not a gallery — so the "generate previews,
   let the user pick" step is the type-preset choice above, and it happens
   once, not per report. The pieces are now separable enough for this:
   `scripts/` (recover structure from the export), `typst/theme.typ`
   (design system), `typst/report.typ` (layout engine), `typst/build.sh`
   (workflow).
4. **Smaller known items** (full list in README "Known gaps"):
   copyright/licence line is still placeholder text and needs a real
   decision; footnotes/bibliography confirmed possible in Typst but not
   wired into the template; no Google Docs → Markdown conversion step
   exercised yet (this source was already Markdown); print-on-demand trim
   size not addressed; the cover is bespoke rather than templated.

## Reference material

- `docs/typography-research.md` — the exemplar research and what it
  implied. Read this before changing the design again.
- `output/type-specimen.pdf` — the four presets, same content.
- `output/what-is-2r-typst.pdf` — current build.
- `reference/designer-what-is-2r.pdf` — the original target. Note that v3
  deliberately departs from it on body type; it is no longer the thing to
  match.
- `CHANGELOG.md` — what happened, dated.
