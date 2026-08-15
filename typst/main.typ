#import "report.typ": report

// Type preset (see theme.typ): warm | editorial | modern | display.
// Overridable from the build script: ./build.sh editorial
#let style = sys.inputs.at("style", default: "warm")

#show: report.with(
  title: "Second Renaissance",
  subtitle: "A time of civilizational crisis and awakening",
  authors: "Sylvie Barbier, Rosie Bell and Rufus Pollock",
  date: "Draft v1.0-r1 — published May 2024",
  logo: "assets/life-itself-logotype.png",
  cover-image: "assets/cover-full.png",
  style: style,
  colophon: [
    © 2024 Life Itself. Some rights reserved — placeholder, needs a real
    licence decision (e.g. All Rights Reserved / CC BY-SA). This is a
    working draft for discussion and feedback; please do not redistribute
    without permission. \
    lifeitself.org
  ],
)

#include "content.typ"
