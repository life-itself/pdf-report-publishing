// Seeds of Renaissance No. 6: Wisdom and Wanting What's Good.
//
// Built by `typst/build-paper.sh wisdom`, which reads the text from the
// 2rbook repo (wisdom/essay.md), converts it with scripts/sor.lua and puts
// the result, the frontmatter and the figures in typst/build/paper/.
//
// Everything written comes from the essay's frontmatter: title-page fields
// at the top level, text only the PDF uses under `pdf:`. This file holds
// no text of its own.

#import "/typst/lib/styles/sor.typ": paper

#let fm = yaml("/typst/build/paper/meta.yaml")
#let pdf = fm.at("pdf", default: (:))
#let meta = (
  title: fm.title,
  subtitle: fm.subtitle,
  series-number: str(fm.series_number),
  subseries: fm.subseries,
  part: str(fm.part),
  authors: fm.authors,
  organisation: fm.organisation,
)
#let year = str(fm.year)
#let url = fm.url.replace(regex("^https?://"), "")
#let cover = sys.inputs.at("cover", default: none)

// "Rufus Pollock" -> "Pollock, R."
#let cite-name(n) = {
  let parts = n.split(" ")
  parts.last() + ", " + parts.first().first() + "."
}
#let licences = (
  "CC BY 4.0": [© #year the authors. Published under a Creative Commons Attribution 4.0 International licence (CC BY 4.0): you may share and adapt this work for any purpose, provided you credit the authors and link to the licence. #link("https://creativecommons.org/licenses/by/4.0/")[creativecommons.org/licenses/by/4.0]],
)
// Plain text from YAML: blank lines separate paragraphs.
#let paras(s) = s.trim().split(regex("\n\s*\n")).map(p => par(p.trim())).join()
// The series description leads with the series name in ink.
#let series-about = {
  let s = pdf.at("series_about", default: "")
  if s.starts-with(fm.series) {
    text(fill: rgb("#1b1916"), weight: 600, fm.series) + s.slice(fm.series.len())
  } else { s }
}

#show: paper.with(
  meta: meta,
  cover: cover,
  figures: json("/typst/build/paper/figure-bounds.json"),
  imprint: (
    about: series-about,
    rows: (
      ("Edition", [Version #fm.version. First published #fm.published by the #meta.organisation]),
      ("Authors", meta.authors.join(" and ")),
      ("Thanks", if pdf.at("thanks", default: none) != none { pdf.thanks } else {
        text(fill: rgb("#5d584f"), style: "italic")[\[Acknowledgements\]]
      }),
      ("Credits", pdf.at("credits", default: "")),
      ("Licence", licences.at(fm.licence, default: fm.licence)),
      ("Cite as", [#meta.authors.map(cite-name).join(" and ") (#year). _#meta.title: #meta.subtitle._ #fm.series No. #meta.series-number. #meta.organisation.]),
      ("Online", link(fm.url, url)),
    ),
  ),
  back: (
    blurb: pdf.at("back_blurb", default: fm.blurb),
    about: paras(pdf.at("back_about", default: "")),
    colophon: (
      fm.series + " · No. " + meta.series-number,
      meta.subseries + " · Part " + meta.part + " · v" + str(fm.version) + " · " + year,
      url,
    ),
  ),
)

#include "/typst/build/paper/content.typ"
