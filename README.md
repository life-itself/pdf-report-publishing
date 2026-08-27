# PDF report publishing

Turning Markdown — usually a Google Docs export — into a PDF that reads as
typeset rather than word-processed. Three template styles, specified and
implemented, plus the pipeline that feeds them.

Tracked in [life-itself/community#1269](https://github.com/life-itself/community/issues/1269).

---

## 👀 Waiting on you

**[Issue #3](https://github.com/life-itself/pdf-report-publishing/issues/3)
— review the three styles and the essay build.** Two verdicts needed:
which palette is wrong, and does the 2R essay ship in the Essay style.

Open these:

| | |
|---|---|
| [**style-comparison.pdf**](output/style-comparison.pdf) | The same page in all three styles, 6pp. **Start here.** |
| [style-review.pdf](output/style-review.pdf) | Review — evidence reports |
| [style-essay.pdf](output/style-essay.pdf) | Essay — long-form argument |
| [style-brief.pdf](output/style-brief.pdf) | Brief — policy briefs |
| [what-is-2r.pdf](output/what-is-2r.pdf) | The 2R essay, 41pp, in the Essay style |

Everything else that needs a human is in
[NEXT.md](NEXT.md) and the
[issue list](https://github.com/life-itself/pdf-report-publishing/issues).

---

## The three styles

| Style | Use it for | Character |
|---|---|---|
| **Review** | Evidence reports, research reviews | Serif body pushed right off a working left rail carrying sources; mono apparatus; justified |
| **Essay** | Long-form argument, essays, book chapters | Display serif over reading serif on warm paper; standfirsts, pull quotes, drop caps |
| **Brief** | Position papers, policy briefs | Two sans faces, short measure, key-message boxes, mono colophon |

Each is specified in Markdown first and implemented in Typst second, with
an example PDF apiece so the specs are checkable rather than asserted.

## Build

```sh
typst/build.sh              # the 2R essay      -> output/what-is-2r.pdf
typst/build-examples.sh     # the four style artefacts
```

Needs `typst` and `pandoc` on PATH. Fonts are vendored, so a build produces
the same PDF on any machine.

## Documentation

| | |
|---|---|
| [docs/report-design-principles.md](docs/report-design-principles.md) | **Read this first.** Ten principles extracted from three well-typeset published reports, each cited to a page you can open |
| [docs/styles/](docs/styles/) | The three specifications — grid, type, palette, furniture, and what would break each |
| [docs/pipeline.md](docs/pipeline.md) | How Markdown becomes a PDF, and what each recovery pass fixes |
| [docs/decisions.md](docs/decisions.md) | Why it is built this way — Typst over LaTeX, three styles not one, and the rest |
| [docs/typst-cookbook.md](docs/typst-cookbook.md) | Typst technique: leading, rails, drop caps, footnotes, counters |
| [NEXT.md](NEXT.md) | What happens next, and who owns it |
| [changelog.md](changelog.md) | What happened, dated |

## Sample document

[`life-itself/2rbook`](https://github.com/life-itself/2rbook)'s
"What is the Second Renaissance?" essay — ~8,900 words, 12 sections plus an
appendix. Chosen because it is short-ish, representative, and usefully
messy: a real Google Docs export, complete with escaped punctuation, a
manual hyperlinked TOC and stray empty page-break headings. Exactly the
input the real pipeline has to handle.
