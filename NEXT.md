---
updated: 2026-08-15
---

# Next

State: working Typst pipeline exists, matches the reference PDF structurally (cover,
colours, margins, headings, footer, page breaks) — but Rufus's read after seeing it is
that it's "OK", not there yet: not well typeset, doesn't look professional/high-class,
image layout and captions are rough on some pages. The next session should be about
**quality of typesetting**, not pipeline plumbing — the plumbing works.

## What Rufus specifically asked for (2026-08-15 session)

Reflecting back what was asked, not paraphrased into something smaller:

1. **The current style isn't right.** Not a small tweak — a real pass on making it
   "quite a lot more beautiful," "really beautiful and really high class." Possibly
   font changes, but not only that — the overall typeset feel is off.
2. **Do some research first.** Find genuinely good exemplars — well-typeset reports/
   whitepapers/books worth imitating — before pushing further on this specific design.
   Don't just keep iterating blind on one direction.
3. **Fix image layout and captions.** Some pages look unprofessional specifically
   because of how images are placed and captioned, separate from the type/colour
   question.
4. **Consider turning this into a proper reusable skill**, not a one-off template.
   Rufus pointed at [zarazhangrui/frontend-slides](https://github.com/zarazhangrui/frontend-slides)
   as a reference shape — an Agent Skill for generating polished HTML slide decks:
   `SKILL.md` as the entry point/workflow map, supporting reference files
   (style presets, templates, patterns) loaded on demand rather than all at once,
   and a "generate style previews, let the user pick, then commit" workflow rather
   than one-shot generation. He was explicit that our case differs — we most likely
   want **one strong template**, not a gallery of style choices — but the *shape*
   of a skill (workflow map + on-demand reference material + repeatable output
   quality) is the useful part to borrow.
5. **Explicitly deferred**: he asked for this to be written down for next time, not
   started now.

## Proposed next session

1. **Exemplar research first.** Before touching the template again, gather 4-6
   genuinely well-typeset references — could be other whitepapers/reports Rufus
   already admires, design-focused publishers (e.g. the kind of thing on
   Are.na — there's already a board linked from the project doc:
   https://www.are.na/rufus-pollock/report-inspirations-for-life-itself),
   or general editorial/book typesetting known for quality. Look at what
   specifically makes them read as "high class": type pairing, scale/rhythm,
   margins, how images and captions are integrated, use of colour/restraint.
2. **Revisit fonts properly.** Current build falls back to Liberation Sans for
   everything (system font, no net access in that sandbox session) — both body
   and the reference's rounded-geometric heading face. Get real candidate fonts
   in front of Rufus rather than guessing — a few pairings rendered side by side
   on the same page of real content, not swatches.
3. **Fix image handling**: consistent sizing/placement rules, proper caption
   styling (currently the essay's images just float in with no caption treatment
   at all), sensible rules for wide vs. narrow images, multi-image rows (the
   Cimabue/Perugino/Picasso trio in `what-is-2r` is a good stress test — three
   related images that should probably sit as a row or sequence, not three
   separate full-width blocks).
4. **Then decide on the skill question**: once there's a template Rufus actually
   likes, consider packaging the workflow as a skill (`skills/pdf-report/SKILL.md`
   or similar, following the shape above) — clean-markdown step, template,
   build script, documented as a repeatable process rather than a one-off
   experiment. Not worth doing before the design itself is settled.
5. **Smaller known items** (see `README.md` "Known gaps" for full list):
   copyright/licence line is still placeholder text and needs an actual decision;
   footnotes/bibliography confirmed possible in Typst but not wired into the
   template; no Google Docs → Markdown conversion step has been exercised yet
   (source was already Markdown); print-on-demand trim size not addressed.

## Reference material

- `reference/designer-what-is-2r.pdf` — the one target used so far (single
  data point, not a research base).
- `output/what-is-2r-typst.pdf` — current state, for comparison once new
  exemplars are gathered.
- `CHANGELOG.md` — what happened in the 2026-08-15 session.
