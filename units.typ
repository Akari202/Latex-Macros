#let unit(body) = {
  math.thin
  math.upright(body)
}

// Temperature
#let degC = unit([#{ math.degree }C])
#let degF = unit([#{ math.degree }F])
#let kelvin = unit([K])
#let rankine = unit([R])

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
