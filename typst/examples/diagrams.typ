// Figures drawn in Typst rather than imported, so the example documents
// have real figures without depending on third-party artwork. They also
// happen to illustrate the thing the examples are about — the page grid.

// A schematic of a page grid: a page outline with named bands across it.
//   bands: array of (label, width-fraction, filled)
#let grid-diagram(bands, height: 46mm, fill-color: luma(88%), line-color: luma(55%), label-color: luma(40%), label-font: "Work Sans") = {
  layout(size => {
    let w = size.width
    box(width: 100%, height: height, {
      // Page outline.
      place(rect(width: 100%, height: height, stroke: 0.6pt + line-color, fill: none))
      let x = 0pt
      for b in bands {
        let bw = w * b.at(1)
        if b.at(2) {
          place(dx: x, rect(width: bw, height: height, stroke: none, fill: fill-color))
        }
        if x > 0pt {
          place(dx: x, line(length: height, angle: 90deg, stroke: (
            paint: line-color,
            thickness: 0.4pt,
            dash: "dashed",
          )))
        }
        // Band label, rotated so narrow bands still read.
        place(dx: x, dy: height + 1.6mm, box(width: bw, align(center, text(
          font: label-font,
          size: 6.5pt,
          fill: label-color,
        )[#b.at(0)])))
        x = x + bw
      }
    })
    v(6mm)
  })
}

// A schematic of where furniture sits on a page: an outline with markers
// at the named positions.
//   marks: array of (label, x-fraction, y-fraction, align)
#let furniture-diagram(marks, height: 62mm, line-color: luma(60%), mark-color: luma(30%), label-font: "Work Sans") = {
  layout(size => {
    let w = size.width
    box(width: 100%, height: height, {
      place(rect(width: 100%, height: height, stroke: 0.6pt + line-color, fill: none))
      for m in marks {
        let dx = w * m.at(1)
        let dy = height * m.at(2)
        place(dx: dx - 1pt, dy: dy - 1pt, circle(radius: 1.1pt, fill: mark-color, stroke: none))
        // Shift the label box so the requested alignment lands on the mark.
        let shift = if m.at(3) == right { -40mm } else if m.at(3) == center { -20mm } else { 0mm }
        place(dx: dx + shift, dy: dy + 1.6mm, box(width: 40mm, align(m.at(3), text(
          font: label-font,
          size: 6.5pt,
          fill: mark-color,
        )[#m.at(0)])))
      }
    })
    v(4mm)
  })
}
