#import "keyboard-layouts.typ": (
  colemak-dh, qwerty, tarmak-dh-five, tarmak-dh-four, tarmak-dh-one, tarmak-dh-six, tarmak-dh-three,
  tarmak-dh-two,
)

#let draw-keyboard(
  keymap: qwerty,
  unit: 1cm,
  diff: none,
  hide-number-row: true,
  show-title: true,
  mark-home: true,
  style: (
    thickness: 0.5pt,
    paint: black,
  ),
) = {
  import "@preview/cetz:0.5.2"
  cetz.canvas({
    cetz.draw.set-style(stroke: style)
    import cetz.draw: *

    let ansi = (
      (13, 1.0),
      (1, 2.0),
      (1, 1.5),
      (12, 1.0),
      (1, 1.5),
      (1, 1.75),
      (11, 1.0),
      (1, 2.25),
      (1, 2.25),
      (10, 1.0),
      (1, 2.75),
      (3, 1.25),
      (1, 6.25),
      (4, 1.25),
    )

    let fit-to-width(body, width) = context {
      let max-text-size = 22pt * (unit / 1cm)
      let min-text-size = 4pt

      let content-size = measure(body)
      if content-size.width > 0pt {
        let ratio = (width * unit) / content-size.width * 0.9
        let clamped-text-size = calc.max(
          calc.min(
            ratio * text.size,
            max-text-size,
          ),
          min-text-size,
        )

        set text(size: clamped-text-size)
        body
      } else {
        body
      }
    }

    let key(width: 1, paint: style.paint, body) = {
      content(
        (rel: (0.5 * width * unit, -0.5 * unit), update: false),
        anchor: "center",
        fit-to-width(
          text(
            fill: paint,
            body,
          ),
          width,
        ),
      )
      rect((rel: (0, -unit)), (rel: (width * unit, unit)))
    }

    if show-title {
      content(
        (rel: (0.5 * 15 * unit, 0.5), update: false),
        anchor: "center",
        text(size: 22pt * (unit / 1cm), keymap.at(0)),
      )
    }

    let x-position = 0
    let index = 1
    for i in ansi {
      for _ in range(i.at(0)) {
        if not (hide-number-row and index < 15) {
          let width = i.at(1)
          let keycode = keymap.at(index)
          key(
            width: width,
            paint: if diff != none and diff.at(index) != keycode { red } else { style.paint },
            if mark-home and (index == 36 or index == 33) { underline(keycode) } else { keycode },
          )
          x-position += width
        }
        index += 1
      }
      if x-position >= 15 {
        content((rel: (-x-position * unit, -unit)), [])
        x-position = 0
      }
    }
  })
}
