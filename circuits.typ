// Lowercase is horizontal and uppercase is vertical
#let __all-components = (
  "o",
  "r",
  "R",
  "c",
  "C",
  "v",
  "V",
  "h",
  "H",
  "s",
  "S",
  "d",
  "D",
  "w",
  "W",
  "-",
  "|",
  "#",
  "*",
  ",",
  "&",
)

#let __no-connect = (
  "*",
  ",",
  "&",
)


#let draw-circuit(
  input-str,
  ..args,
  drawing-scale: 1,
  debug: false,
  stroke: auto,
  number-format: "a",
  scale-text: true,
) = {
  import "@preview/cetz:0.4.2"
  let positions = (
    (-1, 0),
    (1, 0),
    (0, -1),
    (0, 1),
  )
  let half-length = 0.5 * drawing-scale
  let single = input-str.len() == 1

  let lines = input-str.clusters().filter(c => c != "\r").join().split("\n")
  let part-grid = (:)
  let args = args.pos()

  for (y, line) in lines.enumerate() {
    let chars = line.clusters()
    for (x, char) in chars.enumerate() {
      if char in __all-components {
        part-grid.insert(str(x) + "," + str(-y), char)
      }
    }
  }

  // Modified and cleaned up from one-liner
  // Should probably be pulled out and re generalized
  let fit-to-width(body) = context {
    let max-text-size = text.size
    // let max-text-size = text.size * 3
    let min-text-size = 4pt

    let content-size = measure(body)
    if content-size.width > 0pt {
      // Cetz seems to have a 1cm base unit although i can't find that documented
      let ratio-x = 1.2cm / content-size.width * drawing-scale
      let ratio-y = 1cm / content-size.height * drawing-scale
      let new-text-size = 1em * calc.min(ratio-x, ratio-y)
      let clamped-text-size = calc.max(
        calc.min(
          new-text-size.to-absolute(),
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

  cetz.canvas({
    cetz.draw.set-style(stroke: (cap: "square"))
    cetz.draw.set-style(stroke: stroke)
    import cetz.draw: *

    let star_count = 0
    let label_count = 1
    let loop_count = 0
    for (coord, char) in part-grid {
      let (ix, iy) = coord.split(",").map(int)
      let (x, y) = (ix * drawing-scale, iy * drawing-scale)
      if debug {
        rect((x - half-length, y - half-length), (x + half-length, y + half-length), stroke: (
          thickness: 1pt,
          dash: "loosely-dotted",
          paint: gray,
        ))
      }
      if char == "o" {
        let radius = 0.1 * drawing-scale
        circle((x, y), radius: radius, fill: none)
        for i in positions {
          let other = part-grid.at(
            str(ix + i.at(0)) + "," + str(iy + i.at(1)),
            default: none,
          )
          if other != none and not other in __no-connect {
            line(
              (x + radius * i.at(0), y + radius * i.at(1)),
              (x + i.at(0) * half-length, y + i.at(1) * half-length),
            )
          }
        }
      } else if char == "r" {
        line(
          (x - half-length, y),
          (x - 0.3 * drawing-scale, y),
          (x - 0.2 * drawing-scale, y + 0.15 * drawing-scale),
          (x - 0.1 * drawing-scale, y - 0.15 * drawing-scale),
          (x, y + 0.15 * drawing-scale),
          (x + 0.1 * drawing-scale, y - 0.15 * drawing-scale),
          (x + 0.2 * drawing-scale, y + 0.15 * drawing-scale),
          (x + 0.3 * drawing-scale, y),
          (x + half-length, y),
        )
      } else if char == "R" {
        line(
          (x, y + half-length),
          (x, y + 0.3 * drawing-scale),
          (x + 0.15 * drawing-scale, y + 0.2 * drawing-scale),
          (x - 0.15 * drawing-scale, y + 0.1 * drawing-scale),
          (x + 0.15 * drawing-scale, y),
          (x - 0.15 * drawing-scale, y - 0.1 * drawing-scale),
          (x + 0.15 * drawing-scale, y - 0.2 * drawing-scale),
          (x, y - 0.3 * drawing-scale),
          (x, y - half-length),
        )
      } else if char == "c" {
        line((x - half-length, y), (x - 0.05 * drawing-scale, y))
        line(
          (x - 0.05 * drawing-scale, y + 0.2 * drawing-scale),
          (x - 0.05 * drawing-scale, y - 0.2 * drawing-scale),
        )
        line(
          (x + 0.05 * drawing-scale, y + 0.2 * drawing-scale),
          (x + 0.05 * drawing-scale, y - 0.2 * drawing-scale),
        )
        line((x + half-length, y), (x + 0.05 * drawing-scale, y))
      } else if char == "C" {
        line((x, y - half-length), (x, y - 0.05 * drawing-scale))
        line(
          (x + 0.2 * drawing-scale, y - 0.05 * drawing-scale),
          (x - 0.2 * drawing-scale, y - 0.05 * drawing-scale),
        )
        line(
          (x + 0.2 * drawing-scale, y + 0.05 * drawing-scale),
          (x - 0.2 * drawing-scale, y + 0.05 * drawing-scale),
        )
        line((x, y + half-length), (x, y + 0.05 * drawing-scale))
      } else if char == "h" {
        let start-x = x - 0.4 * drawing-scale
        let radius = 0.13 * drawing-scale
        line((x - half-length, y), (start-x, y))
        arc((start-x, y), start: 180deg, stop: 0deg, radius: radius)
        arc((start-x + 0.26 * drawing-scale, y), start: 180deg, stop: 0deg, radius: radius)
        arc((start-x + 0.52 * drawing-scale, y), start: 180deg, stop: 0deg, radius: radius)
        line((start-x + 0.78 * drawing-scale, y), (x + half-length, y))
      } else if char == "H" {
        let start-y = y + 0.4 * drawing-scale
        let radius = 0.13 * drawing-scale
        line((x, y + half-length), (x, start-y))
        arc((x, start-y), start: 90deg, stop: -90deg, radius: radius)
        arc((x, start-y - 0.26 * drawing-scale), start: 90deg, stop: -90deg, radius: radius)
        arc((x, start-y - 0.52 * drawing-scale), start: 90deg, stop: -90deg, radius: radius)
        line((x, start-y - 0.78 * drawing-scale), (x, y - half-length))
      } else if char == "s" {
        let radius = 0.05 * drawing-scale
        let angle = 30deg
        line((x - half-length, y), (x - 0.3 * drawing-scale, y))
        circle((x - 0.25 * drawing-scale, y), radius: radius)
        line(
          (x - 0.25 * drawing-scale + calc.cos(angle) * radius, y + calc.sin(angle) * radius),
          (
            x - 0.25 * drawing-scale + calc.cos(angle) * 0.5 * drawing-scale,
            y + calc.sin(angle) * 0.5 * drawing-scale,
          ),
        )
        circle((x + 0.25 * drawing-scale, y), radius: radius)
        line((x + half-length, y), (x + 0.3 * drawing-scale, y))
      } else if char == "S" {
        let radius = 0.05 * drawing-scale
        let angle = 30deg
        line((x, y - half-length), (x, y - 0.3 * drawing-scale))
        circle((x, y - 0.25 * drawing-scale), radius: radius)
        line(
          (x + calc.sin(angle) * radius, y - 0.25 * drawing-scale + calc.cos(angle) * radius),
          (
            x + calc.sin(angle) * 0.5 * drawing-scale,
            y - 0.25 * drawing-scale + calc.cos(angle) * 0.5 * drawing-scale,
          ),
        )
        circle((x, y + 0.25 * drawing-scale), radius: radius)
        line((x, y + half-length), (x, y + 0.3 * drawing-scale))
      } else if char == "w" {
        let radius = 0.05 * drawing-scale
        let angle = 35deg
        line((x + half-length, y), (x + 0.3 * drawing-scale, y))
        circle((x + 0.25 * drawing-scale, y), radius: radius)
        line(
          (x + 0.25 * drawing-scale - calc.cos(angle) * radius, y + calc.sin(angle) * radius),
          (
            x + 0.25 * drawing-scale - calc.cos(angle) * 0.5 * drawing-scale,
            y + calc.sin(angle) * 0.5 * drawing-scale,
          ),
        )
        circle((x, y + 0.25 * drawing-scale), radius: radius)
        line((x, y + half-length), (x, y + 0.3 * drawing-scale))
        circle((x, y - 0.25 * drawing-scale), radius: radius)
        line((x, y - half-length), (x, y - 0.3 * drawing-scale))
      } else if char == "W" {
        let radius = 0.05 * drawing-scale
        let angle = 35deg
        line((x, y + half-length), (x, y + 0.3 * drawing-scale))
        circle((x, y + 0.25 * drawing-scale), radius: radius)
        line(
          (x + calc.sin(angle) * radius, y + 0.25 * drawing-scale - calc.cos(angle) * radius),
          (
            x + calc.sin(angle) * 0.5 * drawing-scale,
            y + 0.25 * drawing-scale - calc.cos(angle) * 0.5 * drawing-scale,
          ),
        )
        circle((x + 0.25 * drawing-scale, y), radius: radius)
        line((x + half-length, y), (x + 0.3 * drawing-scale, y))
        circle((x - 0.25 * drawing-scale, y), radius: radius)
        line((x - half-length, y), (x - 0.3 * drawing-scale, y))
      } else if char == "d" {
        let radius = 0.05 * drawing-scale
        let angle = 35deg
        line((x - half-length, y), (x - 0.3 * drawing-scale, y))
        circle((x - 0.25 * drawing-scale, y), radius: radius)
        line(
          (x - 0.25 * drawing-scale + calc.cos(angle) * radius, y + calc.sin(angle) * radius),
          (
            x - 0.25 * drawing-scale + calc.cos(angle) * 0.5 * drawing-scale,
            y + calc.sin(angle) * 0.5 * drawing-scale,
          ),
        )
        circle((x, y + 0.25 * drawing-scale), radius: radius)
        line((x, y + half-length), (x, y + 0.3 * drawing-scale))
        circle((x, y - 0.25 * drawing-scale), radius: radius)
        line((x, y - half-length), (x, y - 0.3 * drawing-scale))
      } else if char == "D" {
        let radius = 0.05 * drawing-scale
        let angle = 35deg
        line((x, y - half-length), (x, y - 0.3 * drawing-scale))
        circle((x, y - 0.25 * drawing-scale), radius: radius)
        line(
          (x + calc.sin(angle) * radius, y - 0.25 * drawing-scale + calc.cos(angle) * radius),
          (
            x + calc.sin(angle) * 0.5 * drawing-scale,
            y - 0.25 * drawing-scale + calc.cos(angle) * 0.5 * drawing-scale,
          ),
        )
        circle((x + 0.25 * drawing-scale, y), radius: radius)
        line((x + half-length, y), (x + 0.3 * drawing-scale, y))
        circle((x - 0.25 * drawing-scale, y), radius: radius)
        line((x - half-length, y), (x - 0.3 * drawing-scale, y))
      } else if char == "v" {
        // https://math.stackexchange.com/questions/4235124/getting-the-most-accurate-bezier-curve-that-plots-a-sine-wave
        let w = 0.4 * drawing-scale
        let amp = 2
        let v_off = 2 * calc.sqrt(3) * (amp * w / (2 * calc.pi))
        let u_off = (8 / 3 - calc.sqrt(3)) * (w / 2)
        circle((x, y), radius: 0.4 * drawing-scale)
        bezier(
          (x - 0.2 * drawing-scale, y),
          (x + 0.2 * drawing-scale, y),
          (x - 0.2 * drawing-scale + u_off, y + v_off),
          (x + 0.2 * drawing-scale - u_off, y - v_off),
        )
        line((x - 0.4 * drawing-scale, y), (x - half-length, y))
        line((x + 0.4 * drawing-scale, y), (x + half-length, y))
      } else if char == "V" {
        // https://math.stackexchange.com/questions/4235124/getting-the-most-accurate-bezier-curve-that-plots-a-sine-wave
        let w = 0.4 * drawing-scale
        let amp = 2
        let v_off = 2 * calc.sqrt(3) * (amp * w / (2 * calc.pi))
        let u_off = (8 / 3 - calc.sqrt(3)) * (w / 2)
        circle((x, y), radius: 0.4 * drawing-scale)
        bezier(
          (x, y + 0.2 * drawing-scale),
          (x, y - 0.2 * drawing-scale),
          (x + v_off, y + 0.2 * drawing-scale - u_off),
          (x - v_off, y - 0.2 * drawing-scale + u_off),
        )
        line((x, y + 0.4 * drawing-scale), (x, y + half-length))
        line((x, y - 0.4 * drawing-scale), (x, y - half-length))
      } else if char == "&" {
        arc(
          (x + calc.sin(45deg) * half-length, y - calc.cos(45deg) * half-length),
          radius: half-length,
          start: -45deg,
          delta: 245deg,
        )
        mark(
          (x - calc.sin(45deg) * half-length, y - calc.cos(45deg) * half-length),
          -58deg,
          symbol: "stealth",
          stroke: 1pt,
        )
        content((x, y), $i_#loop_count$)
        loop_count += 1
      } else if char == "-" {
        line((x - half-length, y), (x + half-length, y))
      } else if char == "|" {
        line((x, y - half-length), (x, y + half-length))
      } else if char == "#" {
        for i in positions {
          let other = part-grid.at(
            str(ix + i.at(0)) + "," + str(iy + i.at(1)),
            default: none,
          )
          if (other != none and not other in __no-connect) or single {
            line((x + i.at(0) * half-length, y + i.at(1) * half-length), (x, y))
          }
        }
      } else if char == "*" {
        let unscaled-text = args.at(star_count, default: "*")
        content(
          (x, y),
          if scale-text { fit-to-width(unscaled-text) } else { unscaled-text },
        )
        star_count += 1
      } else if char == "," {
        content((x, y), [#numbering(number-format, label_count)])
        label_count += 1
      } else {
        content((x, y), char)
      }
    }
  })
}
