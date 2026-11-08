#import "config.typ": author, color-config, output-is-html, show-grades, show-solutions
#import "util.typ": get-now
#import "util.typ"

#let __merge-numberings(config, default: none) = {
  let new = (equation: false, section: false, grammar: false, tiered: true)

  if default != none {
    for i in default.pairs() {
      new.insert(..i)
    }
  }

  for i in config.pairs() {
    new.insert(..i)
  }
  return new
}

#let debug(body) = {
  set block(stroke: green + 0.2pt)
  set box(stroke: red + 1pt)
  show heading: it => rect(stroke: blue + 1pt, inset: 0pt, outset: 0pt, it)
  show hide: it => {
    text(fill: orange, it.body)
  }
  body
}

#let html-compat(body) = {
  context if output-is-html() {
    show line.where(length: 100%): it => html.hr()

    show math.equation: it => {
      if sys.version < version(0, 15, 0) {
        if it.block {
          html.frame(it)
        } else {
          box(html.frame(it))
        }
      } else {
        it
      }
    }

    show align: it => {
      let a = it.alignment

      let h = if a == left or a == left + top or a == left + horizon or a == left + bottom {
        "left"
      } else if a == right or a == right + top or a == right + horizon or a == right + bottom {
        "right"
      } else if a == center or a == center + top or a == center + horizon or a == center + bottom {
        "center"
      } else if a == end {
        "end"
      } else if a == start {
        "start"
      } else {
        assert(false, message: "Unknown alignment")
      }

      html.elem(
        "div",
        it.body,
        attrs: (style: "text-align: " + h + ";"),
      )
    }

    show image: it => {
      let width = if type(it.width) == relative {
        let length = it.width.length.to-absolute()
        if length == 0pt {
          (width: str(it.width.ratio / 1%) + "%")
        } else {
          (width: str((length * it.width.ratio).pt()) + "px")
        }
      } else {
        (:)
      }
      let alt-title = if it.alt != none {
        (alt: it.alt, title: it.alt)
      } else {
        (:)
      }
      html.elem(
        "img",
        attrs: (
          src: it.source,
        )
          + width
          + alt-title,
      )
    }

    show pagebreak: it => []

    //    show figure: it => {
    //      html.frame(it.body)
    //      if it.has("caption") and it.caption != none {
    //          html.elem("figcaption", it.caption.body)
    //      }
    //    }

    body
  } else {
    body
  }
}

#let minimal-setup(
  title: none,
  margin: (x: 1in, y: 1in),
  landscape: false,
  bib: false,
  placement: none,
  numbering: (:),
  slides: false,
  date: auto,
  description: none,
  ai-statement: none,
  body,
) = {
  show: html-compat

  let numbering = __merge-numberings(numbering)

  set document(
    title: title,
    description: description,
    author: author,
    date: date,
  )

  set page(
    paper: if slides { "presentation-16-9" } else { "us-letter" },
    margin: margin,
    flipped: landscape,
  )

  set text(
    font: "New Computer Modern",
    size: if slides { 22pt } else { 11pt },
  )

  set par(
    leading: 1.5em,
    spacing: 2em,
    justify: true,
    first-line-indent: 0pt,
    linebreaks: "optimized",
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

  show heading.where(level: 1): it => {
    if numbering.tiered {
      counter(figure.where(kind: "aside")).update(0)
      counter(figure.where(kind: "theorem")).update(0)
      counter(figure.where(kind: "definition")).update(0)
      counter(figure.where(kind: "formula")).update(0)
      counter(figure.where(kind: "example")).update(0)
      counter(figure.where(kind: "grammar")).update(0)
    }
    it
  }

  set enum(numbering: "1.a.i.")

  show math.equation: set block(
    above: 1.7em,
    below: 1.7em,
  )
  set math.mat(delim: "[")

  set figure(placement: placement)
  show figure.where(kind: raw): set block(breakable: true)

  show raw.where(block: true): set par(leading: 1em)
  show raw.where(block: true): set block(
    fill: gray.lighten(90%),
    stroke: gray,
    inset: (x: 8pt, y: 5pt),
    outset: (y: 3pt),
    radius: 2pt,
    width: 100%,
    breakable: true,
  )

  show raw.where(block: false): box.with(
    fill: gray.lighten(80%),
    // inset: (x: 3pt, y: 0pt),
    inset: (x: 3pt, y: 1pt),
    // inset: (x: 5pt, y: 3pt),
    outset: (y: 3pt),
    radius: 2pt,
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
    if ai-statement != none {
      [= Generative AI Statement]
      ai-statement
    }
    bibliography("refs.bib")
  } else {
    if ai-statement != none {
      [= Genderative AI Statement]
      ai-statement
    }
  }
}

#let setup(
  title: none,
  header-center: [],
  bib: false,
  margin: (x: 1in, y: 1in),
  placement: none,
  footer-right: [],
  continuing-messages: true,
  description: none,
  numbering: (:),
  show-title: false,
  title-outline: true,
  date: auto,
  ai-statement: none,
  body,
) = {
  show: minimal-setup.with(
    title: title,
    bib: bib,
    margin: margin,
    placement: placement,
    numbering: __merge-numberings(numbering),
    description: description,
    date: date,
    ai-statement: ai-statement,
  )

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
      if page-num == 1 and query(<titlepage>).len() > 0 { return }

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

  if show-title {
    [
      #metadata("title") <titlepage>
      #align(center)[#std.title()\ #author \ #(
          if date == auto {
            datetime.today()
          } else { date }.display("[month repr:long] [day], [year]")
        )]\
      #line(length: 100%)\
      #if title-outline {
        outline(depth: 2)
      }
      #pagebreak()
    ]
  }

  body
}

#let homework(
  homework-title: "Title",
  course-number: "ME 000",
  course: "Course Name",
  instructor: "Professor Placeholder",
  class-time: "",
  due-date: "",
  numbering: (:),
  bib: false,
  placement: none,
  ai-statement: none,
  grade: none,
  grade-feedback: none,
  body,
) = {
  show: setup.with(
    title: align(center + horizon)[#course-number \ #course \ #homework-title],
    header-center: [#course-number: #homework-title],
    numbering: __merge-numberings(numbering),
    bib: bib,
    placement: placement,
    description: [#course-number #course #homework-title],
    ai-statement: ai-statement,
  )

  align(center + horizon)[
    #context if grade != none and show-grades {
      v(0.2in)
      place(
        right,
        rotate(5deg, align(right)[
          #text(fill: color-config.grade, weight: "bold", size: 2em)[#grade]
          #if grade-feedback != none [
            #text(fill: color-config.grade, size: 0.9em, style: "italic")[\ #grade-feedback]
          ]
        ]),
      )
      v(0.8in)
    } else {
      v(1in)
    }
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
    #get-now().display("[month repr:long] [day], [year]")
    // #datetime.today().display("[month repr:long] [day], [year]")
    #metadata("title") <titlepage>
  ]

  pagebreak()
  body
}
