// Type + colour presets for the Life Itself report template.
//
// Kept separate from report.typ so the *design system* (what the report
// looks like) can be swapped without touching the *layout logic* (how the
// pages are assembled). `typst/specimen.typ` renders the same real page of
// content in each preset, side by side, so a preset can be chosen by
// looking rather than guessing.
//
// Research behind these choices — three reports from Rufus's Are.na board
// (are.na/rufus-pollock/report-inspirations-for-life-itself), see
// docs/typography-research.md:
//   - CRI "Reality Check"    : Freight Text Pro (serif body) + Freight Sans
//   - Mindfulness Initiative : ITC Avant Garde (display) + Oxygen (body)
//   - PCI Position Paper     : Inter + DM Mono
// The common thread in the ones that read as high-class is a *serif body*
// with a sans used only for headings, captions and furniture. The current
// v2 template was sans throughout, which is a big part of why it read flat.

// ---- Colour ----------------------------------------------------------
// Sampled from reference/designer-what-is-2r.pdf in the 2026-08-15 session
// and kept — the palette was never the problem.
#let palette = (
  cream:  rgb("#FFFFE3"),
  maroon: rgb("#4C2E2D"),  // headings
  ink:    rgb("#2E2422"),  // body text (darkened from #3A2C2B: the old value
                           // was noticeably washed out at serif text sizes)
  muted:  rgb("#8A7370"),  // captions, footer, marginalia
  rose:   rgb("#B5677E"),  // emphasis, links, pull quotes
  gold:   rgb("#B99A54"),  // rules, accents
  rule:   rgb("#D9CFC9"),  // hairlines
)

// ---- Type presets -----------------------------------------------------
// Each preset fixes the two families and the metrics that go with them —
// a serif at 10.5pt is not the same optical size as a sans at 10.5pt, so
// size/leading travel with the pairing rather than being global constants.
#let presets = (
  // Closest to the existing brand: keeps the reference PDF's rounded
  // geometric heading face (Baloo 2 is the free stand-in for it) but puts
  // a proper editorial serif underneath it.
  "warm": (
    label:        "Warm — Baloo 2 / Spectral",
    note:         "Keeps the reference's rounded geometric headings, adds an editorial serif body.",
    heading:      "Baloo 2",
    heading-weight: 800,
    body:         "Spectral",
    body-size:    10.2pt,
    leading:      0.80em,
    heading-case: "upper",
    heading-track: 0.4pt,
  ),
  // The CRI "Reality Check" feel: sober, institutional, restrained. The
  // most conservative of the four and the easiest to read at length.
  "editorial": (
    label:        "Editorial — Work Sans / Literata",
    note:         "Sober and institutional, closest to CRI's Reality Check.",
    heading:      "Work Sans",
    heading-weight: 700,
    body:         "Literata",
    body-size:    10pt,
    leading:      0.82em,
    heading-case: "none",
    heading-track: 0pt,
  ),
  // Modern and crisp — geometric sans headings over Adobe's Source Serif.
  "modern": (
    label:        "Modern — Outfit / Source Serif 4",
    note:         "Crisp geometric headings, quiet serif body.",
    heading:      "Outfit",
    heading-weight: 600,
    body:         "Source Serif 4",
    body-size:    10.5pt,
    leading:      0.80em,
    heading-case: "none",
    heading-track: 0pt,
  ),
  // The most magazine-like: Fraunces is a high-contrast "soft serif"
  // display face, so headings and body are both serif and the sans drops
  // out to furniture only (captions, folios).
  "display": (
    label:        "Display — Fraunces / Source Serif 4",
    note:         "Magazine-like: a display serif for headings, sans only as furniture.",
    heading:      "Fraunces",
    heading-weight: 600,
    body:         "Source Serif 4",
    body-size:    10.5pt,
    leading:      0.80em,
    heading-case: "none",
    heading-track: 0pt,
  ),
)

// Sans used for furniture (captions, folios, marginalia) regardless of the
// preset's display face — a neutral grotesque keeps small text legible
// where a display face would not.
#let furniture = "Work Sans"

#let preset(name) = {
  assert(name in presets, message: "unknown type preset: " + name)
  presets.at(name)
}
