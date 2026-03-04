#let unit(body) = {
  math.thin
  math.upright(body)
}

// Temperature
#let degC = unit([#{ math.degree }C])
#let degF = unit([#{ math.degree }F])
#let kelvin = unit([K])

// Speed
#let meters_per_second = unit($m / s$)
#let mps = meters_per_second
#let feet_per_second = unit($(f t) / s$)
#let fps = feet_per_second
#let miles_per_hour = unit([mph])
#let mph = miles_per_hour

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

// Force
#let kilonewton = unit([kN])
#let kN = kilonewton
#let newton = unit([N])
#let N = newton
#let kilopound = unit([kip])
#let kip = kilopound
#let pound_force = unit([lbf])
#let lbf = pound_force

// Power
#let kilowatt = unit([kW])
#let kW = kilowatt
#let watt = unit([W])
#let W = watt
#let horsepower = unit([hp])
#let hp = horsepower


