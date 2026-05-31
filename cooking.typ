#import "units.typ"

#let ingredients = (
  flour: (oz-per-cup: 4.25),
)

#let format-ammount(cups: 0, tbsp: 0, tsp: 0, scale: 1) = {
  let total = (calc.round(cups * 48) + tbsp * 3 + tsp) * scale

  let whole-cups = calc.floor(total / 48)
  let remaining-tsp = calc.rem(total, 48)
  let partial-cups = if remaining-tsp >= 36 {
    remaining-tsp -= 36
    $3/4$
  } else if remaining-tsp >= 32 {
    remaining-tsp -= 32
    $2/3$
  } else if remaining-tsp >= 24 {
    remaining-tsp -= 24
    $1/2$
  } else if remaining-tsp >= 16 {
    remaining-tsp -= 16
    $1/3$
  } else if remaining-tsp >= 12 {
    remaining-tsp -= 12
    $1/4$
  }
  let cups = if whole-cups > 0 {
    $#whole-cups #partial-cups units.cup$
  } else if partial-cups != none {
    $#partial-cups units.cup$
  }

  let whole-tbsp = calc.floor(remaining-tsp / 3)
  let remaining-tsp = calc.rem(remaining-tsp, 3)
  let partial-tbsp = if remaining-tsp >= 1.5 and remaining-tsp < 2 {
    remaining-tsp -= 1.5
    $1/2$
  }
  let tbsp = if whole-tbsp > 0 {
    $#whole-tbsp #partial-tbsp units.tbsp$
  } else if partial-tbsp != none {
    $#partial-tbsp units.tbsp$
  }

  let whole-tsp = calc.floor(remaining-tsp)
  let remaining-tsp = calc.floor((remaining-tsp - whole-tsp) * 24)
  let gcd-tsp = calc.gcd(remaining-tsp, 24)
  let num-tsp = 24 / gcd-tsp
  let denom-tsp = remaining-tsp / gcd-tsp
  let partial-tsp = if denom-tsp > 0 {
    $#denom-tsp / #num-tsp$
  }
  let tsp = if whole-tsp > 0 {
    $#whole-tsp #partial-tsp units.tsp$
  } else if partial-tsp != none {
    $#partial-tsp units.tsp$
  }

  [#cups #tbsp #tsp]
}
// What makes a good recipie
//
// Enumerated steps
// Lots of tiny steps or just big ones
// level of assumed cooking knowledge
// two recipies? one "expert" and the other "novice"
// one page is best
//
// Have ingredient ammounts inline
// also at begininng for shopping list?
// temperature always at point of use
// note day before preperation
// when ingredients are used multiple times
// bowl/dish usages
// meis en plas
//
// Tasks: shopping
// verbose ingredients
//
// collect ingredients task
// dont need quantitys yet
//
// mix, need quantities
//

#let recipe(
  title: "",
  time: "",
  author: "",
  ingredients: (:),
  steps: (),
) = {
  let keywords = ("heat",)
  // show heading.where(level: 1): set text(size: 22pt)
  // show heading: set block(below: 1em)

  formatted-recipie
  [
    = #title \
    #time #if author != "" { "| By: " + author }


    #line(length: 100%, stroke: 0.4pt)

    #grid(
      columns: (3fr, 8fr),
      [
        == Ingredients
        #for (i, j) in ingredients {
          if not i in keywords [
            - #if type(j) == array {
                j.join(" + ")
              } else {
                j
              } #i
          ]
        }
      ],
      [
        == Process
        #let ingredient-counter = (:)
        #let formatted-steps = ()
        #for step in steps {
          let words = step.split(" ")
          let formatted = []

          for word in words {
            let clean-word = word.trim(",").trim(".")
            if clean-word in ingredients {
              let ammount = ingredients.at(clean-word)
              let ammount = if type(ammount) == array {
                let index = ingredient-counter.at(clean-word, default: 0)
                ingredient-counter.insert(clean-word, index + 1)
                ammount.at(index)
              } else {
                ammount
              }

              formatted += [#ammount #if not clean-word in keywords [#word ]]
            } else {
              formatted += [#word ]
            }
          }
          formatted-steps.push(formatted)
        }
        #enum(..formatted-steps)
      ],
    )
  ]

  // context {
  //   layout(size => {
  //     let recipie-size = measure(formatted-recipie, ..size)
  //     let available = measure(v(1fr), ..size)
  //     [#recipie-size #size #available]
  //     line(angle: 90deg, length: size.height)
  //     // if recipie-size.height > size.height {
  //     //   pagebreak(weak: true)
  //     //   formatted-recipie
  //     // } else {
  //     //   formatted-recipie
  //     // }
  //   })
  // }
}
