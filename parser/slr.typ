#import "util.typ": advance-dot, find-dot

#let closure(items, grammar) = {
  let I = items
  let changed = true
  while changed {
    changed = false
    for item in I {
      let dot-index = find-dot(item)
      if dot-index != none and (dot-index + 1) < item.at(1).len() {
        let nonterminal = item.at(1).at(dot-index + 1)
        let production = grammar.at(nonterminal, default: ())
        for option in production {
          let new-item = (nonterminal, ((".",) + option))

          if new-item not in I {
            I.push(new-item)
            changed = true
          }
        }
      }
    }
  }

  return I
}


#let goto(items, symbol, grammar) = {
  let J = ()

  for item in items {
    let dot-index = find-dot(item)
    if dot-index != none and (dot-index + 1) < item.at(1).len() {
      let next = item.at(1).at(dot-index + 1)

      if next == symbol {
        J.push(advance-dot(item))
      }
    }
  }

  return closure(J, grammar)
}

#let lr-zero-items(grammar) = {
  let start = grammar.keys().at(0)
  assert(grammar.at(start).len() == 1)
  let C = (closure(((start, (".",) + grammar.at(start).at(0)),), grammar),)
  let symbols = grammar.pairs().flatten().dedup()
  let changed = true
  while changed {
    changed = false
    for I in C {
      for x in symbols {
        let goto-set = goto(I, x, grammar)
        if goto-set.len() > 0 {
          if not goto-set in C {
            C.push(goto-set)
            changed = true
          }
        }
      }
    }
  }

  return C
}

#let first(x, grammar) = {
  let nonterminals = grammar.keys()
  let first-set = ()
  if not x in nonterminals {
    first-set.push(x)
  } else {
    for option in grammar.at(x) {
      if option == () {
        first-set.push(())
      } else {
        let add-epsilon = true
        for i in option {
          let first-of-i = first(i, grammar)
          if first-of-i == ((),) {
            continue
          } else {
            first-set += first-of-i
            break
          }

          first-set.push(())
        }
      }
    }
  }
  return first-set
}

#let get-all-first(grammar) = {
  let all-first = (:)
  for x in grammar.keys() {
    all-first.insert(x, first(x, grammar))
  }
  return all-first
}

#let get-all-follow(grammar) = {
  let nonterminals = grammar.keys()
  let all-follow = (:)
  for i in nonterminals {
    all-follow.insert(i, ())
  }
  all-follow.insert(nonterminals.at(0), ("$",))
  let changed = true
  while changed {
    changed = false
    for A in nonterminals {
      for option in grammar.at(A) {
        let prev = none
        for i in option {
          if not prev == none {
            for j in first(i, grammar) {
              if not j == () {
                if not j in all-follow.at(prev) {
                  all-follow.at(prev).push(j)
                  changed = true
                }
              } else {
                for k in all-follow.at(A) {
                  if not k in all-follow.at(prev) {
                    all-follow.at(prev).push(k)
                    changed = true
                  }
                }
              }
            }
          }
          if i in nonterminals {
            prev = i
          } else {
            prev = none
          }
        }
        let last = option.last(default: none)
        if last in nonterminals {
          for k in all-follow.at(A) {
            if not k in all-follow.at(last) {
              all-follow.at(last).push(k)
              changed = true
            }
          }
        }
      }
    }
  }
  return all-follow
}


#let generate-slr-table(start, grammar) = {
  assert(grammar.at(start).len() == 1)
  let accept-state = (start, grammar.at(start).at(0) + (".",))

  let nonterminals = grammar.keys()

  let C = lr-zero-items(grammar)
  let items-len = C.len()

  let action-table = (:)
  let goto-table = (:)
  for i in grammar.pairs().flatten().dedup() + ("$",) {
    if i in nonterminals and i != start {
      goto-table.insert(i, (none,) * items-len)
    } else if i != start {
      action-table.insert(i, (none,) * items-len)
    }
  }

  let all-follow = get-all-follow(grammar)

  for (i, items) in C.enumerate() {
    for item in items {
      if item == accept-state {
        action-table.at("$").at(i) = "accept"
      } else {
        let dot-index = find-dot(item)
        if dot-index != none {
          if (dot-index + 1) < item.at(1).len() {
            let a = item.at(1).at(dot-index + 1)
            if not a in nonterminals {
              let goto-of-next = goto(items, a, grammar)
              let j = C.position(k => { k == goto-of-next })
              if not j == none {
                action-table.at(a).at(i) = ("shift", j)
              }
            }
          } else {
            for a in all-follow.at(item.at(0)) {
              let dot-removed = item
              dot-removed.at(1).pop()
              action-table.at(a).at(i) = (
                ("reduce", dot-removed)
              )
            }
          }
        }
      }
    }

    for A in nonterminals {
      let goto-of-a = goto(items, A, grammar)
      let j = C.position(k => { k == goto-of-a })
      if not j == none {
        goto-table.at(A).at(i) = j
      }
    }
  }

  return (action-table, goto-table)
}
