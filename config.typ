// typst compile ./file.typ --input solutions=false
#let show-solutions = sys.inputs.at("solutions", default: "true") == "true"
// #let only-figures = sys.inputs.at("only-figures", default: "true") == "true"
#let show-color = sys.inputs.at("color", default: "false") == "true"
#let author = "Akari Harada"
#let __typ-utils = plugin("./typ-utils/typ_utils.wasm")
