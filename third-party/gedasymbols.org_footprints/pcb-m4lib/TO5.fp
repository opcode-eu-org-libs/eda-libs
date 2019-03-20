
	
	 
	 
	 
	
	Element(0x00 "bipolar transistor" "" "BC140" 110 110 0 100 0x00)
(
	Attribute("gedasymbols::url" "http://www.gedasymbols.org/footprints/m4lib/TO5.fp")

#
# The JEDEC drawing specifies a pin diameter of 16 to 21 mils
# This suggests a minimum drill size of 36 mils.  42 is a common
# standard drill (#58).  A 72 mil pad gives a 15 mil annular ring.
	Pin(100 200 72 42 "E" 0x101)
	Pin(200 300 72 42 "B" 0x01)
	Pin(300 200 72 42 "C" 0x01)

	ElementArc(200 200 150 150 0 360 10)
	ElementArc(200 200 170 170 0 360 20)
	ElementLine(65 95 35 65 20)
	ElementLine(35 65 65 35 20)
	ElementLine(65 35 95 65 20)

	Mark(100 200)
)

