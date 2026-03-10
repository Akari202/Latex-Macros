// typst compile ./file.typ --input solutions=false
#let show-solutions = sys.inputs.at("solutions", default: "true") == "true"
#let color = sys.inputs.at("color", default: "false") == "true"
#let is-homework = true
#let author = "Akari Harada"
