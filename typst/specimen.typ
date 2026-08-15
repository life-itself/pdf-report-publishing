// Type-preset specimen: the same real page of the essay, once per preset.
//
// The point is to choose a pairing by looking at it doing the actual job —
// a chapter opening, a subhead, justified body at the real measure, a
// bold run, an italic run, a captioned figure — rather than by looking at
// font names or isolated swatches. Every page here goes through the same
// `body-rules` the real report uses, so what you see is what builds.
//
//   typst compile --font-path ../fonts specimen.typ ../output/type-specimen.pdf

#import "theme.typ": palette, presets, furniture
#import "report.typ": body-rules, fig, TEXT-L, TEXT-R, MARGIN-W, MARGIN-DX, GUTTER

#set document(title: "Life Itself report template — type specimen")

#let excerpt = [
  = Evolving Cultural Paradigms

  Biological evolution supplies only a rough analogy for cultural evolution,
  but offers illuminating parallels. Within cultures, successful ideas or
  'memes' are reproduced and passed between people. Like genes, memes aren't
  selected on their own — rather they come together in packages, groups of
  ideas, like DNA. Like biological species, examples of these cultural codes
  vary in their attributes. Different societies throughout history have
  shared similar *base cultural paradigms* comprising particular sets of
  core views and values.

  == Punctuated equilibria

  Scholars and theorists of cultural evolution observe a historic tendency
  for cultural paradigms to change over centuries. Like genetic evolution,
  paradigms display punctuated equilibria — periods of stasis punctuated by
  shifts that are gradual to begin with and then, beyond a tipping point,
  abrupt. Paradigm shifts entail widespread adoption of radically different
  worldviews and values, with transformative consequences for humanity's
  behavior and relationship with the world. However, the ideas that will
  characterize the next paradigm often form _before_ the shift itself.

  #fig(
    "assets/paradigmatic-features-landscape.png",
    caption: [Features of the pre-modern, modern and post-modern paradigms.],
  )

  Influential among such frameworks is the *Spiral Dynamics* model, which has
  evolved from the early work of Clare Graves via Beck and Cowan into the
  popular synthesis by Ken Wilber and the Integral movement.
]

#for (name, p) in presets {
  set page(
    paper: "a4",
    fill: white,
    margin: (left: TEXT-L, right: TEXT-R, top: 26mm, bottom: 24mm),
    footer: {
      set text(font: furniture, size: 7.5pt, fill: palette.muted)
      place(left, dx: MARGIN-DX, box(width: MARGIN-W, align(right)[
        #text(weight: 600, fill: palette.maroon)[#upper(name)]
      ]))
      [#p.label #h(0.6em) #text(fill: palette.rule.darken(20%))[|] #h(0.6em) #p.note]
    },
  )
  // Reset the chapter counter each time, so every specimen page opens on
  // "01" rather than counting up through the presets.
  counter("chapter").update(0)
  [#show: body-rules.with(p)
   #excerpt]
}
