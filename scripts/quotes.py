#!/usr/bin/env python3
"""Recover block quotations from a Google Docs export's italic paragraphs.

Google Docs has a block-quote style, but authors mostly don't use it. In
this essay every quotation was typed as an ordinary paragraph wrapped in
italics, with the attribution on a line of its own — so Markdown sees
emphasis, not a quotation, and the template renders several hundred words
of body-sized italic. Combined with a `show emph` rule that tints italics,
that produced the single worst-looking passage in the v2 output: a full
page of rose italic.

This pass recognises the three shapes the author actually used and turns
them into `#blockquote(...)` calls:

    **Speaker:**                *"...quote..."*             *"...quote..."*
                                - *Attribution*             *- Attribution*
    *"...quote..."*

Deliberately conservative: a paragraph only counts as a quotation if it is
wrapped in emphasis *and* opens with a quotation mark *and* is long enough
to be a real quotation. Bold section labels and the `Modern -> ... ` triads
elsewhere in the document are intentionally left alone — guessing wrong
about those would do more damage than leaving them as they are.
"""
import re
import sys

# A whole paragraph in italics that opens with a quotation mark.
QUOTE_RE = re.compile(r'^\s*\*\s*([“"].{80,}?)\s*\*\s*$')
# `**Sylvie:**` — a speaker label on its own line.
SPEAKER_RE = re.compile(r"^\s*\*\*\s*([^*:]{1,40})\s*:\s*\*\*\s*$")
# `- *David Foster Wallace*` / `*- Foo*` / `*― Iain McGilchrist, ...*`
ATTRIB_RE = re.compile(r"^\s*(?:[-–—―]\s*)?\*\s*[-–—―]?\s*(.{2,200}?)\s*\*\s*$")

DASHES = "-–—―"


def typst_content(s):
    """Escape Markdown-ish text for a Typst `[...]` content block."""
    return re.sub(r"([#\[\]@$\\*_`<>])", r"\\\1", s)


def render(quote, attribution):
    args = ["[" + typst_content(quote) + "]"]
    if attribution:
        args.append("attribution: [" + typst_content(attribution) + "]")
    return "```{=typst}\n#blockquote(" + ", ".join(args) + ")\n```"


def nonblank(lines, i):
    """Index of the next non-blank line at or after i, or None."""
    while i < len(lines):
        if lines[i].strip():
            return i
        i += 1
    return None


def transform(text):
    lines = text.split("\n")
    out = []
    i = 0
    n = len(lines)
    while i < n:
        speaker = None
        start = i

        # A speaker label only counts if a quotation actually follows it.
        m = SPEAKER_RE.match(lines[i])
        if m:
            j = nonblank(lines, i + 1)
            if j is not None and QUOTE_RE.match(lines[j]):
                speaker = m.group(1).strip()
                i = j

        qm = QUOTE_RE.match(lines[i]) if i < n else None
        if not qm:
            out.append(lines[start])
            i = start + 1
            continue

        quote = qm.group(1).strip()
        i += 1

        attribution = speaker
        if attribution is None:
            j = nonblank(lines, i)
            # An attribution must be short, and must be marked as one —
            # either by a leading dash or by being wholly italic. Body
            # paragraphs that merely happen to follow a quote are not.
            if j is not None and j - i <= 1:
                cand = lines[j].strip()
                looks_marked = cand[0] in DASHES or cand.startswith("*" + "".join(DASHES)[0])
                am = ATTRIB_RE.match(cand)
                if am and len(cand) < 220 and (looks_marked or cand.startswith("*")):
                    attribution = am.group(1).strip().lstrip(DASHES).strip()
                    i = j + 1

        if out and out[-1].strip():
            out.append("")
        out.append(render(quote, attribution))
        out.append("")

    return re.sub(r"\n{3,}", "\n\n", "\n".join(out))


if __name__ == "__main__":
    src, dst = sys.argv[1], sys.argv[2]
    with open(src, encoding="utf-8") as f:
        content = f.read()
    with open(dst, "w", encoding="utf-8") as f:
        f.write(transform(content))
    print(f"Quotes {src} -> {dst}")
