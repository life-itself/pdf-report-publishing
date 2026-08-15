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

## Direction agreed 2026-08-16 (supersedes the preset question below)

Rufus reviewed `output/type-specimen.pdf` and reframed the work. The
specimen was the wrong artefact: all four pages varied only the fonts, so
he was being asked to judge a design while one variable moved. Worse, the
specimen overrode the real page footer with its own preset label, so the
page furniture — the thing he most wanted to see — was invisible.

**What he actually wants:** find good exemplars, extract their principles
clearly into documentation, and express those as **two or three template
styles** written as Markdown specs with instructions. Then implement them
and generate example PDFs. A `SKILL.md` is just the wrapper that says
"read these instructions and implement" — the value is in the extracted
principles, not the wrapper.

**Verdicts on v3:**
- Baloo 2 headings are out — "weird rounded font", unprofessional. The
  principle: if it's a sans, use a genuinely good sans; if a serif, a
  genuinely good serif. Don't sit between the two.
- Outfit (specimen p3) is good; Fraunces (p4) possibly better.
- **Restora** is his usual heading face — old-style roman serif by Nasir
  Udin, 2019. He cannot supply the files and licensing is inconsistent
  across the free listings, so **don't pursue it**; Fraunces is the
  open-licence stand-in.
- The brown ink is not liked and was never defended — it was inherited
  from the designer reference. Palette is my judgement now.
- CRI's running header/footer furniture is what gave its pages
  "stylistic substance". We have none of it. Don't slavishly copy CRI.

**Constraints:**
- Reports should be **readable**, and **both warm and serious**.
- Work **independent of Life Itself brand** — he explicitly did not want
  the brand guessed at. Derive the options from the exemplars instead.
- Colour and type are my judgement calls; I don't need to ask again.

**Planned sequencing:**
1. Deepen exemplar extraction — structure and page furniture, not just
   fonts. Sources: the Are.na board PDFs (CRI *Reality Check*, Mindfulness
   Initiative *Reconnection*, PCI *Planetary Futures*) plus good websites.
2. `docs/report-design-principles.md` — template-independent principles.
3. `docs/typst-cookbook.md` — generic Typst technique (page grid, margin
   notes, figures, quotes, footnotes, furniture) that holds regardless of
   which style is chosen.
4. Three template style specs as Markdown, provisionally:
   - **Review** — CRI-like: serif body, sans furniture, margin rail for
     sources and captions, running header, data-heavy. For evidence and
     research reports.
   - **Essay** — literary: display serif headings, generous measure,
     standfirsts and pull quotes. For long-form argument (the 2R essay).
   - **Brief** — sans-forward, tighter, boxed summaries, more colour
     blocking. For position papers and policy briefs.
5. Implement each as a Typst style; generate one example PDF per style.
6. Wrap as `skills/pdf-report/SKILL.md`.

Work in progress at the point this was written: step 1 only — exemplar
pages re-rendered for structural analysis, nothing extracted yet.
`docs/typst-cookbook.md` (step 3) exists as a stub carrying the Typst
findings from this session; it gets filled out as the styles are built.

**Which model to run which step.** Steps 1–4 are judgment work — looking
at exemplar pages and working out *why* they read as professional, then
turning that into principles and three coherent specs. Model quality
compounds there: get the specs wrong and every line of Typst downstream
implements the wrong thing, which is exactly how the first type-specimen
went wrong (mechanically fine, conceptually wrong). **Run 1–4 on Opus, and
end that session at "specs written and committed"** — a clean stopping
point that survives hitting a usage limit.

Step 5 is mechanical once the specs exist: grid maths, show rules, build
scripts, all tightly constrained by the specs. **Run it on Sonnet.** Then
come back to Opus for a final look at the generated PDFs, because judging
them is taste again.

On parallelising step 5: the three styles share one layout engine, so
build that first, sequentially. Only after it is stable are the styles
independent enough to be worth farming out to subagents, and even then the
coordination cost is real for three files — sequential Sonnet is the
default, subagents the optimisation.

## Superseded: the preset question

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
2. **Remaining Google Docs conventions.** Bold-line section labels and the
   `Modern → / Postmodern → / Metamodern →` triads still render as
   ordinary bold paragraphs. (The `» **Term**` definition items were
   unambiguous and are now converted.) See README "Known gaps" for why the
   remaining heuristics were left out rather than guessed at. The honest
   fix is probably a short interactive pass — show the candidates, let a
   human confirm the classification once, record the answers — rather than
   a cleverer regex.
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
