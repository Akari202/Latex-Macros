
#let author = "Akari Harada"
#let course = "ME 326"
#let title = "Fluid Dynamics"

#let sgn = $op("sgn")$
#let step(x) = $H(#x)$
#let dirac(x) = $delta(#x)$

#let dx(x) = $upright(d) #x$
#let deriv(top, bottom) = $frac(upright(d) #top, upright(d) #bottom)$
#let pderiv(top, bottom) = $frac(partial #top, partial #bottom)$
#let pderivn(n, top, bottom) = $frac(partial^#n #top, partial #bottom^#n)$
#let derivp(top, bottom, arg) = $deriv(#top, #bottom)lr((#arg))$
#let pderivp(top, bottom, arg) = $pderiv(#top, #bottom)lr((#arg))$
#let indefinteg(f, x) = $integral #f thin dx(#x)$
#let definteg(lower, upper, f, x) = $integral_#lower^#upper #f thin dx(#x)$

#let evalat(at, body) = $lr(#body |)_#at$
#let evalover(lower, upper, body) = $lr(#body |)_#lower^#upper$

#let laplace(x) = $cal(L){#x}$
#let ilaplace(x) = $cal(L)^(-1){#x}$

#let limit(var, to, body) = $lim_(#var arrow #to) lr((#body))$

#let abs(x) = $lr(|#x|)$
#let det(x) = $lr(|#x|)$

#let vel = $bold(u)$
#let gravity = $bold(g)$
#let grad = $nabla$
#let div = $nabla dot$
#let laplace_op = $nabla^2$

#let show-solutions = sys.inputs.at("solutions", default: "true") == "true"
#let is-homework = true

#let example(body) = {
  block(
    width: 100%,
    stroke: 0.5pt,
    inset: 1em,
    fill: white,
    radius: 2pt,
  )[
    #text(weight: "bold")[Example:] \
    #set text(size: 0.9em)
    #body
  ]
}

#let ilcode(it) = box(
  fill: gray.lighten(80%),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
  raw(it),
)

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
  set text(size: 0.9em, style: "italic")
  pad(x: 1em, top: 0.5em, bottom: 0.5em)[
    *Hint:* #body
  ]
}

#let homework(
  title: "",
  course-number: "",
  course: "",
  instructor: "",
  time: "",
  due-date: "",
  body,
) = {
  is-homework = true

  align(center + horizon)[
    #v(1in)
    #text(weight: "bold", size: 1.5em)[#course-number \ #course \ #title] \
    #v(0.1in)
    #text(size: 10pt)[Due on #due-date] \
    #v(0.1in)
    #text(style: "italic", size: 1.2em)[#instructor \ #time]
    #v(3in)
    #author \
    #datetime.today().display("[month repr:long] [day], [year]")
    #metadata("title") <titlepage>
  ]

  pagebreak()
  body
}

#let setup(body) = {
  set page(
    paper: "us-letter",
    margin: (x: 1in, y: 1in),
    header-ascent: 25%,
    footer-descent: 25%,
    header: context {
      let title-pages = query(selector(<titlepage>).before(here()))
      let page-num = here().page()

      if page-num == 1 and title-pages.len() > 0 { return }

      set text(size: 10pt)

      let header-center = [#course: #title]
      let header-right = []

      let current_page = here().page()

      let headings_on_page = query(heading.where(level: 1)).filter(h => (
        h.location().page() == current_page
      ))
      let before = query(heading.where(level: 1).before(here()))

      if headings_on_page.len() > 0 {
        let first_h = headings_on_page.first()
        let pos = first_h.location().position()

        let threshold = 0.40 * page.height

        if pos.y > threshold {
          if before.len() > 0 {
            let last_active = before.filter(h => h.location().page() < current_page).last()
            header-right = [#last_active.body (continued)]
          }
        } else {
          header-right = first_h.body
        }
      } else if before.len() > 0 {
        header-right = [#before.last().body (continued)]
      }

      grid(
        columns: (1fr, 1fr, 1fr),
        align(left, author), align(center, header-center), align(right, header-right),
      )
      v(-8pt)
      line(length: 100%, stroke: 0.4pt)
    },
    footer: context {
      let title-pages = query(selector(<titlepage>).before(here()))
      let page-num = here().page()

      if page-num == 1 and title-pages.len() > 0 { return }

      set text(size: 10pt)

      let footer-left = []
      if is-homework {
        let current_page = here().page()
        let next_page_headings = query(heading.where(level: 1)).filter(h => (
          h.location().page() == current_page + 1
        ))

        let before = query(heading.where(level: 1).before(here()))
        let last_page = counter(page).final().first()

        if before.len() > 0 and current_page < last_page {
          let last_active = before.last()
          let is_starting_new = false

          if next_page_headings.len() > 0 {
            let first_h_next = next_page_headings.first()
            let pos_y = first_h_next.location().position().y

            if pos_y < 40pt {
              is_starting_new = true
            }
          }

          if not is_starting_new {
            set text(size: 8pt, style: "italic")
            footer-left = [#last_active.body continued on next page...]
          }
        }
      }

      line(length: 100%, stroke: 0.4pt)
      v(-8pt)
      grid(
        columns: (1fr, 1fr, 1fr),
        align(left, footer-left), align(center, [#page-num]), align(right, []),
      )
    },
  )

  set text(
    font: "New Computer Modern",
    size: 11pt,
  )

  set par(
    leading: 1.5em,
    justify: true,
    first-line-indent: 0pt,
  )

  body
}
