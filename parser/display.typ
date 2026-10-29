#let cfg-joiner = "->"

#let cfg(grammar) = {
  set par(spacing: 1em)
  block(
    fill: gray.lighten(90%),
    stroke: gray,
    inset: (x: 8pt, y: 8pt),
    radius: 2pt,
    breakable: true,
    align(left, for production in grammar
      .pairs()
      .map(i => {
        let new = i
          .at(1)
          .map(j => {
            (
              "",
              $|$,
              if j.len() == 0 {
                $epsilon$
              } else {
                eval(mode: "math", j.join(" "))
              },
            )
          })
        new.at(0).at(0) = eval(mode: "math", i.at(0))
        new.at(0).at(1) = eval(mode: "math", cfg-joiner)
        grid(
          align: (right, right, left),
          columns: 3,
          inset: 0.2em,
          ..new.flatten()
        )
      }) {
      production
    }),
  )
}

#let display-action(action, wide: false) = {
  return if action.at(0) == "reduce" {
    [
      #action.at(0) #if wide { [] } else { [\ ] } #text(
        size: if wide { 0.8em } else { 0.5em },
        eval(
          mode: "math",
          action.at(1).at(0) + cfg-joiner + action.at(1).at(1).join(" "),
        ),
      )]
  } else if action.at(0) == "shift" {
    [#action.at(0) #action.at(1)]
  } else if action == "accept" {
    [#action]
  }
}

#let show-lr-table(action-table, goto-table) = {
  set par(leading: 0.5em)
  let terminals = action-table.keys()
  let nonterminals = goto-table.keys()
  let counts = (
    row: action-table.at(terminals.at(0)).len(),
    action-col: terminals.len(),
    goto-col: nonterminals.len(),
  )
  table(
    columns: 1 + counts.action-col + counts.goto-col,
    stroke: (x, y) => {
      let stroke = (top: none, bottom: none, left: none, right: none)
      let weight = 0.5pt
      if y < 2 {
        stroke.top = weight
        stroke.bottom = weight
      } else if y == counts.row + 1 {
        stroke.bottom = weight
      }
      if x == 0 or x == counts.action-col {
        stroke.right = weight
      } else if x == 1 and y == 0 {
        stroke.right = weight
      }
      return stroke
    },
    inset: (x: 8pt, y: 5pt),
    table.header(
      table.cell(rowspan: 2, align(center + horizon)[State]),
      table.cell(colspan: counts.action-col, align(center)[Action]),
      table.cell(colspan: counts.goto-col, align(center)[Goto]),
      ..terminals.map(i => { align(center, i) }),
      ..nonterminals.map(i => { align(center, i) }),
    ),
    ..range(counts.row)
      .map(i => {
        let row = ([#i],)
        for j in terminals {
          let action = action-table.at(j).at(i)
          if action != none {
            row.push(display-action(action))
          } else {
            row.push([])
          }
        }
        for j in nonterminals {
          let goto = goto-table.at(j).at(i)
          if goto != none {
            row.push([#goto])
          } else {
            row.push([])
          }
        }
        return row
      })
      .flatten()
  )
}



#let draw-parse-tree(parse-tree, scale-factor: 100%) = {
  import "@preview/cetz:0.5.2"

  let node-to-cetz(node) = {
    let label = [#node.symbol]
    if node.type == "leaf" {
      (label,)
    } else {
      (label, ..node.children.map(node-to-cetz))
    }
  }

  cetz.canvas({
    import cetz.tree
    import cetz.draw: *
    set-style(content: (padding: .3))
    scale(scale-factor)
    tree.tree(node-to-cetz(parse-tree))
  })
}



#let show-parse-trace(parse-trace) = {
  set par(leading: 0.5em)
  let counts = (
    row: parse-trace.input.len(),
  )
  table(
    columns: 4,
    stroke: (x, y) => {
      let stroke = (top: none, bottom: none, left: none, right: none)
      let weight = 0.5pt
      if y < 1 {
        stroke.top = weight
        stroke.bottom = weight
      } else if y == counts.row + 1 {
        stroke.bottom = weight
      }
      if x == 1 or x == 2 {
        stroke.right = weight
      }
      return stroke
    },
    inset: (x: 8pt, y: 5pt),
    table.header(
      table.cell(colspan: 2, align(center + horizon)[Stack]),
      align(center)[Input], align(center)[Action],
    ),
    ..range(counts.row)
      .map(i => {
        (
          [(#i)],
          align(left, raw(parse-trace.stack.at(i).map(str).join(" "))),
          align(right, raw(parse-trace.input.at(i).join(" "))),
          [#display-action(parse-trace.action.at(i), wide: true)],
        )
      })
      .flatten(),
  )
}


