#!/usr/bin/env python3
"""Turn bare Markdown images into real, captioned Typst figures.

A Google Docs export has no concept of a figure. An image is just an
image, and its caption is whatever line the author happened to type
underneath it — often glued to the image by a trailing-double-space line
break, so it isn't even a separate paragraph. Pandoc faithfully reproduces
that: a stretched image with a stray line of text under it, which is
exactly why the v2 output looked unprofessional on those pages.

This pass reconstructs the author's intent before Pandoc sees it:

- An image on its own line becomes a `#fig(...)` call.
- A short line immediately after it (or a short standalone paragraph one
  blank line later) is taken as its caption.
- A *run* of adjacent captioned images becomes a single `#figrow(...)` —
  one figure with several panels, which is what the Cimabue / Perugino /
  Picasso sequence actually is, rather than three unrelated full-width
  images stacked down the page.

Widths are derived from the images' own pixel dimensions rather than
defaulting to full-column: Google Docs exports at 624px for a full-width
image, so `px_width / 624` recovers roughly the size the author chose. In
a row, widths are instead made proportional to aspect ratio, so the
panels come out the same height and read as a set.
"""
import os
import re
import struct
import sys

IMAGE_RE = re.compile(r"^!\[[^\]]*\]\(([^)]+)\)\s*$")
# Lines that can never be a caption.
NON_CAPTION_RE = re.compile(r"^\s*(#|>|[-*+]\s|\d+\.\s|```|\|)")
CAPTION_MAX = 160
GDOCS_FULL_WIDTH_PX = 624


def png_size(path):
    """Read (width, height) from a PNG's IHDR chunk. No dependencies."""
    try:
        with open(path, "rb") as f:
            head = f.read(24)
        if head[:8] != b"\x89PNG\r\n\x1a\n":
            return None
        return struct.unpack(">II", head[16:24])
    except OSError:
        return None


def size_of(src_path, rel):
    """Resolve an image path relative to the Markdown file and measure it."""
    return png_size(os.path.join(os.path.dirname(src_path), rel))


def is_caption(line):
    s = line.strip()
    return bool(s) and len(s) <= CAPTION_MAX and not NON_CAPTION_RE.match(s)


def typst_str(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def typst_caption(s):
    """Captions go into `[...]` content blocks, so escape Typst markup."""
    return "[" + re.sub(r"([#\[\]@$\\*_`])", r"\\\1", s.strip()) + "]"


def collect_figures(lines, i, src_path):
    """Parse a run of adjacent figures starting at line i.

    Returns (figures, next_i) where figures is a list of
    (path, caption_or_None, (w, h) or None).
    """
    figures = []
    n = len(lines)
    while i < n:
        m = IMAGE_RE.match(lines[i])
        if not m:
            break
        path = m.group(1)
        caption = None
        j = i + 1
        # Caption glued directly under the image (the trailing-double-space
        # case), or a short standalone paragraph one blank line down.
        if j < n and is_caption(lines[j]) and not IMAGE_RE.match(lines[j]):
            caption = lines[j].strip()
            j += 1
        elif (
            j + 1 < n
            and not lines[j].strip()
            and is_caption(lines[j + 1])
            and not IMAGE_RE.match(lines[j + 1])
            # ...and it really is standalone, not the first line of a
            # paragraph of body prose.
            and (j + 2 >= n or not lines[j + 2].strip())
        ):
            caption = lines[j + 1].strip()
            j += 2
        figures.append((path, caption, size_of(src_path, path)))
        # Skip blank lines to see whether another figure follows directly.
        k = j
        while k < n and not lines[k].strip():
            k += 1
        if k < n and IMAGE_RE.match(lines[k]):
            i = k
            continue
        i = j
        break
    return figures, i


def width_pct(size):
    """Full-column width for a lone figure, scaled down for small images."""
    if not size:
        return 100
    pct = round(size[0] / GDOCS_FULL_WIDTH_PX * 100)
    return max(35, min(100, pct))


def render(figures):
    if len(figures) == 1:
        path, caption, size = figures[0]
        args = [typst_str(path)]
        if caption:
            args.append("caption: " + typst_caption(caption))
        w = width_pct(size)
        if w != 100:
            args.append(f"width: {w}%")
        return "```{=typst}\n#fig(" + ", ".join(args) + ")\n```"

    # A row: make widths proportional to aspect ratio so every panel comes
    # out the same height.
    aspects = [(s[0] / s[1]) if s else 1.0 for (_, _, s) in figures]
    total = sum(aspects)
    ratios = ", ".join(f"{a / total * 100:.1f}fr" for a in aspects)
    items = ", ".join(
        f"({typst_str(p)}, {typst_caption(c) if c else '[]'})" for (p, c, _) in figures
    )
    return (
        "```{=typst}\n#figrow((" + items + ",), ratios: (" + ratios + "))\n```"
    )


def transform(text, src_path):
    lines = text.split("\n")
    out = []
    i = 0
    while i < len(lines):
        if IMAGE_RE.match(lines[i]):
            figures, i = collect_figures(lines, i, src_path)
            if figures:
                # Raw blocks need blank lines around them to stay block-level.
                if out and out[-1].strip():
                    out.append("")
                out.append(render(figures))
                out.append("")
                continue
        out.append(lines[i])
        i += 1
    return re.sub(r"\n{3,}", "\n\n", "\n".join(out))


if __name__ == "__main__":
    src, dst = sys.argv[1], sys.argv[2]
    with open(src, encoding="utf-8") as f:
        content = f.read()
    with open(dst, "w", encoding="utf-8") as f:
        f.write(transform(content, src))
    print(f"Figures {src} -> {dst}")
