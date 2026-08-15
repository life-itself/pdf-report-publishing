#!/usr/bin/env python3
"""Recover definition lists typed as `» **Term**` + description.

Chapter 11 lists six principles for the next paradigm. In the Google Docs
export each is a guillemet, a bold term, a line break, and a description —
a definition list typed by hand rather than styled as one. Markdown sees a
bold run inside an ordinary paragraph, so they rendered as six
undifferentiated bold-then-text lumps with the stray `»` still visible.

Unlike the bold section labels elsewhere in the document (which are
genuinely ambiguous — see README "Known gaps"), this pattern is
unmistakable: a line starting with `»` followed by a bold term is never
anything else. So it's safe to convert without asking.
"""
import re
import sys

TERM_RE = re.compile(r"^\s*[»>]\s*\*\*\s*(.+?)\s*\*\*\s*:?\s*$")


def typst_content(s):
    return re.sub(r"([#\[\]@$\\*_`<>])", r"\\\1", s)


def transform(text):
    lines = text.split("\n")
    out = []
    i = 0
    n = len(lines)
    while i < n:
        m = TERM_RE.match(lines[i])
        if not m:
            out.append(lines[i])
            i += 1
            continue

        term = m.group(1)
        # The description is the following non-blank line(s) up to the next
        # term or a blank-line paragraph break.
        desc = []
        j = i + 1
        while j < n and lines[j].strip() and not TERM_RE.match(lines[j]):
            desc.append(lines[j].strip())
            j += 1

        if not desc:
            # A term with no gloss isn't a definition item; leave it be.
            out.append(lines[i])
            i += 1
            continue

        if out and out[-1].strip():
            out.append("")
        out.append(
            "```{=typst}\n#dfn([%s], [%s])\n```"
            % (typst_content(term), typst_content(" ".join(desc)))
        )
        out.append("")
        i = j

    return re.sub(r"\n{3,}", "\n\n", "\n".join(out))


if __name__ == "__main__":
    src, dst = sys.argv[1], sys.argv[2]
    with open(src, encoding="utf-8") as f:
        content = f.read()
    with open(dst, "w", encoding="utf-8") as f:
        f.write(transform(content))
    print(f"Definitions {src} -> {dst}")
