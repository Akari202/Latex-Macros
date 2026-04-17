#let __prefixes = (
  "birthday": emoji.cake,
  "flies to": emoji.airplane.takeoff,
  "fly to": emoji.airplane.takeoff,
  "drives to": emoji.car,
  "drives home": emoji.car,
  " election": emoji.ballotbox,
  "independence day": emoji.fireworks,
  "new year's eve": emoji.fireworks,
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

#let __display_event(body) = {
  let lowercase = lower(body)

  let rect-stroke = 0.25pt + black

  if lowercase.ends-with(" middle day hidden") {
    let name = body.replace(" middle day hidden", "", count: 1).replace("__", "", count: 1)
    return block(
      width: 100% + 10pt,
      inset: (y: 2pt, x: 4pt),
      outset: (left: 8pt, right: -2pt),
      stroke: (y: rect-stroke),
      hide(name),
    )
  }

  if lowercase.ends-with(" first day") {
    let name = body.replace(" first day", "", count: 1).replace("__", "", count: 1)
    return block(
      width: 100% + 5pt,
      inset: (y: 2pt, x: 4pt),
      outset: (right: 3pt),
      stroke: (y: rect-stroke, left: rect-stroke),
      name,
    )
  }

  if lowercase.ends-with(" last day") {
    let name = body.replace(" last day", "", count: 1).replace("__", "", count: 1)
    return block(
      width: 100% + 5pt,
      inset: (y: 2pt, x: 4pt),
      outset: (left: 8pt),
      stroke: (y: rect-stroke, right: rect-stroke),
      align(right, name),
    )
  }

  for (pattern, prefix) in __prefixes {
    if pattern in lowercase {
      return block[#prefix #body]
    }
  }

  return block(body)
}

#let __month_to_int(month) = {
  let months = (
    "january": 1,
    "february": 2,
    "march": 3,
    "april": 4,
    "may": 5,
    "june": 6,
    "july": 7,
    "august": 8,
    "september": 9,
    "october": 10,
    "november": 11,
    "december": 12,
  )
  months.at(lower(month), default: none)
}

#let __int_to_month(month) = {
  let months = (
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  )

  if month >= 1 and month <= 12 {
    months.at(month - 1)
  } else {
    none
  }
}

#let __add_event(events, date, name) = {
  let year = date.display("[year]")
  let month = date.display("[month repr:long]")
  let day = date.display("[day]")

  let year_dict = events.at(year, default: (:))

  let month_dict = year_dict.at(month, default: (:))

  let day_events = month_dict.at(day, default: none)
  if day_events == none {
    day_events = name
  } else if type(day_events) == str {
    day_events = (day_events, name)
  } else {
    day_events.push(name)
  }

  month_dict.insert(day, day_events)
  year_dict.insert(month, month_dict)
  events.insert(year, year_dict)

  return events
}

#let __process_ranges(events) = {
  let ranges = (:)

  for (year, months) in events {
    for (month, days) in months {
      for (day, content) in days {
        let date = datetime(year: int(year), month: __month_to_int(month), day: int(day))
        let items = if type(content) == array { content } else { (content,) }
        let filtered_items = ()
        for item in items {
          if "first day" in item {
            let name = item.replace(" first day", "")
            ranges.insert(name, (start: date))
          } else if "last day" in item {
            let name = item.replace(" last day", "")
            if name in ranges {
              ranges.at(name).insert("end", date)
            }
          }
        }
      }
    }
  }

  // TODO: Waiting till this feature gets released. PR: 7284
  // let ranges = ranges.filter(i => {
  //   i.at("start", default: none) != none and i.at("end", default: none) != none
  // })
  let filtered_ranges = (:)
  for (event, range) in ranges {
    if range.at("start", default: none) != none and range.at("end", default: none) != none {
      filtered_ranges.insert(event, range)
    }
  }
  let ranges = filtered_ranges

  for (event, range) in ranges {
    let day_count = (range.end - range.start).days()
    for offset in std.range(1, int(day_count)) {
      let date = range.start + duration(days: offset)
      let name = "__" + event + " middle day hidden"
      events = __add_event(events, date, name)
    }
  }

  for (year, months) in events {
    for (month, days) in months {
      for (day, content) in days {
        let items = if type(content) == array { content } else { (content,) }
        let sorted_items = items.sorted(key: i => { lower(i) })
        events.at(year).at(month).at(day) = sorted_items
      }
    }
  }

  return events
}

#let month-calendar(year: 1970, month: 1, height: 5.25in, events: (:)) = {
  let month = if type(month) == str {
    __month_to_int(lower(month))
  } else {
    month
  }

  let month_date = datetime(
    year: year,
    month: month,
    day: 1,
  )
  let month_str = month_date.display("[month repr:long]")

  let events = if type(events) == str {
    __process_ranges(toml(events))
      .at(month_date.display("[year]"), default: (:))
      .at(month_str, default: (:))
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

#let range-calendar(
  start: (year: 1970, month: 1),
  end: 1,
  events: (:),
  height: 5.25in,
) = {
  if type(start.month) == str {
    start.month = __month_to_int(lower(start.month))
  }

  let events = if type(events) == str {
    __process_ranges(toml(events))
  } else {
    __process_ranges(events)
  }
  let month_count = if type(end) == int {
    end
  } else {
    (end.year - start.year) * 12 + end.month - start.month + 1
  }
  for i in range(month_count) {
    let total_months = (start.month - 1) + i
    let year = int(start.year + (total_months / 12))
    let month = int(calc.rem(total_months, 12) + 1)
    month-calendar(
      year: year,
      month: month,
      height: height,
      events: events.at(str(year), default: (:)).at(__int_to_month(month), default: (:)),
    )
  }
}
