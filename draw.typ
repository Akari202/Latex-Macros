#let draw-nested(size, location: (0, 0), ..args) = {
  import "@preview/cetz:0.4.2": draw.rect
  for (label, dimensions) in size {
    rect(
      (location.at(0) - dimensions.at(0) / 2, location.at(1) - dimensions.at(1) / 2),
      (location.at(0) + dimensions.at(0) / 2, location.at(1) + dimensions.at(1) / 2),
      ..args,
    )
  }
}
