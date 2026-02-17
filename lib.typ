// Drawing: https://typst.app/universe/package/cetz
// Diagrams: https://typst.app/universe/package/fletcher
// Mechanical Systems: https://github.com/34j/typst-cetz-mechanical-system
// Number Formatting: https://typst.app/universe/package/zero
//
// Obsidian Formatting: https://github.com/k0src/Typsidian/

#let author = "Akari Harada"

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

// typst compile ./file.typ --input solutions=false
#let show-solutions = sys.inputs.at("solutions", default: "true") == "true"
#let color = sys.inputs.at("color", default: "false") == "true"
#let is-homework = true

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
  pad(x: 2em, top: 0.5em, bottom: 0.5em)[
    #text(size: 0.85em)[
      #emph[#strong[Hint:] #body]
    ]
  ]
}

#let example(body) = {
  block(
    width: 100%,
    stroke: 0.5pt,
    inset: 1em,
    fill: white,
    radius: 2pt,
  )[
    #text(size: 0.85em)[
      #strong[Example:] #body
    ]
  ]
}

#let minimal_setup(title: none, margin: (x: 1in, y: 1in), body) = {
  set document(
    title: title,
    author: author,
  )

  set page(
    paper: "us-letter",
    margin: margin,
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

  show heading: set block(
    above: 1.5em,
    below: 2em,
  )

  show math.equation: set block(
    above: 1.7em,
    below: 1.7em,
  )

  body
}

#let setup(title: none, header-center: [], body) = {
  show: minimal_setup.with(title: title)

  set page(
    header-ascent: 25%,
    footer-descent: 25%,
    header: context {
      let page-num = here().page()

      if page-num == 1 { return }

      set text(size: 10pt)

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

      if page-num == 1 and title-pages.len() > 0 {
        return [
          #v(-8pt)
          #align(center, [#page-num])
        ]
      }

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

  body
}

#let homework(
  homework-title: "Title",
  course-number: "ME 000",
  course: "Course Name",
  instructor: "Professor Placeholder",
  class-time: "",
  due-date: "",
  body,
) = {
  show: setup.with(
    title: align(center + horizon)[#course-number \ #course \ #homework-title],
    header-center: [#course-number: #homework-title],
  )

  align(center + horizon)[
    #v(1in)
    #title() \
    #v(0.1in)
    Due on #due-date \
    #v(0.1in)
    #emph[
      #instructor \
      #class-time
    ] \
    #v(3in)
    #strong[#author] \
    #datetime.today().display("[month repr:long] [day], [year]")
    #metadata("title") <titlepage>
  ]

  pagebreak(weak: true)
  body
}



#let calendar(year: 1970, month: 1, show_day_names: true, height: 5.25in) = {
  let month_date = datetime(
    year: year,
    month: month,
    day: 1,
  )

  let monthly_days = ()

  for day in range(0, 31) [
    #let month_accumulator = (month_date + duration(days: day))
    #if month_accumulator.month() != month {
      break
    }
    #monthly_days.push(month_accumulator)
  ]

  let first_monday = {
    int(monthly_days.first().display("[weekday repr:monday]"))
  }

  let total_cells = 42
  let used_cells = first_monday - 1 + monthly_days.len()

  let size_name(body) = layout(size => {
    context {
      let width = measure([Wednesday]).width
      let target = size.width

      let ratio = (target / width) * 100%
      scale(ratio, reflow: true, body)
    }
  })

  box(
    height: 100% - 16pt,
    stack(
      spacing: 5pt,
      dir: ttb,
      align(left)[= #month_date.display("[month repr:long]") #year],
      table(
        columns: 7,
        rows: (auto,) + (1fr,) * 6,
        stroke: (x, y) => {
          if y == 0 {
            none
          } else {
            let cell_index = (y - 1) * 7 + x
            let start = first_monday - 1
            let end = start + monthly_days.len()

            if start <= cell_index and cell_index < end {
              (thickness: 0.5pt)
            } else {
              none
            }
          }
        },
        align: (x, y) => if y == 0 {
          center + horizon
        } else {
          top + right
        },
        table.header(
          size_name[Monday],
          size_name[Tuesday],
          size_name[Wednesday],
          size_name[Thursday],
          size_name[Friday],
          size_name[Saturday],
          size_name[Sunday],
        ),
        ..range(1, first_monday).map(_ => []),
        ..monthly_days.map(day => box(
          inset: 1pt,
          text(size: height * 1.75%, day.display("[day]")),
        )),
        ..range(0, total_cells - used_cells).map(_ => []),
      ),
    ),
  )
}

#let LaTeX = {
  let A = (
    offset: (
      x: -0.33em,
      y: -0.3em,
    ),
    size: 0.7em,
  )
  let T = (
    x_offset: -0.12em,
  )
  let E = (
    x_offset: -0.2em,
    y_offset: 0.23em,
    size: 1em,
  )
  let X = (
    x_offset: -0.1em,
  )
  [L#h(A.offset.x)#text(size: A.size, baseline: A.offset.y)[A]#h(T.x_offset)T#h(E.x_offset)#text(
      size: E.size,
      baseline: E.y_offset,
    )[E]#h(X.x_offset)X]
}
