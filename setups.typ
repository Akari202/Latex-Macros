#import "config.typ": author

#let minimal-setup(
  title: none,
  margin: (x: 1in, y: 1in),
  landscape: false,
  bib: false,
  numbering: (equation: false, section: false),
  body,
) = {
  set document(
    title: title,
    author: author,
  )

  set page(
    paper: "us-letter",
    margin: margin,
    flipped: landscape,
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

  set math.equation(numbering: if numbering.equation {
    "(1)"
  } else {
    none
  })

  set heading(numbering: if numbering.section {
    "1.1.1"
  } else {
    none
  })

  show math.equation: set block(
    above: 1.7em,
    below: 1.7em,
  )

  show raw.where(block: false): box.with(
    fill: gray.lighten(80%),
    // inset: (x: 3pt, y: 0pt),
    inset: (x: 3pt, y: 1pt),
    // inset: (x: 5pt, y: 3pt),
    outset: (y: 3pt),
    radius: 2pt,
  )

  show raw.where(block: true): block.with(
    fill: gray.lighten(90%),
    stroke: gray,
    inset: (x: 8pt, y: 5pt),
    outset: (y: 3pt),
    radius: 2pt,
    width: 100%,
    breakable: true,
  )

  set pagebreak(
    weak: true,
  )

  set bibliography(
    style: "american-society-of-mechanical-engineers",
  )

  set table(
    stroke: none,
  )

  body

  if bib {
    bibliography("refs.bib")
  }
}

#let setup(
  title: none,
  header-center: [],
  bib: false,
  footer-right: [],
  continuing-messages: true,
  numbering: (equation: false, section: false),
  body,
) = {
  show: minimal-setup.with(title: title, bib: bib, numbering: numbering)

  // Modified and customized from one-liner
  let fit-to-width(body) = context {
    let content-size = measure(body)
    if content-size.width > 0pt {
      layout(size => {
        let ratio-x = size.width / content-size.width
        let new-text-size = 1em * ratio-x
        let clamped-text-size = calc.max(
          calc.min(
            new-text-size.to-absolute(),
            text.size,
          ),
          4pt,
        )
        set text(size: clamped-text-size)
        body
      })
    } else {
      body
    }
  }

  set page(
    header-ascent: 25%,
    footer-descent: 25%,
    header: context {
      let page-num = here().page()
      if page-num == 1 { return }

      set text(size: 10pt)
      let threshold = 0.40 * page.height

      let current-page = here().page()
      let headings-on-page = query(heading.where(level: 1)).filter(i => {
        i.location().page() == current-page
      })
      let headings-before = query(heading.where(level: 1).before(here()))

      let header-right = if headings-on-page.len() > 0 {
        let first-heading = headings-on-page.first()
        let first-position = first-heading.location().position()

        if first-position.y > threshold and headings-before.len() > 0 {
          let last-active = headings-before.filter(h => h.location().page() < current-page).last()
          if continuing-messages {
            [#last-active.body (continued)]
          } else {
            last-active.body
          }
        } else {
          first-heading.body
        }
      } else if headings-before.len() > 0 {
        if continuing-messages {
          [#headings-before.last().body (continued)]
        } else {
          headings-before.last().body
        }
      } else {
        []
      }

      grid(
        columns: (1fr, auto, 1fr),
        align(left, author), align(center, header-center), align(right, fit-to-width(header-right)),
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
      let threshold = 0.1 * page.height

      let footer-left = if continuing-messages {
        let current-page = here().page()
        let headings-next-page = query(heading.where(level: 1)).filter(i => {
          i.location().page() == current-page + 1
        })
        let headings-before = query(heading.where(level: 1).before(here()))

        let last-page = counter(page).final().first()

        if headings-before.len() > 0 and current-page < last-page {
          let last-active = headings-before.last()
          if headings-next-page.len() > 0 {
            let next-heading = headings-next-page.first()
            let next-position = next-heading.location().position()
            if next-position.y > threshold {
              fit-to-width[#last-active.body continued on next page...]
            } else {
              []
            }
          } else {
            fit-to-width[#last-active.body continued on next page...]
          }
        } else {
          []
        }
      } else {
        []
      }

      line(length: 100%, stroke: 0.4pt)
      v(-8pt)
      grid(
        columns: (3fr, 1fr, 3fr),
        align(left, footer-left),
        align(center, [#page-num]),
        align(right, fit-to-width(footer-right)),
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
  equation-numbering: false,
  body,
) = {
  show: setup.with(
    title: align(center + horizon)[#course-number \ #course \ #homework-title],
    header-center: [#course-number: #homework-title],
    numbering: (equation: equation-numbering, section: false),
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

  pagebreak()
  body
}
