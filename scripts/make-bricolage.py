"""Cut static Bricolage Grotesque fonts for the sor style from the variable font.

Two problems with using fonts/BricolageGrotesque.ttf directly:

1. Its default instance is the 96pt optical size, weight 800, and Typst
   exposes it as the family "Bricolage Grotesque 96pt". Typst does not drive
   the opsz axis from the text size, so body text would be set in the
   display cut. We instance at opsz 12 (text) instead.
2. Bricolage has no italic, and Typst does not synthesise one. The approved
   mockups (design repo, examples/print/) show the browser's synthetic
   oblique for <i>, so we make the same: the upright outlines slanted.

Output: fonts/BricolageGrotesque-Text-{weight}[-Oblique].ttf, family
"Bricolage Grotesque Text". Run with fontTools available:

    python scripts/make-bricolage.py
"""
import math
import pathlib

from fontTools.pens.recordingPen import DecomposingRecordingPen
from fontTools.pens.transformPen import TransformPen
from fontTools.pens.ttGlyphPen import TTGlyphPen
from fontTools.ttLib import TTFont
from fontTools.varLib.instancer import instantiateVariableFont

FONTS = pathlib.Path(__file__).resolve().parent.parent / "fonts"
SRC = FONTS / "BricolageGrotesque.ttf"
FAMILY = "Bricolage Grotesque Text"
WEIGHTS = {350: "Book", 500: "Medium", 600: "SemiBold"}  # body; summary box; bold
SLANT = 11  # degrees, close to the browser's synthetic oblique


def set_names(font, style, weight, italic):
    full = f"{FAMILY} {style}{' Oblique' if italic else ''}"
    ps = f"BricolageGrotesqueText-{style}{'Oblique' if italic else ''}"
    sub = ("Italic" if italic else "Regular")
    name = font["name"]
    name.names = [n for n in name.names if n.nameID not in (1, 2, 3, 4, 6, 16, 17, 25)]
    for nid, val in ((1, FAMILY), (2, sub), (3, ps), (4, full), (6, ps),
                     (16, FAMILY), (17, f"{style}{' Oblique' if italic else ''}")):
        name.setName(val, nid, 3, 1, 0x409)
    os2 = font["OS/2"]
    os2.usWeightClass = weight
    os2.fsSelection = (os2.fsSelection & ~0b1100001) | (0b1 if italic else 0) | (0 if italic else 0b1000000)
    font["head"].macStyle = 0b10 if italic else 0
    if italic:
        font["post"].italicAngle = -SLANT


def slant(font):
    glyf, hmtx = font["glyf"], font["hmtx"]
    gs = font.getGlyphSet()
    k = math.tan(math.radians(SLANT))
    new = {}
    for gname in font.getGlyphOrder():
        rec = DecomposingRecordingPen(gs)
        gs[gname].draw(rec)
        pen = TTGlyphPen(None)
        rec.replay(TransformPen(pen, (1, 0, k, 1, 0, 0)))
        new[gname] = pen.glyph()
    for gname, g in new.items():
        glyf[gname] = g
        g.recalcBounds(glyf)
        adv, _ = hmtx[gname]
        hmtx[gname] = (adv, getattr(g, "xMin", 0))


for weight, style in WEIGHTS.items():
    for italic in (False, True):
        font = instantiateVariableFont(TTFont(SRC), {"opsz": 12, "wdth": 100, "wght": weight})
        for t in ("STAT", "fvar", "avar", "gvar", "HVAR", "MVAR"):
            if t in font:
                del font[t]
        if italic:
            slant(font)
        set_names(font, style, weight, italic)
        out = FONTS / f"BricolageGrotesque-Text-{style}{'-Oblique' if italic else ''}.ttf"
        font.save(out)
        print(out.name)
