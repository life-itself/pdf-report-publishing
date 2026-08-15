// The full "What is the Second Renaissance?" essay, set in the Essay style.
//
// This is the shipping build. `typst/main.typ` is the v3 single-template
// version and is kept only until this one is signed off — see NEXT.md.
//
// Built by `typst/build.sh`, which prepares the Markdown, runs Pandoc, and
// prepends the right import line to the generated `content.typ` (an
// `include`d file gets its own scope and does not inherit imports).

#import "lib/styles/essay.typ": report

#show: report.with(
  title: "The Second Renaissance",
  subtitle: "A time of civilizational crisis and awakening",
  authors: "Sylvie Barbier, Rosie Bell and Rufus Pollock",
  date: "Draft v1.0-r1 — published May 2024",
  cover-image: "/typst/assets/cover-full.png",
  epigraph: [
    "Two young fish are swimming along and they meet an older fish swimming
    the other way. The older fish nods at them and says 'Morning, boys.
    How's the water?' The two young fish swim on for a while. Then one of
    them looks over at the other and goes 'What the hell is water?'"

    #h(1fr) — David Foster Wallace
  ],
  colophon: [
    © 2024 Life Itself. Some rights reserved — placeholder, needs a real
    licence decision (e.g. All Rights Reserved / CC BY-SA). This is a
    working draft for discussion and feedback; please do not redistribute
    without permission. \
    lifeitself.org
  ],
)

#include "content.typ"
