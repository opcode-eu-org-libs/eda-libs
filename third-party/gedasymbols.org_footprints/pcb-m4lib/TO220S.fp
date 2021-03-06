
	Element(0x00 "Transistor" "" "TO220S" 50 570 1 100 0x00)
(
	Attribute("gedasymbols::url" "http://www.gedasymbols.org/footprints/m4lib/TO220S.fp")
	Pin(100 800 90 60 "1" 0x101)
	Pin(200 900 90 60 "2" 0x01)
	Pin(300 800 90 60 "3" 0x01)
		  
	# Befestigungsbohrung  
	Pin(200 130 150 130 "4" 0x01)

	# Anschlussdraehte  
	ElementLine(100 800 100 620 30)
	ElementLine(200 900 200 620 30)
	ElementLine(300 800 300 620 30)

	# Gehaeuse
	ElementLine(  0 620 400 620 20)
	ElementLine(400 620 400 245 20)
	ElementLine(400 245   0 245 20)
	ElementLine(  0 245   0 620 20)

	# Kuehlfahne mit Kerben
	ElementLine(  0 245 400 245 20)
	ElementLine(400 245 400 120 20)
	ElementLine(400 120 385 120 20)
	ElementLine(385 120 385  50 20)
	ElementLine(385  50 400  50 20)
	ElementLine(400  50 400  10 20)
	ElementLine(400  10   0  10 20)
	ElementLine(  0  10   0  50 20)
	ElementLine(  0  50  15  50 20)
	ElementLine( 15  50  15 120 20)
	ElementLine( 15 120   0 120 20)
	ElementLine(  0 120   0 245 20)

	Mark(200 800)
)

