#let unit-spacing = math.thin

#let unit(body) = {
  unit-spacing
  math.upright(body)
}

// typst can only handle up to i64
#let si-prefixes = (
  "-30": (name: "quecto", prefix: "q"),
  "-27": (name: "ronto", prefix: "r"),
  "-24": (name: "yocto", prefix: "y"),
  "-21": (name: "zepto", prefix: "z"),
  "-18": (name: "atto", prefix: "a"),
  "-15": (name: "femto", prefix: "f"),
  "-12": (name: "pico", prefix: "p"),
  "-9": (name: "nano", prefix: "n"),
  "-6": (name: "micro", prefix: math.mu),
  "-3": (name: "milli", prefix: "m"),
  "-2": (name: "centi", prefix: "c"),
  "-1": (name: "deci", prefix: "d"),
  "1": (name: "deka", prefix: "da"),
  "2": (name: "hecto", prefix: "h"),
  "3": (name: "kilo", prefix: "k"),
  "6": (name: "mega", prefix: "M"),
  "9": (name: "giga", prefix: "G"),
  "12": (name: "tera", prefix: "T"),
  "15": (name: "peta", prefix: "P"),
  "18": (name: "exa", prefix: "E"),
  "21": (name: "zetta", prefix: "Z"),
  "24": (name: "yotta", prefix: "Y"),
  "27": (name: "ronna", prefix: "R"),
  "30": (name: "quetta", prefix: "Q"),
)

#let prefix(value, base-unit, partials: false, offset: 0, digits: 3) = {
  let unit = {
    show h: none
    base-unit
  }
  let exponent = calc.floor(calc.log(calc.abs(value)))
  let total-exponent = exponent + offset
  let prefix-exponent = if not partials or calc.abs(total-exponent) > 3 {
    calc.floor(total-exponent / 3) * 3
  } else {
    total-exponent
  }
  let prefix = si-prefixes.at(repr(prefix-exponent), default: none)
  if prefix == none {
    let value = calc.round(value * calc.pow(10, offset), digits: digits)
    [#value#unit-spacing#unit]
  } else {
    let value = calc.round(value * calc.pow(10, offset - prefix-exponent), digits: digits)
    [#value#unit-spacing#prefix.prefix#unit]
  }
}

// Temperature
#let celsius = unit([#{ math.degree }C])
#let degC = celsius
#let fahrenheit = unit([#{ math.degree }F])
#let degF = fahrenheit
#let kelvin = unit([K])
#let degK = kelvin
#let rankine = unit([#{ math.degree }Ra])
#let degR = rankine

// Temperature scales are any one of K, C, F, R
#let temperature(value, have, want: "F", digits: 3, just-value: false) = {
  let have = upper(have)
  let want = upper(want)

  // KCFR... where have i heard those letters before?
  // CPR is great
  let value = if have == "K" {
    value
  } else if have == "C" {
    value + 273.15
  } else if have == "F" {
    (value - 32) * 5 / 9 + 273.15
  } else if have == "R" {
    value * 5 / 9
  } else {
    return "Unknown unit: " + have
  }

  let (value, unit) = if want == "K" {
    (calc.round(value, digits: digits), kelvin)
  } else if want == "C" {
    (calc.round(value - 273.15, digits: digits), celsius)
  } else if want == "F" {
    (calc.round((value - 273.15) * 9 / 5 + 32, digits: digits), fahrenheit)
  } else if want == "R" {
    (calc.round(value * 9 / 5, digits: digits), rankine)
  } else {
    return "Unknown unit: " + want
  }

  if just-value {
    return value
  } else {
    $#value #unit$
  }
}

// Length
#let kilometer = unit([km])
#let km = kilometer
#let meter = unit([m])
#let m = meter
#let centimeter = unit([cm])
#let cm = centimeter
#let millimeter = unit([mm])
#let mm = millimeter
#let micrometer = unit($mu m$)
#let um = micrometer
#let mile = unit([mi])
#let mi = mile
#let yard = unit([yd])
#let yd = yard
#let foot = unit([ft])
#let ft = foot
#let inch = unit([in])
#let in_ = inch
#let thou = unit([thou])
#let mil = thou
#let nautical_mile = unit([nmi])
#let nmi = nautical_mile
#let cable = unit([cb])
#let cb = cable
#let fathom = unit([ftm])
#let ftm = fathom

