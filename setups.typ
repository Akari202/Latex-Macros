#import "config.typ": author, is-homework

#let minimal_setup(title: none, margin: (x: 1in, y: 1in), landscape: false, bib: false, body) = {
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

  show math.equation: set block(
    above: 1.7em,
    below: 1.7em,
  )

  show raw.where(block: false): box.with(
    fill: gray.lighten(75%),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
  )

  set pagebreak(
    weak: true,
  )

  set bibliography(
    style: "american-society-of-mechanical-engineers",
  )

  body

  if bib {
    bibliography("refs.bib")
  }
}

#let setup(title: none, header-center: [], bib: false, body) = {
  show: minimal_setup.with(title: title, bib: bib)

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

  pagebreak()
  body
}
