#import "util.typ": *
#import "holidays.typ": fixed-holidays, moving-holidays
#import "draw.typ": month-calendar

#let process-ranges(events) = {
  let ranges = (:)

  for (year, months) in events {
    for (month, days) in months {
      for (day, content) in days {
        let date = datetime(year: int(year), month: month-to-int(month), day: int(day))
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
  let ranges = ranges.filter(i => {
    i.at("start", default: none) != none and i.at("end", default: none) != none
  })
  // let filtered-ranges = (:)
  // for (event, range) in ranges {
  //   if range.at("start", default: none) != none and range.at("end", default: none) != none {
  //     filtered-ranges.insert(event, range)
  //   }
  // }
  // let ranges = filtered-ranges

  for (event, range) in ranges {
    let day-count = (range.end - range.start).days()
    for offset in std.range(1, int(day-count)) {
      let date = range.start + duration(days: offset)
      let name = "__" + event + " middle day hidden"
      events = add-event(events, date, name)
    }
  }

  for (year, months) in events {
    for (month, days) in months {
      for (day, content) in days {
        let items = if type(content) == array { content } else { (content,) }
        let sorted-items = items.sorted(key: i => { lower(i) })
        events.at(year).at(month).at(day) = sorted-items
      }
    }
  }

  return events
}

#let range-calendar(
  start: (year: 1970, month: 1),
  end: 1,
  events: (:),
  annual-events: (:),
  add-holidays: true,
  highlight-today: true,
) = {
  let start = parse-date(start)
  let end = if type(end) == int { add-months-to-date(start, end - 1) } else { parse-date(end) }

  let month-count = months-between(start, end)
  let year-count = years-between(start, end)

  let year-range = range(start.year, end.year + 1)

  let annual-events = parse-event-input(annual-events)
  let events = parse-event-input(events)
  let all-events = process-ranges(
    merge-dictionaries(
      events,
      ..if add-holidays {
        year-range.map(
          i => (str(i): fixed-holidays),
        )
      } else {
        ((:),)
      },
      ..if add-holidays {
        year-range.map(
          i => (str(i): moving-holidays(i)),
        )
      } else {
        ((:),)
      },
      ..year-range.map(
        i => (str(i): annual-events),
      ),
    ),
  )

  let date = start
  while date.year <= end.year and date.month <= end.month {
    month-calendar(
      date,
      events: all-events
        .at(str(date.year), default: (:))
        .at(int-to-month(date.month), default: (:)),
      highlight-today: highlight-today,
    )

    date.month += 1
    if date.month > 12 {
      date.month = 1
      date.year += 1
    }
  }
}