// Area
#let square_kilometer = unit($k m^2$)
#let sq_km = square_kilometer
#let hectare = unit([ha])
#let ha = hectare
#let square_meter = unit($m^2$)
#let sq_m = square_meter
#let square_centimeter = unit($c m^2$)
#let sq_cm = square_centimeter
#let square_millimeter = unit($m m^2$)
#let sq_mm = square_millimeter
#let square_mile = unit($m i^2$)
#let sq_mi = square_mile
#let acre = unit([acre])
#let square_yard = unit($y d^2$)
#let sq_yd = square_yard
#let square_foot = unit($f t^2$)
#let sq_ft = square_foot
#let square_inch = unit($i n^2$)
#let sq_in = square_inch

// Volume
#let cubic_meter = unit($m^3$)
#let cu_m = cubic_meter
#let liter = unit([L])
#let L = liter
#let deciliter = unit([dL])
#let dL = deciliter
#let centiliter = unit([cL])
#let cL = centiliter
#let milliliter = unit([mL])
#let mL = milliliter
#let gallon = unit([gal])
#let gal = gallon
#let quart = unit([qt])
#let qt = quart
#let pint = unit([pt])
#let pt = pint
#let cup = unit([c])
#let fluid_ounce = unit([fl oz])
#let floz = fluid_ounce
#let tablespoon = unit([tbsp])
#let tbsp = tablespoon
#let teaspoon = unit([tsp])
#let tsp = teaspoon
#let bushel = unit([bu])
#let bu = bushel
#let peck = unit([pk])
#let pk = peck
#let cubic_foot = unit($f t^3$)
#let cu_ft = cubic_foot
#let cubic_inch = unit($i n^3$)
#let cu_in = cubic_inch

// Mass
#let tonne = unit([t])
#let kilogram = unit([kg])
#let kg = kilogram
#let gram = unit([g])
#let g = gram
#let milligram = unit([mg])
#let mg = milligram
#let microgram = unit($mu g$)
#let ug = microgram
#let ton = unit([tn])
#let hundredweight = unit([cwt])
#let cwt = hundredweight
#let pound = unit([lb])
#let lb = pound
#let ounce = unit([oz])
#let oz = ounce
#let dram = unit([dr])
#let dr = dram
#let grain = unit([gr])
#let gr = grain

// Speed
#let kilometers_per_hour = unit([km/h])
#let kph = kilometers_per_hour
#let meters_per_second = unit($m / s$)
#let mps = meters_per_second
#let feet_per_second = unit($(f t) / s$)
#let fps = feet_per_second
#let miles_per_hour = unit([mph])
#let mph = miles_per_hour
#let knots = unit([kt])
#let kn = knots

// Acceleration
#let meters_per_second_per_second = unit($m / s^2$)
#let mpss = meters_per_second_per_second
#let feet_per_second_per_second = unit($(f t) / s^2$)
#let fps = feet_per_second_per_second

// Pressure
#let pounds_per_square_inch = unit([psi])
#let psi = pounds_per_square_inch
#let kips_per_square_inch = unit([ksi])
#let ksi = kips_per_square_inch
#let pascal = unit([Pa])
#let Pa = pascal
#let kilopascal = unit([kPa])
#let kPa = kilopascal
#let atmosphere = unit([atm])
#let atm = atmosphere

// Force
#let kilonewton = unit([kN])
#let kN = kilonewton
#let newton = unit([N])
#let N = newton
#let kilopound = unit([kip])
#let kip = kilopound
#let pound_force = unit([lbf])
#let lbf = pound_force
#let slug = unit([slug])
#let snail = unit([snail])

// Power
#let kilowatt = unit([kW])
#let kW = kilowatt
#let watt = unit([W])
#let W = watt
#let horsepower = unit([hp])
#let hp = horsepower

// Resistance
#let megaohm = unit([M#math.Omega])
#let Mohm = megaohm
#let kiloohm = unit([k#math.Omega])
#let kohm = kiloohm
#let ohm = unit([#math.Omega])
#let ohm = ohm

// Voltage
#let volts = unit([V])
#let V = volts
#let millivolts = unit([mV])
#let mV = millivolts

// Current
#let amps = unit([A])
#let A = amps
#let milliamps = unit([mA])
#let mA = milliamps

// Capacitance
#let farad = unit([F])
#let F = farad
#let millifarad = unit([mF])
#let mF = millifarad
#let microfarad = unit([#{ math.mu }F])
#let uF = microfarad
#let nanofarad = unit([nF])
#let nF = nanofarad
#let picofarad = unit([pF])
#let pF = picofarad

// Inductance
#let henry = unit([H])
