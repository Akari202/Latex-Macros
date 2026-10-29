#let find-dot(item) = {
  item.at(1).position(i => { i == "." })
}

#let advance-dot(item) = {
  let dot-index = find-dot(item)
  if dot-index != none and (dot-index + 1) < item.at(1).len() {
    return (
      item.at(0),
      item.at(1).slice(0, dot-index)
        + (item.at(1).at(dot-index + 1), ".")
        + item.at(1).slice(dot-index + 2),
    )
  }
  return item
}

#let augment(grammar) = {
  let result = (:)
  if grammar.len() > 0 {
    let nonterminals = grammar.keys()
    let start = nonterminals.at(0)
    while start in nonterminals {
      start = start + "'"
    }
    result.insert(start, ((nonterminals.at(0),),))
  }
  result + grammar
}

#let eliminate-immediate-left-recursion(grammar) = {
  let result = (:)

  let is-immediate-left-recursive(name, production) = {
    for option in production {
      if option.at(0) == name {
        return true
      }
    }
    return false
  }

  for (name, production) in grammar {
    if is-immediate-left-recursive(name, production) {
      let original = ()
      let augment = ()
      let augment-name = name + "'"
      for option in production {
        if option.at(0, default: none) == name {
          augment.push(option.slice(1) + (augment-name,))
        } else {
          original.push(option + (augment-name,))
        }
      }
      result.insert(name, original)
      result.insert(augment-name, augment + ((),))
    } else {
      result.insert(name, production)
    }
  }

  result
}

#let eliminate-left-recursion(grammar) = {
  let result = (:)
  let nonterminals = grammar.keys()
  let expandable-nonterminals = ()
  for name in nonterminals {
    let production = ()
    for option in grammar.at(name) {
      let leader = option.at(0, default: none)
      if leader in expandable-nonterminals {
        let suffix = option.slice(1)
        for i in grammar.at(leader) {
          production.push(i + suffix)
        }
      } else {
        production.push(option)
      }
    }
    expandable-nonterminals.push(name)
    result += eliminate-immediate-left-recursion(({ name }: production))
  }
  result
}

