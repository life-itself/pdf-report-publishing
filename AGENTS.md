# AGENTS.md

Conventions for agents working in this repo. The README is for humans and
deliberately short — do not add to it.

## Before changing any design

Read `docs/report-design-principles.md`, then the spec for the style you
are touching in `docs/styles/`. **The spec is the artefact; the Typst is
the proof.** If they disagree, fix whichever is wrong and say which. Do not
improvise a design decision that the specs already settle, and do not
invent a fourth style without writing its spec first.

`docs/decisions.md` records settled questions. Check it before reopening
one.

## Where things go

| Kind of thing | Goes in |
|---|---|
| Design principles, style specs, Typst technique | `docs/` |
| Why something is built this way | `docs/decisions.md` |
| Work to do, known gaps, anything needing a human | a bead (`bd create`); see `bd ready` |
| Decisions about the look of SoR papers | the design repo (`projects/sor-design-system/print.md`), not here |
| What shipped, dated | `changelog.md` |
| Anything a human needs on arrival | `README.md`, kept short |

Do not accumulate known-gaps or status lists in any Markdown file. That is
what beads are for.

## Tracking: Beads

Issue prefix `prp`; no GitHub issues. Start a session with `git pull`,
`bd dolt pull`, `bd ready`. Claim with `bd update ID --claim`, close with
`bd close ID --reason "..."`. `git push` also pushes Beads through the
pre-push hook; `bd dolt push` is the manual fallback. Run
`git config core.hooksPath .beads/hooks` once per clone.

## Building

```sh
typst/build.sh              # the 2R essay
typst/build-examples.sh     # the four style artefacts
typst/build-paper.sh wisdom # an SoR paper, text from ../2rbook/wisdom
```

SoR papers need Polyamine and Restora, which are licensed and never
committed: see `fonts/README.md`.

Always pass `--font-path fonts` to a bare `typst compile`. Typst falls back
silently to system fonts otherwise and the same source will produce
visibly different PDFs on different machines.

Rebuild the affected PDFs and commit the style artefacts and the 2R essay,
so the work is viewable without a local toolchain. SoR paper PDFs are not
committed anywhere: they are published with the paper.

## Check the output

Render pages and look at them; do not trust that it compiled.

```sh
pdftoppm -png -r 80 output/what-is-2r.pdf /tmp/page
```

`skills/pdf-report/SKILL.md` has the checklist of what usually goes wrong.

## Changelog

This repo keeps a `changelog.md` (dated entries, newest first). At the end
of a work session, if something worth recording actually shipped — skip
trivial sessions (typo fixes, dead ends, no visible outcome) — draft a
dated entry. Match the entry's weight to what a reader would actually care
about: a real feature/fix/content gets a title, one or two sentences, and a
screenshot if something visual shipped; small stuff (cleanup, rename,
reorg, tidying) gets one plain sentence, no bullets, no screenshot — even
if several small things happened, that's still one combined sentence, not
a bullet per thing. Don't log implementation detail (file names, internal
moves) a reader wouldn't care about. First time writing an entry in this
repo, or if the format is unclear: fetch and follow
https://raw.githubusercontent.com/life-itself/changelog/main/CONVENTION.md
