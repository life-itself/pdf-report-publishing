---
updated: 2026-08-27
---

# Next

State: **three template styles, specified and implemented**, plus the full
2R essay building through the Essay style. The build side has run out of
things it can decide for itself — most of what is left needs a verdict.

---

## Start here

**Everything waiting on a human is now in
[issues](https://github.com/life-itself/pdf-report-publishing/issues).**
This file is the map; the issues are the work.

| | |
|---|---|
| [#3](https://github.com/life-itself/pdf-report-publishing/issues/3) | **Review the three styles and the essay build** — two verdicts, and the PDFs to look at are linked from the issue |
| [#1](https://github.com/life-itself/pdf-report-publishing/issues/1) | The editorial pass — 30 minutes, and nobody else can do it |
| [#2](https://github.com/life-itself/pdf-report-publishing/issues/2) | Google Docs conventions — Claude can just take this, no input needed |
| [#4](https://github.com/life-itself/pdf-report-publishing/issues/4) | The copyright / licence line |
| [#5](https://github.com/life-itself/pdf-report-publishing/issues/5) | Inbox — smaller gaps, not yet actionable |

**If you have 30 minutes** → [#1](https://github.com/life-itself/pdf-report-publishing/issues/1),
the editorial pass. Biggest remaining visual gain and the only one nobody
else can do. Exact steps below.

**If you only want to look at something** →
[#3](https://github.com/life-itself/pdf-report-publishing/issues/3), or
straight to `output/style-comparison.pdf`.

**If you want work to continue without you** → say "take #2".

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

### 2. Review and sign off ([#3](https://github.com/life-itself/pdf-report-publishing/issues/3))

Two verdicts: which of the three palettes is wrong, and does the 2R essay
ship in the Essay style. The PDFs to look at are linked from the issue.
Signing off the essay unblocks deleting the superseded v3 engine.

---

## Mine — no input needed, just say go

### Google Docs conventions ([#2](https://github.com/life-itself/pdf-report-publishing/issues/2))

Bold-line section labels and the `Modern → / Postmodern → / Metamodern →`
triads. The last thing making p.20 and p.30 of the essay look untended.
Same sidecar-plus-verification shape as #1, not a cleverer regex — the
heuristics that catch these also catch speaker labels and standfirsts.
Roughly a day.

---

## Elsewhere

- **The licence line** —
  [#4](https://github.com/life-itself/pdf-report-publishing/issues/4).
  Placeholder text on the colophon page; a policy decision, not a template
  one.
- **Smaller gaps** —
  [#5](https://github.com/life-itself/pdf-report-publishing/issues/5).
  Bibliography not wired in, no Google Docs → Markdown step exercised,
  print-on-demand untouched, covers not templated, v3 engine still present.

---


## Where things are

`README.md` has the map of the repo and the documentation index. The three
things worth knowing here:

- `docs/report-design-principles.md` is the deliverable — read it before
  changing any design decision.
- `docs/decisions.md` records settled questions. Check it before reopening
  one.
- `output/` holds every built PDF, committed so they are viewable without
  a local toolchain.

```sh
typst/build.sh              # the essay -> output/what-is-2r.pdf
typst/build-examples.sh     # the four style artefacts
```
