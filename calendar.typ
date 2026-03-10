#let __display_event(body) = {
  let lowercase = lower(body)
  if "birthday" in lowercase {
    return block[#emoji.cake #body]
  } else if "flies to" in lowercase or "fly to" in lowercase {
    return block[#emoji.airplane.takeoff #body]
  } else if "drives to" in lowercase or "drive to" in lowercase or "drive home" in lowercase {
    return block[#emoji.car #body]
  } else if "election" in lowercase {
    return block[#emoji.ballotbox #body]
  } else {
    return block(body)
  }
}

#let calendar(year: 1970, month: 1, height: 5.25in, events: (:)) = {
  let month_date = datetime(
    year: year,
    month: month,
    day: 1,
  )
  let month_str = month_date.display("[month repr:long]")

  let events = if type(events) == str {
    toml(events).at(month_date.display("[year]"), default: (:)).at(month_str, default: (:))
  } else {
    events
  }

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
      align(left)[= #month_str #year],
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
          {
            let day_str = day.display("[day]")
            let day_events = events.at(day_str, default: none)
            box(inset: 2pt, width: 100%, height: 100%)[
              #text(size: 0.8em)[#day_str]
              // #text(size: height * 1.75%)[*#day_str*]
              #if day_events != none {
                set align(left)
                set text(size: 0.7em)
                let event_type = type(day_events)
                if event_type == array {
                  for i in day_events {
                    __display_event(i)
                  }
                } else if event_type == str or event_type == content {
                  __display_event(day_events)
                }
              }
            ]
          },
        )),
        ..range(0, total_cells - used_cells).map(_ => []),
      ),
    ),
  )
}
