#import "lib.typ": *
#let __title = "Reference Tables"
#show: setup.with(
  title: __title,
  header-center: __title,
)

#title()
#metadata("title") <titlepage>
#outline()
#pagebreak()

= Trig Identities and Definitions


= Laplace Transforms

#figure(
  caption: "Laplace transforms and inverse Laplace transforms",
)[
  #table(
    columns: 2,
    stroke: none,
    table.header[$ f(t) = ilaplace(F(s)) $][$ F(s) = laplace(f(t)) $],
    table.hline(),
    [$1$], [$1 / s$],
    [$e^(a t)$], [$1 / (s - a)$],
    [$t^n, forall n in ZZ^+$], [$n! / s^(n + 1)$],
    [$t^p, p > -1$], [$Gamma(p + 1) / s^(p + 1)$],
    [$sqrt(t)$], [$sqrt(pi) / (2 s^(3 / 2))$],
    [$sin(a t)$], [$a / (s^2 + a^2)$],
    [$cos(a t)$], [$s / (s^2 + a^2)$],
    [$t sin(a t)$], [$(2 a s) / (s^2 + a^2)^2$],
    [$t cos(a t)$], [$(s^2 - a^2) / (s^2 + a^2)^2$],
    [$sinh(a t)$], [$a / (s^2 - a^2)$],
    [$cosh(a t)$], [$s / (s^2 - a^2)$],
    [$step(t - c)$], [$e^(-c s) / s$],
    [$dirac(t - c)$], [$e^(-c s)$],
    [$step(t - c) f(t - c)$], [$e^(-c s) F(s)$],
    [$step(t - c) g(t)$], [$e^(-c s) laplace(f(t + c))$],
    [$integral(f(v), 0, t, v)$], [$F(s) / s$],
    [$integral(f(t - tau) g(tau), 0, t, tau)$], [$F(s) G(s)$],
    [$f'(t)$], [$s F(s) - f(0)$],
    [$f''(t)$], [$s^2 F(s) - s f(0) - f'(0)$],
    [$f^((n))(t)$],
    [$s^n F(s) - s^(n - 1) f(0) - s^(n - 2) f'(0) ... - s f^((n - 2))(0) - f^((n - 1))(0)$],
  )
]

= Derivatives

== Trig Functions

#figure(
  caption: "Standard trig derivatives",
)[
  #table(
    columns: 2,
    stroke: none,
    table.header[$ f(x) $][$ dv()f(x) $],
    table.hline(),
    [$sin(u)$], [$cos(u) dv(u, x)$],
    [$cos(u)$], [$-sin(u) dv(u, x)$],
    [$tan(u)$], [$sec^2(u) dv(u, x)$],
    [$csc(u)$], [$-csc(u) cot(u) dv(u, x)$],
    [$sec(u)$], [$sec(u) tan(u)$],
    [$cot(u)$], [$-csc^2(u) dv(u, x)$],
  )
]

#figure(
  caption: "Hyperbolic trig derivatives",
)[
  #table(
    columns: 2,
    stroke: none,
    table.header[$ f(x) $][$ dv()f(x) $],
    table.hline(),
    [$sinh(u)$], [$cosh(u) dv(u, x)$],
    [$cosh(u)$], [$sinh(u) dv(u, x)$],
    [$tanh(u)$], [$sech^2(u) dv(u, x)$],
    [$csch(u)$], [$-csch(u) coth(u) dv(u, x)$],
    [$sech(u)$], [$-sech(u) tanh(u) dv(u, x)$],
    [$coth(u)$], [$-csch^2(u) dv(u, x)$],
  )
]

#figure(
  caption: "Inverse trig derivatives",
)[
  #table(
    columns: 2,
    stroke: none,
    table.header[$ f(x) $][$ dv()f(x) $],
    table.hline(),
    [$arcsin(u)$], [$1 / sqrt(1 - u^2) dv(u, x), abs(u) < 1$],
    [$arccos(u)$], [$(-1) / sqrt(1 - u^2) dv(u, x), abs(u) < 1$],
    [$arctan(u)$], [$1 / (1 + u^2) dv(u, x)$],
    [$arccsc(u)$], [$(-1) / (abs(u) sqrt(u^2 - 1)) dv(u, x), abs(u) > 1$],
    [$arcsec(u)$], [$1 / (abs(u) sqrt(u^2 - 1)) dv(u, x), abs(u) > 1$],
    [$arccot(u)$], [$(-1) / (1 + u^2) dv(u, x)$],
  )
]

#figure(
  caption: "Inverse hyperbolic trig derivatives",
)[
  #table(
    columns: 2,
    stroke: none,
    table.header[$ f(x) $][$ dv()f(x) $],
    table.hline(),
    [$arcsinh(u)$], [$1 / sqrt(1 + u^2) dv(u, x)$],
    [$arccosh(u)$], [$(-1) / sqrt(u^2 - 1) dv(u, x), u > 1$],
    [$arctanh(u)$], [$1 / (1 - u^2) dv(u, x), abs(u) < 1$],
    [$arccsch(u)$], [$(-1) / (abs(u) sqrt(1 + u^2)) dv(u, x), u != 0$],
    [$arcsech(u)$], [$(-1) / (u sqrt(1 - u^2)) dv(u, x), 0 < u < 1$],
    [$arccoth(u)$], [$1 / (1 - u^2) dv(u, x), abs(u) > 1$],
  )
]
