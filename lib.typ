// Drawing: https://typst.app/universe/package/cetz
// Diagrams: https://typst.app/universe/package/fletcher
// Mechanical Systems: https://github.com/34j/typst-cetz-mechanical-system
// Number Formatting: https://typst.app/universe/package/zero
// Physica: https://github.com/Leedehai/typst-physics
// Obsidian Formatting: https://github.com/k0src/Typsidian/
//
//
// Some of the derivative macros were modified from/inspired by Physica

#import "config.typ": *
#import "units.typ"
#import "math.typ": *
#import "constants.typ"
#import "circuits.typ"
#import "calendar.typ": calendar
#import "setups.typ": *
#let __typ_utils = plugin("./typ-utils/typ_utils.wasm")

#let problem(body) = {
  counter("problem").step()
  counter("part").update(0)

  context {
    let count = counter("problem").display()
    [= Problem #count #label("problem" + str(count))]
  }
  body
}

#let part(body) = {
  counter("part").step()

  context {
    [== Part #counter("part").display("A")]
  }
  body
}

#let solution(body) = {
  context {
    let part-val = counter("part").get().first()

    if part-val == 0 {
      [== Solution]
    } else {
      [=== Solution]
    }
  }
  if show-solutions {
    body
  } else {
    pagebreak(weak: true)
  }
}

#let hint(body) = {
  pad(x: 2em, top: 0.5em, bottom: 0.5em)[
    #text(size: 0.85em)[
      #emph[#strong[Hint:] #body]
    ]
  ]
}

#let example(body) = {
  block(
    width: 100%,
    stroke: 0.5pt,
    inset: 1em,
    fill: white,
    radius: 2pt,
  )[
    #text(size: 0.85em)[
      #strong[Example:]\
      #body
    ]
  ]
}

// #let warn(body) = {
//   let message = [#label(repr(body))]
// }

#let todo = {
  // warn("There's still work to do!")
  text(red)[TODO]
}

#let oeis(id) = {
  link("https://oeis.org/" + str(id), id)
}

#let LaTeX = {
  let A = (
    offset: (
      x: -0.33em,
      y: -0.3em,
    ),
    size: 0.7em,
  )
  let T = (
    x_offset: -0.12em,
  )
  let E = (
    x_offset: -0.2em,
    y_offset: 0.23em,
    size: 1em,
  )
  let X = (
    x_offset: -0.1em,
  )
  [L#h(A.offset.x)#text(size: A.size, baseline: A.offset.y)[A]#h(T.x_offset)T#h(E.x_offset)#text(
      size: E.size,
      baseline: E.y_offset,
    )[E]#h(X.x_offset)X]
}

#let appendix(body) = {
  set heading(numbering: "A", supplement: [Appendix])
  counter(heading).update(0)
  [= Appendix]
  body
}

#let fit_monomial(data, max_degree: 5) = {
  assert(max_degree < calc.pow(2, 7) - 1, message: "Cannot have a degree higher than 127")
  let fit = cbor(__typ_utils.fit_monomial(
    cbor.encode(data.map(i => { i.map(float) })),
    max_degree.to-bytes(endian: "little", size: 1),
  ))
  (
    "coefficients": fit.at(0),
    "equation": $#fit.at(1)$,
    "degree": fit.at(2),
    "r-squared": fit.at(3),
    "fn": x => {
      let out = 0
      for i in range(fit.at(2) + 1) {
        out = out + fit.at(0).at(i) * calc.pow(x, i)
      }
      out
    },
  )
}
