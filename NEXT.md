---
updated: 2026-08-21
---

# Next

State: **three template styles, specified and implemented**, plus the full
2R essay building through the Essay style. The build side has run out of
things it can decide for itself — most of what is left needs a verdict.

---

## Start here

**If you have 30 minutes** → do the editorial pass, [#1](https://github.com/life-itself/pdf-report-publishing/issues/1).
It is the biggest remaining visual gain and the only one nobody else can
do. Exact steps in "Yours" below.

**If you want work to continue without you** → say "take #2" and Claude
picks up [#2](https://github.com/life-itself/pdf-report-publishing/issues/2),
which needs no input from you.

**If you only want to look at something** → open
`output/style-comparison.pdf` and say which of the three palettes is
wrong. Everything in "Blocked" unblocks from that.

---

## Yours — nobody else can do these

### 1. The editorial pass ([#1](https://github.com/life-itself/pdf-report-publishing/issues/1))

The essay is 41 pages with no interruptions in it at all: no standfirsts,
no pull quotes. That is why it still reads as a grey slab in places. Which
sentence gets lifted is an editorial judgement — measured on this document,
only 2 of 16 chapters have a detectable standfirst and there is no signal
at all for pull quotes.

The mechanism is done. All that is left is deciding.

```sh
# 1. Open the marks file. Every chapter has a proposed standfirst and
#    one or two proposed pull quotes, parked as "#|" lines.
$EDITOR source/what-is-2r.editorial.txt

#    Accept a proposal: delete the "#| " at the start of the line.
#    Reject it:         delete the line.
#    Write your own:    replace the text, keeping the key.

# 2. Rebuild and look.
typst/build.sh
```

All 29 proposals are verified to resolve against the source, so anything
you uncomment will build. A mark that stops matching fails the build and
names the chapter.

Editable straight in GitHub if that is easier than a checkout. Worth doing
with Rosie. About five minutes a chapter.

### 2. Three palette verdicts

Cheap to change, expensive to argue about in the abstract. Open the PDFs
and say which is wrong:

| Style | Accent | Where to look |
|---|---|---|
| Review | teal `#2A6E7A` on white | `output/style-review.pdf` |
| Essay | vermilion `#B4472A` on warm `#FCFAF6` | `output/style-essay.pdf` — the "warm and serious" one; Fraunces is the Restora stand-in |
| Brief | petrol `#12464F` + amber `#C1701A` | `output/style-brief.pdf` |

`output/style-comparison.pdf` has all three against the same content.

### 3. Sign off the essay build

`output/what-is-2r.pdf`, 41pp. Two known gaps in it, both tracked: no
editorial devices (#1), and two Google Docs conventions still rendering as
ordinary bold paragraphs (#2, visible on p.20 and p.30).

Signing off unblocks deleting the v3 engine.

---

## Mine — no input needed, just say go

### 4. Google Docs conventions ([#2](https://github.com/life-itself/pdf-report-publishing/issues/2))

Bold-line section labels and the `Modern → / Postmodern → / Metamodern →`
triads. The last thing making p.20 and p.30 look untended. Same
sidecar-plus-verification shape as #1, not a cleverer regex — the
heuristics that catch these also catch speaker labels and standfirsts.
Roughly a day.

---

## Blocked on a decision above

- **Retire the v3 engine** — needs #3. `typst/main.typ`, `typst/report.typ`
  and `typst/theme.typ` still build `output/what-is-2r-typst.pdf` via
  `./build.sh v3`. Delete once the Essay build is signed off.
- **Apply palette changes** — needs #2. Each style's palette is a single
  dict at the top of `typst/lib/styles/<style>.typ`, written so it can be
  swapped without touching layout.

---

## Long tail — no owner yet

- The copyright/licence line is still placeholder text and needs a real
  decision (All Rights Reserved? CC BY-SA?).
- Bibliography is confirmed possible in Typst but not wired into any style.
- Print-on-demand trim size, bleed and binding gutter are not addressed;
  all three styles are specified for A4.
- Covers remain bespoke artwork rather than templated, which is probably
  right but is not written down as a decision anywhere.

---

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

```sh
typst/build.sh              # the essay -> output/what-is-2r.pdf
typst/build-examples.sh     # the four style artefacts
```

## Reference material

- `docs/report-design-principles.md` — read this before changing any
  design decision.
- `docs/styles/README.md` — how to choose between the three.
- `docs/typography-research.md` — the earlier, narrower pass (fonts).
  Superseded in scope but still accurate, with one correction marked.
- `reference/exemplars/` — the three source PDFs.
- `reference/designer-what-is-2r.pdf` — the original target. No longer the
  thing to match; the styles depart from it deliberately.
- `changelog.md` — what happened, dated.
