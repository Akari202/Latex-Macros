#import "util.typ": get-month-day-count, pad-str, weekday-to-int
#import "../util.typ": merge-dictionaries

#let fixed-holidays = (
  January: ("01": "New Year's day", "30": "Fred Korematsu day"),
  February: ("14": "Velentine's day", "19": "Day of Remembrance"),
  March: (
    "14": (
      "Pi day",
    ),
    "15": "The Ides of March",
    "17": (
      "St Patrick's day",
    ),
    "31": "Trans day of visibility",
  ),
  April: (
    // "09": "Vimmy Ridge day",
    "15": "Tax day",
  ),
  May: (
    "04": "Star Wars day",
    "05": "Cinco de Mayo",
    "06": "Revenge of the Sixth",
  ),
  June: (
    "14": "Flag day",
    "19": "Junteenth",
    "21": "Indigeonous people's day",
    "28": "Tau day",
  ),
  July: (
    "01": (
      "Canada day",
    ),
    "04": "Independence day",
  ),
  August: (
    "03": "Provincial day",
  ),
  September: (
    "30": "National day for truth and reconciliation",
  ),
  October: (
    "31": "Halloween",
  ),
  November: (
    "11": "Veterans day",
  ),
  December: (
    "24": "Christmas eve",
    "25": "Christmas",
    "26": "Boxing day",
    "31": "New Year's eve",
  ),
)

#let nth-weekday-of-month(year, month, n, weekday) = {
  let first-weekday-of-month = int(
    datetime(year: year, month: month, day: 1).display("[weekday repr:monday]"),
  )
  1 + calc.rem(weekday-to-int(weekday) - first-weekday-of-month + 7, 7) + (n - 1) * 7
}

#let nth-to-last-weekday-of-month(year, month, n, weekday) = {
  let day-count = get-month-day-count(year, month)
  let last-weekday-of-month = int(
    datetime(year: year, month: month, day: day-count).display("[weekday repr:monday]"),
  )
  day-count - calc.rem(last-weekday-of-month - weekday-to-int(weekday) + 7, 7) - (n - 1) * 7
}

#let nth-to-last-weekday-before(year, month, n, weekday, last-day) = {
  let last-weekday = int(
    datetime(year: year, month: month, day: last-day).display("[weekday repr:monday]"),
  )
  last-day - calc.rem(last-weekday - weekday-to-int(weekday) + 7, 7) - (n - 1) * 7
}

#let moving-holidays(year) = {
  (
    March: (pad-str(nth-weekday-of-month(year, 3, 2, "Sunday")): "Daylight savings time starts"),
    May: merge-dictionaries(
      (pad-str(nth-weekday-of-month(year, 5, 2, "Sunday")): "Mother's day"),
      (pad-str(nth-to-last-weekday-of-month(year, 5, 1, "Monday")): "Memorial day"),
      (pad-str(nth-to-last-weekday-before(year, 5, 1, "Monday", 24)): "Victoria day"),
    ),
    June: (pad-str(nth-weekday-of-month(year, 6, 3, "Sunday")): "Father's day"),
    September: (pad-str(nth-weekday-of-month(year, 9, 1, "Monday")): "Labor day"),
    October: (
      pad-str(nth-weekday-of-month(year, 10, 2, "Monday")): (
        "Canadian Thanksgiving",
        "Indigeonous people's day",
        "Columbus day",
      ),
    ),
    November: merge-dictionaries(
      (pad-str(nth-weekday-of-month(year, 11, 1, "Sunday")): "Daylight savings time ends"),
      (pad-str(nth-weekday-of-month(year, 11, 4, "Thursday")): "Thanksgiving"),
      (pad-str(nth-weekday-of-month(year, 11, 4, "Thursday") + 1): "Black Friday"),
      if calc.rem(year, 2) == 0 {
        (pad-str(nth-weekday-of-month(year, 11, 1, "Monday") + 1): "Election day")
      } else {
        (:)
      },
    ),
  )
}

//   April: (
//     "03": "Good Friday",
//     "05": "Easter Sunday",
//     "06": "Easter Monday",
//   ),
//   July: (
//     "03": "Independence day (observed)",
//   ),
