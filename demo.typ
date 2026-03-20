#import "lib.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/simple-plot:0.3.0": line-plot, plot
#import "lib.typ": circuits.__all-components, circuits.draw-circuit
#import units: Mohm, degC, degF, degK, degR, kohm, mpss, ohm, prefix, rankine, volts
#import constants: g
#show: minimal-setup.with(
  title: "Demo",
  margin: (x: 0.5in, y: 0.5in),
  landscape: true,
)

#assert.eq(prefix(1234, ohm, offset: 3), prefix(1234000, ohm))
#assert.eq(prefix(1234, ohm, offset: -3), prefix(1.234, ohm))

#typst-example(
  "#table(
  columns: 7,
  ..latex-style(
    cols: \"c ||c c   c|clr|\",
    rows: \"h||hhh|\"
  ),
  ..range(1, 27).map(str)
)",
  scope: (latex-style: latex-style),
  caption: [#LaTeX inspired table styling],
)

#typst-example(
  "#draw-circuit(
  \",
o-vhcrs#
  *    |
o#####-#
,|VHCR o
 ##### ,\",
  $240#volts$,
  debug: true,
)",
  scope: (draw-circuit: draw-circuit, volts: volts),
  caption: "simple circuit diagrams",
)

#typst-example(
  "#typst-example(
  \"#prefix(6800, ohm)\",
  scope: (prefix: prefix, ohm: ohm),
  caption: \"SI prefix calculation\",
)",
  scope: (prefix: prefix, ohm: ohm, typst-example: typst-example),
  caption: "typst examples",
)

#typst-example(
  "#let value = 68
$#value #rankine = #temperature(value, \"R\", want: \"C\")$",
  scope: (temperature: temperature, rankine: rankine),
  caption: "temperature conversion",
)

#typst-example(
  "#prefix(6800, ohm)",
  scope: (prefix: prefix, ohm: ohm),
  caption: "SI prefix calculation",
)

#typst-example(
  "$#g #mpss$",
  scope: (mpss: mpss, g: g),
  caption: "units and constants",
)

#typst-example("#oeis(\"A000796\")", scope: (oeis: oeis), caption: "OEIS linking")

#typst-example(
  "#let data = ((4, 2.0), (3, 4.5), (1, 4), (-2, 7),)
#let fit = fit-monomial(data, max_degree: 3)
#figure(
  caption: fit.equation,
  plot(
    ..chart-style,
    (fn: fit.fn, stroke: green,),
    line-plot(
      data,
      stroke: red,
      mark-stroke: red,
      mark: \"*\",
    ),
  )
)",
  scope: (
    chart-style: (
      xmin: -5,
      xmax: 5,
      ymin: 0,
      ymax: 10,
      ytick-labels: none,
      xtick-labels: none,
      minor-grid-step: 5,
      show-origin: false,
    ),
    fit-monomial: fit-monomial,
    plot: plot,
    line-plot: line-plot,
  ),
  caption: "monomial curve fitting",
)

#typst-example(
  "#truth-table(
  \"not (p and q) or (p or q)\"
)",
  scope: (truth-table: truth-table),
  caption: "automatic truth table generation",
)

#typst-example(
  "#range-calendar(
  start: (year: 2020, month: \"March\"),
  events: (
    \"2020\": (
      \"March\": (
        \"03\": \"Alice's Birthday\",
        \"25\": \"Bob's Birthday (calceled)\",
        \"13\": \"Break first day\",
        \"22\": \"Break last day\",
        \"30\": \"Smash Mouth concert (still on)\",
      ),
    ),
  ),
)",
  scope: (range-calendar: range-calendar),
  caption: "simple calendars with events",
  columns: (4in, auto),
)

#typst-example(
  "#problem[
  Obtain the inverse Laplace transform of the function.
  $ F(s) = s / (s^2 + 2 s + 10) $
  #hint[
    This is TYPE–2 (the denominator has higher order polynomial then numerator; complex poles). So,
    this will typically lead to shifter cos or sin functions in time domain. Follow the example
    problem solved in the class.
  ]
  #solution[
    Using completing the square
    $ F(s) = s / ((s + 1)^2 + 9) $
    $ F(s) = (s + 1 - 1)/ ((s + 1)^2 + 3^2) $
    $ F(s) = (s + 1) / ((s + 1)^2 + 3^2) - (1) / ((s + 1)^2 + 3^2) $
    $ ilaplace(F(s) = (s + 1) / ((s + 1)^2 + 3^2) - (1) / ((s + 1)^2 + 3^2)) $
    $ boxed(f(t) = e^(-t) cos(3 t) - (e^(-t) sin(3 t)) / (3)) $
  ]
]",
  scope: (problem: problem, hint: hint, solution: solution, ilaplace: ilaplace, boxed: boxed),
  caption: "homework problems",
)
