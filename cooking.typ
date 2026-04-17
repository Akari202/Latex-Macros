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
