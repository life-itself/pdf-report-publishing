# Vendored fonts

Every font used by the Typst template lives here rather than being
installed on the machine. This is deliberate: the first pass at this
template silently fell back to a different face on each machine it was
built on — Liberation Sans in the original sandbox, a system serif on
macOS — producing two visibly different PDFs from identical source. A
report template that renders differently depending on who runs it isn't a
template.

Every build passes `--font-path fonts`, so these are the only fonts the
build can see. Check what a font path actually exposes with
`typst fonts --font-path fonts --ignore-system-fonts`.

## What's here

| File | Family | Used for |
|---|---|---|
| `SourceSerif4*.ttf` | Source Serif 4 | **Review** body and chapter titles |
| `Literata*.ttf` | Literata | **Essay** body |
| `Fraunces*.ttf` | Fraunces | **Essay** display — headings, standfirsts, pull quotes, drop caps |
| `Outfit.ttf` | Outfit | **Brief** display — headings, box titles, key figures |
| `WorkSans*.ttf` | Work Sans | **Brief** body; furniture in all three styles |
| `DMMono-*.ttf` | DM Mono | apparatus — Review's endnotes and footer date, Brief's colophon |
| `Spectral-*.ttf` | Spectral | v3 `warm` preset only (superseded) |
| `Baloo2.ttf` | Baloo 2 | v3 `warm` preset only (superseded) |
| `BricolageGrotesque-Text-*.ttf` | Bricolage Grotesque Text | **SoR** body. Static cuts at the text optical size, plus matching obliques, made from `BricolageGrotesque.ttf` by `scripts/make-bricolage.py` |
| `ApfelGrotezk-*.otf` | Apfel Grotezk | **SoR** labels, running heads, folios. From the design repo (`system/fonts/`) |
| `licensed/` (not committed) | Polyamine, Restora | **SoR** titles; heads and quotations. Paid faces: see below |

Most are variable fonts (`[wght]`, `[opsz,wght]` axes). Typst 0.15
instantiates these correctly, so a single file covers the whole weight
range — checked before relying on it, since older Typst versions did not.

## Licensing

All committed fonts are SIL Open Font License 1.1, from the
[google/fonts](https://github.com/google/fonts) repository (Apfel Grotezk
from Collletttivo, via the design repo). The
corresponding licence text is alongside each as `OFL-<family>.txt`. The
OFL permits bundling and redistribution, including in commercial work,
provided the licence travels with the fonts — which is why these files
are committed rather than gitignored.

To add a family:

```sh
curl -O https://raw.githubusercontent.com/google/fonts/main/ofl/<family>/<File>.ttf
curl -o OFL-<family>.txt https://raw.githubusercontent.com/google/fonts/main/ofl/<family>/OFL.txt
```

then reference it from a style in `typst/lib/styles/` and check it renders
with `typst fonts --font-path fonts --ignore-system-fonts`. Note that
italics are separate files — `Fraunces-Italic[SOFT,WONK,opsz,wght].ttf`
had to be fetched alongside the roman, and a missing italic shows up as a
synthesised slant rather than as an error.

## Licensed faces: Polyamine and Restora

The SoR style uses two paid faces. Their licences allow embedding in our
PDFs but not redistribution, and this repo is public, so the font files are
never committed. Put them in `fonts/licensed/` (gitignored) or install them
on the machine; Typst finds either. Without Restora the build sets its slots
in Fraunces and says so. Without Polyamine Typst warns and falls back to
another face, and every title shows it.
