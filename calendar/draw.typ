#import "util.typ": get-month-day-count, pad-str
#import "../util.typ": make-array

#let prefixes = (
  "birthday": emoji.cake,
  "flies to": emoji.airplane.takeoff,
  "fly to": emoji.airplane.takeoff,
  "drives to": emoji.car,
  "drives home": emoji.car,
  " election": emoji.ballotbox,
  "independence day": emoji.fireworks,
  "new year's": emoji.fireworks,
  "canada day": emoji.leaf.maple,
  "cinco de mayo": emoji.skull,
  "pi day": emoji.pie,
  "concert": emoji.notes.triple,
  "thanksgiving": emoji.turkey,
  "halloween": emoji.ghost,
  "st patrick's day": emoji.leaf.clover.four,
  "ides of march": emoji.knife.dagger,
  "daylight savings time": emoji.clock.three,
)


#let display-event(body) = {
  let lowercase = lower(body)

  let rect-stroke = 0.25pt + black

  if lowercase.ends-with(" middle day hidden") {
    let name = body.replace(" middle day hidden", "", count: 1).replace("_", "")
    return block(
      width: 100% + 10pt,
      inset: (y: 2pt, x: 4pt),
      outset: (left: 8pt, right: -2pt),
      stroke: (y: rect-stroke),
      hide(name),
      // name,
    )
  }

  if lowercase.ends-with(" first day") {
    let name = body.replace(" first day", "", count: 1).replace("_", "")
    return block(
      width: 100% + 5pt,
      inset: (y: 2pt, x: 4pt),
      outset: (right: 3pt),
      stroke: (y: rect-stroke, left: rect-stroke),
      name,
    )
  }

  if lowercase.ends-with(" last day") {
    let name = body.replace(" last day", "", count: 1).replace("_", "")
    return block(
      width: 100% + 5pt,
      inset: (y: 2pt, x: 4pt),
      outset: (left: 8pt),
      stroke: (y: rect-stroke, right: rect-stroke),
      align(right, name),
    )
  }

  for (pattern, prefix) in prefixes {
    if pattern in lowercase {
      return block[#prefix #body]
    }
  }

  return block(body)
}

#let month-calendar(date, events: (:)) = {
  assert(date.day() == 1, message: "Date should be the first day of the month")
  let month-name = date.display("[month repr:long]")
  let day-count = get-month-day-count(date.year(), date.month())
  let empty-leading-days = int(date.display("[weekday repr:monday]")) - 1

  let size-name(body) = layout(size => {
    context {
      let width = measure([Wednesday]).width
      let target = size.width

      let ratio = (target / width) * 100%
      scale(ratio, reflow: true, body)
    }
  })

  box(height: 100% - 1.5em, {
    block(below: 0.5em)[= #date.display("[month repr:long] [year]")]
    table(
      columns: 7,
      rows: (auto,) + (1fr,) * 6,
      stroke: (x, y) => {
        let cell-index = (y - 1) * 7 + x
        if (
          y != 0
            and (
              cell-index >= empty-leading-days and cell-index < day-count + empty-leading-days
            )
        ) {
          (thickness: 0.5pt)
        } else { none }
      },
      align: (x, y) => if y == 0 {
        center + horizon
      } else {
        top + left
      },
      table.header(
        size-name[Monday],
        size-name[Tuesday],
        size-name[Wednesday],
        size-name[Thursday],
        size-name[Friday],
        size-name[Saturday],
        size-name[Sunday],
      ),
      ..range(0, empty-leading-days).map(_ => []),
      ..range(1, day-count + 1).map(i => {
        box(inset: 1pt, width: 100%, {
          align(right, text(size: 0.8em)[#i])
          let day-events = events.at(
            pad-str(i),
            default: none,
          )
          if day-events != none {
            let day-events = make-array(day-events)
            box(
              inset: 2pt,
              for i in day-events {
                text(size: 0.7em, display-event(i))
              },
            )
          }
        })
      }),
    )
  })
}
