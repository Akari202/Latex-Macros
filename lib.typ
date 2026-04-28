// Drawing: https://typst.app/universe/package/cetz
// Diagrams: https://typst.app/universe/package/fletcher
// Mechanical Systems: https://github.com/34j/typst-cetz-mechanical-system
// Number Formatting: https://typst.app/universe/package/zero
// Physica: https://github.com/Leedehai/typst-physics
// Obsidian Formatting: https://github.com/k0src/Typsidian/
// Algorithm Pseudocode: https://typst.app/universe/package/algorithmic/
// Data Viz: https://lilaq.org/
// Colors: https://typst.app/universe/package/pigmentpedia
// Arrows: https://typst.app/universe/package/tiptoe
// Notes: https://typst.app/universe/package/drafting
// Slides: https://polylux.dev/book/getting-started/getting-started.html
//
//
// Some of the derivative macros were modified from/inspired by Physica
//
// Naming convention:
// I am tring to switch all identifiers to use kebab-case
// "private" identifiers will be prefixed with "__"
// Units and constants will continue to use snake_case
// Additionally WASM plugin function names will follow Rust and be snake_case
// Internal typst variables are inconsistent and need to be fixed

#import "config.typ": author, compile-host, show-color
#import "units.typ"
#import "cooking.typ"
#import "draw.typ"
#import "math.typ": *
#import "constants.typ"
#import "circuits.typ"
#import "calendar.typ": month-calendar, range-calendar
#import "setups.typ": *
#import "util.typ": *

#import units: prefix, temperature
