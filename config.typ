// typst compile ./file.typ --input solutions=false
#let show-solutions = sys.inputs.at("solutions", default: "true") == "true"
#let show-grades = sys.inputs.at("grades", default: "true") == "true"
#let compile-host = sys.inputs.at("compile-host", default: "cli")
#let handout-mode = sys.inputs.at("handout-mode", default: "false") == "true"
// #let only-figures = sys.inputs.at("only-figures", default: "true") == "true"
#let show-color = sys.inputs.at("color", default: "true") == "true"
#let author = "Akari Harada"
#let __typ-utils = plugin("./typ-utils/typ_utils.wasm")

#let output-is-html() = {
  compile-host == "didactic" or sys.inputs.at("target", default: "paged") == "html"
}

#let __is-color(color, bnw) = {
  if show-color {
    color
  } else {
    bnw
  }
}

#let color-config = (
    todo: __is-color(red, red),
    grade: __is-color(red,gray),
    theorem: __is-color(blue,black),
    theorem-fill: __is-color(blue.lighten(95%),white),
    definition: __is-color(red,black),
    definition-fill: __is-color(red.lighten(95%),white),
    example: __is-color(green,black),
    example-fill: __is-color(green.lighten(95%),white),
    formula: __is-color(orange,black),
    formula-fill: __is-color(orange.lighten(95%),white),
)

