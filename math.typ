#let sgn = math.op("sgn")
#let d = math.dif
#let step = math.op(math.upright("H"))
#let dirac = math.op(math.delta)
#let grad = $bold(nabla)$
#let div = $bold(nabla)dot.c$
#let curl = $bold(nabla)times$
#let laplacian = $nabla^2$
#let arcsin = $op(sin^(-1))$
#let arccos = $op(cos^(-1))$
#let arctan = $op(tan^(-1))$
#let arcsec = $op(sec^(-1))$
#let arccsc = $op(csc^(-1))$
#let arccot = $op(cot^(-1))$
#let arcsinh = $op(sinh^(-1))$
#let arccosh = $op(cosh^(-1))$
#let arctanh = $op(tanh^(-1))$
#let arcsech = $op(sech^(-1))$
#let arccsch = $op(csch^(-1))$
#let arccoth = $op(coth^(-1))$

#let laplace(body) = $op(cal("L"))lr({#body})$
#let ilaplace(body) = $op(cal("L"))^(-1)lr({#body})$
#let evalat(body, at) = $lr(#body |)_#at$
#let evalover(body, from, to) = $lr(#body |)_#from^#to$
// #let det(body) = $lr(|#body|)$
// #let lim(var, to) = $op("lim", limits: #true)_(#var -> #to)$


#let __combine_var_order(var, order) = {
  let naive_result = math.attach(var, t: order)
  if type(var) != content or var.func() != math.attach {
    return naive_result
  }

  if var.has("b") and (not var.has("t")) {
    return math.attach(var.base, t: order, b: var.b)
  }

  return naive_result
}


#let derivative(..args, odr: none, d: none) = {
  let args = args.pos()
  let arg_count = args.len()
  let (f, var) = if arg_count == 0 {
    (none, $x$)
  } else if arg_count == 1 {
    (none, args.at(0))
  } else if arg_count == 2 {
    (args.at(0), args.at(1))
  } else {
    (none, none)
  }
  d = if d == none { $upright(d)$ } else { d }

  if odr == none {
    math.frac($#d#f$, $#d#var$)
  } else {
    let varorder = __combine_var_order(var, odr)
    math.frac($#d^#odr#f$, $#d#varorder$)
  }
}
#let dv = derivative

#let pderivative(f, var, odr: none, d: none) = {
  if f == [] { f = none }
  let d = if d == none { math.partial } else { d }

  if odr == none {
    math.frac($#d#f$, $#d#var$)
  } else {
    let varorder = __combine_var_order(var, odr)
    math.frac($#d^#odr#f$, $#d#varorder$)
  }
}
#let pdv = pderivative

#let integral(body, ..args) = {
  let args = args.pos()
  let arg_count = args.len()
  let var = if arg_count == 0 or arg_count == 2 {
    "x"
  } else if arg_count == 1 {
    args.at(0)
  } else if arg_count == 3 {
    args.at(2)
  }

  let integral_symbol = $std.math.integral$
  if arg_count == 3 or arg_count == 2 {
    $#integral_symbol _#args.at(0)^#args.at(1) #body thin dif #var$
  } else {
    $#integral_symbol #body thin dif #var$
  }
}
