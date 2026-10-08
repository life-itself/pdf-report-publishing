"""Measure the content box of each PNG figure, so the sor style can crop
the white margin the figure was drawn with.

SoR figures are drawn with a margin so they stand alone when shared; on the
page that margin pushes the figure in from the text edge. This finds, per
image, the box of pixels that differ from the corner colour, and writes
{"name.png": [x0, y0, x1, y1, width, height], ...} as JSON.

Standard library only (a minimal PNG decoder: 8-bit, non-interlaced, grey,
RGB or RGBA), so the build needs nothing installed.

    python3 scripts/figure-bounds.py bounds.json fig1.png fig2.png ...
"""
import json
import pathlib
import struct
import sys
import zlib

TOLERANCE = 12  # per channel, out of 255


def decode(path):
    data = path.read_bytes()
    if data[:8] != b"\x89PNG\r\n\x1a\n":
        return None
    pos, idat, w = 8, b"", None
    while pos < len(data):
        n, kind = struct.unpack(">I4s", data[pos:pos + 8])
        chunk = data[pos + 8:pos + 8 + n]
        pos += 12 + n
        if kind == b"IHDR":
            w, h, depth, ctype, _, _, interlace = struct.unpack(">IIBBBBB", chunk)
            if depth != 8 or interlace or ctype not in (0, 2, 4, 6):
                return None
            bpp = {0: 1, 2: 3, 4: 2, 6: 4}[ctype]
        elif kind == b"IDAT":
            idat += chunk
        elif kind == b"IEND":
            break
    raw = zlib.decompress(idat)
    stride = w * bpp
    rows, prev, i = [], bytearray(stride), 0
    for _ in range(h):
        f = raw[i]
        line = bytearray(raw[i + 1:i + 1 + stride])
        i += 1 + stride
        for x in range(stride):
            a = line[x - bpp] if x >= bpp else 0
            b = prev[x]
            c = prev[x - bpp] if x >= bpp else 0
            if f == 1:
                line[x] = (line[x] + a) & 255
            elif f == 2:
                line[x] = (line[x] + b) & 255
            elif f == 3:
                line[x] = (line[x] + ((a + b) >> 1)) & 255
            elif f == 4:
                p = a + b - c
                pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
                line[x] = (line[x] + (a if pa <= pb and pa <= pc else b if pb <= pc else c)) & 255
        rows.append(line)
        prev = line
    return w, h, bpp, rows


def bounds(path):
    img = decode(path)
    if img is None:
        return None
    w, h, bpp, rows = img
    colour = min(bpp, 3)  # ignore alpha
    bg = rows[0][:colour]

    def ink(row, x):
        px = row[x * bpp:x * bpp + colour]
        if bpp in (2, 4) and row[x * bpp + bpp - 1] < 16:
            return False  # transparent
        return any(abs(px[k] - bg[k]) > TOLERANCE for k in range(colour))

    x0, y0, x1, y1 = w, h, -1, -1
    for y, row in enumerate(rows):
        xs = [x for x in range(w) if ink(row, x)]
        if xs:
            y0, y1 = min(y0, y), y
            x0, x1 = min(x0, xs[0]), max(x1, xs[-1])
    if x1 < 0:
        return None
    return [x0, y0, x1 + 1, y1 + 1, w, h]


if __name__ == "__main__":
    out = pathlib.Path(sys.argv[1])
    result = {}
    for p in map(pathlib.Path, sys.argv[2:]):
        b = bounds(p)
        if b:
            result[p.name] = b
    out.write_text(json.dumps(result, indent=1) + "\n")
