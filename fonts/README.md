# Vendored fonts

Every font used by the Typst template lives here rather than being
installed on the machine. This is deliberate: the first pass at this
template silently fell back to a different face on each machine it was
built on — Liberation Sans in the original sandbox, a system serif on
macOS — producing two visibly different PDFs from identical source. A
report template that renders differently depending on who runs it isn't a
template.

`typst/build.sh` passes `--font-path ../fonts`, so these are the only
fonts the build can see.

## What's here

| File | Family | Used for |
|---|---|---|
| `Spectral-*.ttf` | Spectral | body — `warm` preset |
| `Literata*.ttf` | Literata | body — `editorial` preset |
| `SourceSerif4*.ttf` | Source Serif 4 | body — `modern`, `display` presets |
| `Baloo2.ttf` | Baloo 2 | headings — `warm` preset |
| `WorkSans*.ttf` | Work Sans | headings — `editorial`; furniture in all presets |
| `Outfit.ttf` | Outfit | headings — `modern` preset |
| `Fraunces.ttf` | Fraunces | headings — `display` preset |

Most are variable fonts (`[wght]`, `[opsz,wght]` axes). Typst 0.15
instantiates these correctly, so a single file covers the whole weight
range — checked before relying on it, since older Typst versions did not.

## Licensing

All are SIL Open Font License 1.1, from the
[google/fonts](https://github.com/google/fonts) repository. The
corresponding licence text is alongside each as `OFL-<family>.txt`. The
OFL permits bundling and redistribution, including in commercial work,
provided the licence travels with the fonts — which is why these files
are committed rather than gitignored.

To add a family:

```sh
curl -O https://raw.githubusercontent.com/google/fonts/main/ofl/<family>/<File>.ttf
curl -o OFL-<family>.txt https://raw.githubusercontent.com/google/fonts/main/ofl/<family>/OFL.txt
```

then add a preset in `typst/theme.typ` and check it renders with
`typst fonts --font-path fonts`.
