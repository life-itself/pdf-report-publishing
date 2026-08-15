#!/usr/bin/env python3
"""Apply editorial marks — standfirsts and pull quotes — from a sidecar file.

See https://github.com/life-itself/pdf-report-publishing/issues/1 for why
this exists. The short version: the three template styles each have a
signature interruption that stops a long argument reading as a grey slab,
and *which* sentence gets lifted is an editorial judgement that cannot be
inferred from the source. Measured on this essay: 2 of 16 chapters have a
syntactically detectable standfirst, and there is no signal at all for pull
quotes.

## Why a sidecar and not inline markers

1. The source is a Google Docs export and gets re-exported. Inline markers
   die on every re-export; a sidecar survives.
2. A pull quote duplicates body text. Inlining the copy lets it drift out of
   sync with the original during editing.

## Why the sidecar is a pointer, not a copy

Marks name a sentence; the *document* remains the source of truth. What
gets typeset is the text as it appears in the Markdown, not the text as
typed into the sidecar — so a pull quote is verbatim by construction. If
the named sentence is no longer in the chapter, the build fails and names
the chapter, which is what stops the sidecar rotting.

## Format

    # a comment
    ## Chapter title, exactly as in the Markdown heading
    standfirst: The first few words are enough to find the paragraph
    pullquote: A sentence that appears verbatim in this chapter.
    pullquote: Continuation lines are indented
        like this.

Matching ignores smart-vs-straight quotes, Markdown emphasis and runs of
whitespace, so marks can be typed by hand without fighting the export's
punctuation.
"""
import re
import sys

# ---- Matching -----------------------------------------------------------
# Marks are typed by a human; the source is a Google Docs export full of
# curly punctuation. Normalise both sides for *comparison only* — what gets
# emitted always comes from the document.
_SMART = str.maketrans({
    "‘": "'", "’": "'", "“": '"', "”": '"',
    "–": "-", "—": "-", "―": "-", "−": "-",
    " ": " ",
})


def normalise(s):
    s = s.translate(_SMART)
    s = re.sub(r"[*_`]", "", s)          # Markdown emphasis is not content
    s = re.sub(r"\s+", " ", s)
    return s.strip().lower()


def typst_content(s):
    """Escape Markdown-ish text for a Typst `[...]` content block."""
    return re.sub(r"([#\[\]@$\\*_`<>])", r"\\\1", s)


# ---- Sidecar ------------------------------------------------------------
# `standfirst` promotes a paragraph the author already wrote (verified
# against the source). `standfirst-text` inserts a standfirst the editor
# wrote, for the majority of chapters that do not open with a bare claim —
# it is authored content and so cannot be verified, which is exactly why it
# is a separate key rather than a silent fallback.
KEYS = ("standfirst", "standfirst-text", "pullquote")


def read_marks(path):
    """-> {chapter title: [(kind, text), ...]} in file order."""
    marks = {}
    chapter = None
    key = None
    with open(path, encoding="utf-8") as f:
        for lineno, raw in enumerate(f, 1):
            line = raw.rstrip("\n")
            if not line.strip() or line.lstrip().startswith("# "):
                continue
            if line.startswith("## "):
                # Chapter titles are matched normalised, so a mark can be
                # typed with straight quotes against a curly-quoted export.
                chapter = normalise(line[3:])
                marks.setdefault(chapter, [])
                key = None
                continue
            m = re.match(r"^([\w-]+):\s*(.*)$", line)
            if m and m.group(1) in KEYS:
                if chapter is None:
                    sys.exit(f"{path}:{lineno}: mark before any '## Chapter' line")
                key = m.group(1)
                marks[chapter].append([key, m.group(2).strip()])
                continue
            if line.startswith((" ", "\t")) and key is not None:
                marks[chapter][-1][1] += " " + line.strip()
                continue
            sys.exit(f"{path}:{lineno}: cannot parse: {line!r}")
    return {k: [tuple(m) for m in v] for k, v in marks.items()}


# ---- Document -----------------------------------------------------------
def split_chapters(text):
    """-> [(title or None, [paragraph, ...])], preserving order."""
    chunks = []
    title = None
    buf = []
    for para in re.split(r"\n\s*\n", text):
        m = re.match(r"^#\s+(.*)$", para.strip())
        if m:
            chunks.append((title, buf))
            title, buf = m.group(1).strip(), [para]
        else:
            buf.append(para)
    chunks.append((title, buf))
    return chunks


