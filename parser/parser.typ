#import "display.typ": cfg, draw-parse-tree, show-lr-table, show-parse-trace
#import "slr.typ": generate-slr-table
#import "util.typ": augment, eliminate-left-recursion


#let parse-input(tokens, action-table, goto-table) = {
  tokens.push("$")
  let ip = 0
  let trace = (stack: ((0,),), input: (), action: (), output: ())
  while true {
    trace.stack.push(trace.stack.last())
    trace.input.push(tokens.slice(ip))
    trace.output.push(trace.output.last(default: ()))

    let s = trace.stack.last().last()
    let a = trace.input.last().at(0)
    let action = action-table.at(a).at(s)
    trace.action.push(action)
    if action.at(0) == "shift" {
      let s-prime = action.at(1)
      trace.stack.last().push(a)
      trace.stack.last().push(s-prime)
      trace.output.last().push((type: "leaf", symbol: a))
      ip += 1
    } else if action.at(0) == "reduce" {
      for _ in range(2 * action.at(1).at(1).len()) {
        let _ = trace.stack.last().pop()
      }
      let s-prime = trace.stack.last().last()
      let A = action.at(1).at(0)
      trace.stack.last().push(A)
      trace.stack.last().push(goto-table.at(A).at(s-prime))

      let split-len = trace.output.last().len() - action.at(1).at(1).len()
      let children = trace.output.last().slice(split-len)
      trace.output.last() = trace.output.last().slice(0, split-len)
      trace.output.last().push((type: "node", symbol: A, children: children))
    } else if action == "accept" {
      assert(trace.output.last().len() == 1)
      return trace
    } else {
      assert(false)
    }
  }
}



// #let grammar-one = (
//   E: (("E", "+", "T"), ("T",)),
//   T: (("T", "*", "F"), ("F",)),
//   F: (("(", "E", ")"), ("id",)),
// )
//
// // "(id + id) * id"
// #let grammar-one-input-one = ("(", "id", "+", "id", ")", "*", "id")
// // "id * id + id"
// #let grammar-one-input-two = ("id", "*", "id", "+", "id")
//
// #let grammar-two = (
//   S: (("A", "a"), ("b",)),
//   A: (("A", "c"), ("S", "d"), ()),
// )
//
// #let grammar-three = (
//   S: (("C", "C"),),
//   C: (("c", "C"), ("d",)),
// )
//
// // #closure((("E'", (".", "E")),), augment(grammar-one))
// // #goto((("E'", ("E", ".")), ("E", ("E", ".", "+", "T"))), "+", augment(grammar-one))
// // #lr-zero-items(augment(grammar-one))
// #let (action-table, goto-table) = generate-slr-table("E'", augment(grammar-one))
// #show-lr-table(action-table, goto-table)
//
// #let parse-trace = parse-input(grammar-one-input-one, action-table, goto-table)
// #draw-parse-tree(parse-trace.output.last().at(0))
// #show-parse-trace(parse-trace)
// // stack: #parse-trace.stack \
// // input: #parse-trace.input \
// // action: #parse-trace.action \
//
//
// // #get-all-first(eliminate-left-recursion(grammar-one))
// // #get-all-follow(eliminate-left-recursion(grammar-one))
// // #eliminate-left-recursion(grammar-one)
// // #eliminate-left-recursion(grammar-two)
//
// // #pagebreak()
// // #grid(
// //   columns: 3,
// //   inset: 1em,
// //   [*Grammar*], [*With _left recursion_ removed*], [*Augmented*],
// //   cfg(grammar-one), cfg(eliminate-left-recursion(grammar-one)), cfg(augment(grammar-one)),
// //
// //   cfg(grammar-two), cfg(eliminate-left-recursion(grammar-two)), cfg(augment(grammar-two)),
// //
// //   cfg(grammar-three), cfg(eliminate-left-recursion(grammar-three)), cfg(augment(grammar-three)),
// // )
//
