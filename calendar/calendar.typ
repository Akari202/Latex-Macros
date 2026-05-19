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
  // let ranges = ranges.filter(i => {
  //   i.at("start", default: none) != none and i.at("end", default: none) != none
  // })
  let filtered-ranges = (:)
  for (event, range) in ranges {
    if range.at("start", default: none) != none and range.at("end", default: none) != none {
      filtered-ranges.insert(event, range)
    }
  }
  let ranges = filtered-ranges

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
) = {
  // moving-holidays(2026, 5)
  // moving-holidays(2027, 5)
  // return
  if type(start.month) == str {
    start.month = month-to-int(start.month)
  }

  let month-count = if type(end) == int {
    end
  } else {
    (end.year - start.year) * 12 + end.month - start.month + 1
  }

  let year-range = range(start.year, start.year + calc.ceil((start.month + month-count) / 12))
  let annual-events = if type(annual-events) == str {
    toml(annual-events)
  } else if type(annual-events) == array {
    merge-dictionaries(annual-events.map(i => { toml(i) }))
  } else {
    annual-events
  }
  let events = process-ranges(
    merge-dictionaries(
      if type(events) == str {
        toml(events)
      } else if type(events) == array {
        merge-dictionaries(events.map(i => { toml(i) }))
      } else {
        events
      },
      if add-holidays {
        merge-dictionaries(
          ..year-range.map(
            i => (str(i): fixed-holidays),
          ),
        )
      } else {
        (:)
      },
      merge-dictionaries(
        ..year-range.map(
          i => (str(i): annual-events),
        ),
      ),
      always-make-array: true,
    ),
  )

  for i in range(month-count) {
    let total-months = (start.month - 1) + i
    let year = int(start.year + (total-months / 12))
    let month = int(calc.rem(total-months, 12) + 1)
    month-calendar(
      datetime(year: year, month: month, day: 1),
      events: events.at(str(year), default: (:)).at(int-to-month(month), default: (:)),
    )
  }
}