def find_sentence(paragraph, wanted):
    """The span of `wanted` inside `paragraph`, as it is actually written.

    Returns the verbatim source substring, or None. Compares normalised
    forms, so the sidecar can be typed with straight quotes against a
    document full of curly ones.
    """
    n_para = normalise(paragraph)
    n_want = normalise(wanted)
    if n_want not in n_para:
        return None
    # Walk the source, tracking how much normalised text each prefix
    # accounts for, to recover the original span.
    start = n_para.index(n_want)
    end = start + len(n_want)
    lo = hi = None
    for i in range(len(paragraph) + 1):
        seen = len(normalise(paragraph[:i]))
        if lo is None and seen >= start + 1:
            lo = i - 1
        if seen >= end:
            hi = i
            break
    if lo is None or hi is None:
        return None
    return paragraph[lo:hi].strip().strip("*_ ")


def apply_marks(text, marks, verbose=True):
    out = []
    applied = 0
    problems = []

    for title, paragraphs in split_chapters(text):
        chapter_marks = marks.get(normalise(title), []) if title else []
        standfirsts = [t for k, t in chapter_marks if k == "standfirst"]
        authored = [t for k, t in chapter_marks if k == "standfirst-text"]
        pullquotes = [t for k, t in chapter_marks if k == "pullquote"]

        used_sf = False
        for para in paragraphs:
            # An authored standfirst is emitted straight after the chapter
            # heading, before any body text.
            if authored and para.strip().startswith("# "):
                out.append(para)
                out.append(
                    "```{=typst}\n#standfirst(["
                    + typst_content(authored.pop(0))
                    + "])\n```"
                )
                applied += 1
                continue

            body = para.strip()

            # A standfirst *replaces* its paragraph: it is the same claim,
            # promoted, not an addition.
            if standfirsts and not used_sf and body and not body.startswith("#"):
                wanted = standfirsts[0]
                if normalise(body).startswith(normalise(wanted)[:40]):
                    plain = body.strip().strip("*").strip()
                    out.append(
                        "```{=typst}\n#standfirst(["
                        + typst_content(plain)
                        + "])\n```"
                    )
                    used_sf = True
                    applied += 1
                    continue

            out.append(para)

            # A pull quote is *added* after the paragraph it was lifted
            # from, so the reader meets the sentence in place first.
            for wanted in list(pullquotes):
                found = find_sentence(body, wanted)
                if found:
                    out.append(
                        "```{=typst}\n#pullquote(["
                        + typst_content(found)
                        + "])\n```"
                    )
                    pullquotes.remove(wanted)
                    applied += 1

        if standfirsts and not used_sf:
            problems.append(f"  {title}: standfirst not found: {standfirsts[0][:60]!r}")
        for leftover in pullquotes:
            problems.append(f"  {title}: pullquote not found: {leftover[:60]!r}")

    known = {normalise(t) for t, _ in split_chapters(text) if t}
    unknown = [c for c in marks if c not in known]
    for c in unknown:
        problems.append(f"  no chapter titled {c!r} in the source")

    if problems:
        sys.exit(
            "editorial marks do not match the source:\n"
            + "\n".join(problems)
            + "\n\nThe document is the source of truth — either the text moved "
            "and the mark needs updating, or the mark has a typo."
        )

    if verbose:
        print(f"Editorial: applied {applied} mark(s)")
    return re.sub(r"\n{3,}", "\n\n", "\n\n".join(out))


if __name__ == "__main__":
    if len(sys.argv) != 4:
        sys.exit("usage: editorial.py <src.md> <marks.txt> <dst.md>")
    src, marks_path, dst = sys.argv[1:4]
    with open(src, encoding="utf-8") as f:
        content = f.read()
    try:
        marks = read_marks(marks_path)
    except FileNotFoundError:
        # No sidecar is a valid state: the editorial pass has not been done.
        print(f"Editorial: no marks file at {marks_path}, passing through")
        marks = {}
    with open(dst, "w", encoding="utf-8") as f:
        f.write(apply_marks(content, marks))
    print(f"Editorial {src} -> {dst}")
