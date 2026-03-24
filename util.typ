#import "config.typ": __typ-utils, show-solutions

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

#let appendix(body, repeat-figures: false) = {
  pagebreak(weak: true)
  set heading(numbering: "A.a", supplement: [Appendix])
  counter(heading).update(0)
  body
  if repeat-figures {
    [= All Figures]
    context {
      let figures = query(figure)
      for i in figures {
        [== #query(selector(heading).before(i.location())).at(-1).body | #i.supplement #numbering(i.numbering, i.counter.at(i.location()).at(0))]
        i
      }
    }
  }
}

#let fit-monomial(data, max_degree: 5) = {
  import "@preview/sertyp:0.1.2"
  assert(max_degree < calc.pow(2, 7) - 1, message: "Cannot have a degree higher than 127")
  let fit = cbor(__typ-utils.fit_monomial(
    sertyp.serialize-cbor(data.map(i => { i.map(float) })),
    sertyp.serialize-cbor(max_degree),
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

#let truth-table(statement, caption: "Truth table for the statement") = {
  let data = cbor(__typ-utils.truth_table(bytes(statement)))
  figure(
    caption: caption,
    table(
      columns: data.headers.len(),
      align: center,
      stroke: (x, y) => {
        let s = (thickness: 0.5pt)
        (
          top: if y == 1 { s },
          bottom: if y == 0 { s },
          left: if x > 0 { s },
          right: if x < data.headers.len() - 1 { s },
        )
      },
      ..data.headers.map(i => [#eval(i, mode: "math")]),
      ..data.rows.flatten().map(i => if i [T] else [F])
    ),
  )
}

// For columns:
// l:  left align
// r:  right align
// c:  center align
// |:  vertical line
// ||: bold vertical line (wish double lines were easy)
//
// For rows:
// t:  top align
// b:  bottom align
// h:  horizon align
// |:  horizontal line
// ||: bold horizontal line (wish double lines were easy)
//
// For both:
// " ": adds one unit of padding
//
// Returns a dictionary that can be spread into a table:
// (
//     inset: fn(x, y),
//     align: fn(x,y),
//     stroke: fn(x, y)
// )
//
// NOTE:
// Currently rows and columns must have enough markers for the size of the table
#let latex-style(cols: "", rows: "", weight: 0.5pt, padding: 1em) = {
  let alignment-markers = (l: left, r: right, c: center, t: top, b: bottom, h: horizon)
  let alignment-keys = alignment-markers.keys()

  let nibble(input, rev: false) = {
    let result = (pad: 0% + 5pt, sep: none)
    if input.len() == 0 {
      return result
    }
    if rev {
      input = input.rev()
    }
    for k in input {
      if k == " " {
        if result.sep == none {
          result.pad += padding
        } else {
          return result
        }
      } else if k == "|" {
        if result.sep == none {
          result.sep = "|"
        } else {
          result.sep += "|"
        }
      }
    }
    if result.sep == none {
      result.pad *= 50%
    }
    return result
  }

  let parse(string) = {
    let result = (:)
    let chars = string.clusters()
    let n = chars.len()

    let marker-indices = ()
    for i in range(n) {
      if chars.at(i) in alignment-keys {
        marker-indices.push(i)
      }
    }

    for (i, j) in marker-indices.enumerate() {
      let char = chars.at(j)
      let before = chars.slice(
        if i == 0 {
          0
        } else {
          marker-indices.at(i - 1) + 1
        },
        j,
      )
      let after = chars.slice(
        j + 1,
        if i == marker-indices.len() - 1 {
          none
        } else {
          marker-indices.at(i + 1)
        },
      )

      result.insert(str(i), (
        align: alignment-markers.at(char, default: none),
        before: nibble(before, rev: true),
        after: nibble(after, rev: false),
      ))
    }
    result
  }

  let cols = parse(cols)
  let rows = parse(rows)

  let get-stroke(sep) = {
    if sep == none {
      none
    } else if sep == "||" {
      weight * 2
    } else if sep == "|" {
      weight
    }
  }

  (
    align: (x, y) => {
      cols.at(str(x)).align + rows.at(str(y)).align
    },
    inset: (x, y) => {
      let vertical = rows.at(str(y))
      let horizontal = cols.at(str(x))
      (
        left: horizontal.before.pad,
        right: horizontal.after.pad,
        top: vertical.before.pad,
        bottom: vertical.after.pad,
      )
    },
    stroke: (x, y) => {
      let vertical = rows.at(str(y))
      let horizontal = cols.at(str(x))
      (
        left: get-stroke(horizontal.before.sep),
        right: get-stroke(horizontal.after.sep),
        top: get-stroke(vertical.before.sep),
        bottom: get-stroke(vertical.after.sep),
      )
    },
  )
}

#let typst-example(
  body,
  scope: (:),
  caption: "A demonstration of typst code",
  columns: (1fr, 1fr),
) = {
  figure(
    caption: caption,
    grid(
      columns: columns,
      inset: 1.5em,
      align: left + horizon,
      raw(lang: "typst", block: true, body), eval(body, mode: "markup", scope: scope),
    ),
  )
}

#let boxed(body) = {
  rect(body, outset: 4pt, stroke: 0.5pt)
}

