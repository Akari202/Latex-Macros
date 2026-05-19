#import "../util.typ": merge-dictionaries

#let month-to-int(month) = {
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

#let int-to-month(month) = {
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
  months.at(month - 1, default: none)
}

#let weekday-to-int(weekday) = {
  let weekdays = (
    "monday": 1,
    "tuesday": 2,
    "wednesday": 3,
    "thursday": 4,
    "friday": 5,
    "saturday": 6,
    "sunday": 7,
  )
  weekdays.at(lower(weekday), default: none)
}

#let int-to-weekday(weekday) = {
  let weekdays = (
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  )
  weekdays.at(weekday - 1, default: none)
}

#let get-month-day-count(year, month) = {
  if month == 2 {
    if calc.rem(year, 400) == 0 {
      29
    } else if calc.rem(year, 100) == 0 {
      28
    } else if calc.rem(year, 4) == 0 {
      29
    } else {
      28
    }
  } else {
    (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31).at(month - 1)
  }
}

#let pad-str(i) = {
  if i < 10 { "0" + str(i) } else { str(i) }
}

#let add-event(events, date, name) = {
  let new-event = (
    date.display("[year]"): (
      date.display("[month repr:long]"): (
        date.display("[day]"): (name,),
      ),
    ),
  )

  return merge-dictionaries(events, new-event)
}
