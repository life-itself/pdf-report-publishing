#!/usr/bin/env python3
"""Clean a Google-Docs-exported Markdown file for typesetting.

Turns the raw export into Markdown that reflects the *actual* structure of
the source document, not just its literal heading level:

- Lifts the title-block paragraphs (title / subtitle / date / authors) into
  YAML frontmatter, and drops the manual hyperlinked TOC that follows it.
- Reclassifies headings: Google Docs exported every heading as `#`, but the
  document really has two levels — "N. Title" chapters and "N.M Title"
  sub-sections. We demote the `N.M` ones to `##` (keeping their number,
  since the designer reference kept those) and strip the leading number
  from `N.` chapter titles (the designer reference drops those and relies
  on position/caps styling instead).
- Turns "Back-story" (a plain paragraph in the export, not a heading) into
  a proper `##` heading.
- Preserves the author's manual page breaks (Google Docs page breaks export
  as empty `#` lines) as raw Typst `#pagebreak()` blocks instead of
  discarding them — the reference PDF clearly honours these.
- Un-escapes backslash-escaped punctuation (\\. \\- \\[ \\] etc.) and
  normalises `=>` / `\\=\\>` to a plain arrow character.
- Strips heading anchor ids `{#foo}` (not needed once we control the
  template).
"""
import re
import sys

PAGEBREAK = "\n```{=typst}\n#pagebreak()\n```\n"


def clean(text: str) -> str:
    lines = text.split("\n")

    # ---- Title block -> YAML frontmatter, drop the manual TOC -------------
    # Expected shape:
    #   Title
    #   *Subtitle*
    #   *Date line*
    #   **Authors**
    #   [**Introduction  2**](#introduction)   <- start of manual TOC
    #   ...
    #   # Introduction                          <- first real heading
    title, subtitle, date, authors = None, None, None, None
    body_start = 0
    for i, line in enumerate(lines):
        s = line.strip()
        if title is None and s and not s.startswith("["):
            title = s.rstrip()
        elif subtitle is None and s.startswith("*") and not s.startswith("**"):
            subtitle = s.strip("*")
        elif date is None and s.startswith("*") and not s.startswith("**"):
            date = s.strip("*")
        elif authors is None and s.startswith("**"):
            authors = s.strip("*")
        elif s.startswith("[**") or s.startswith("# "):
            body_start = i
            break

    out_lines = []
    skipping_toc = True
    for line in lines[body_start:]:
        if skipping_toc:
            if line.startswith("# "):
                skipping_toc = False
            elif re.match(r"^\[\*\*", line) or line.strip() == "":
                continue
        out_lines.append(line)
    text = "\n".join(out_lines)

    # ---- Remove empty page-break headers, replace with real page breaks --
    text = re.sub(r"(?m)^#\s*$\n?", PAGEBREAK, text)

    # ---- Strip heading anchor ids ------------------------------------------
    text = re.sub(r"\s*\{#[^}]*\}", "", text)

    # ---- Un-escape Google Docs backslash-escapes ---------------------------
    text = re.sub(r"\\?=\\>", "→", text)
    for ch in ['.', '-', '[', ']', '(', ')', '*', '_']:
        text = text.replace("\\" + ch, ch)

    # ---- Reclassify heading levels -----------------------------------------
    # "N.M Title" -> level 2, number kept.
    text = re.sub(r"(?m)^#\s+(\d+\.\d+\s+.*)$", r"## \1", text)
    # "N. Title" -> level 1, number stripped.
    text = re.sub(r"(?m)^#\s+\d+\.\s*(.*)$", r"# \1", text)

    # "Back-story" plain paragraph -> heading.
    text = re.sub(r"(?m)^Back-story\s*$", "## Back-story", text)

    # ---- Tidy blank lines ---------------------------------------------------
    text = re.sub(r"\n{3,}", "\n\n", text)
    text = text.strip() + "\n"

    frontmatter = (
        "---\n"
        f"title: \"{title}\"\n"
        f"subtitle: \"{subtitle}\"\n"
        f"author: \"{authors}\"\n"
        f"date: \"{date}\"\n"
        "---\n\n"
    )
    return frontmatter + text


if __name__ == "__main__":
    src, dst = sys.argv[1], sys.argv[2]
    with open(src, encoding="utf-8") as f:
        content = f.read()
    with open(dst, "w", encoding="utf-8") as f:
        f.write(clean(content))
    print(f"Cleaned {src} -> {dst}")
