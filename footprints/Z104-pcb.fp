Element["" "" "" "" 470.00mil 430.00mil 0.0000 0.0000 0 100 ""]
(
	# author: Robert Paciorek <rrp@opcode.eu.org>
	# dist-license: dual X11 or GPL
	# use-license: free/unlimited
	
	# w pionie:
	#            2.5mm  (krawędź)
	#            9.0mm  (gniazdo śruby zamykającej obudowę)
	#           66.0mm  (pełna szerokość PCB)
	#            9.0mm  (gniazdo śruby zamykającej obudowę)
	#            2.5mm  (krawędź)
	
	# pionowe - lewa strona
	ElementLine [8.5mm    0.0mm    8.5mm   11.5mm   0.4mm]
	ElementLine [0.0mm    11.5mm   0.0mm   77.5mm   0.4mm]
	ElementLine [8.5mm    77.5mm   8.5mm   89.0mm   0.4mm]
	
	# w poziomie:
	#            8.5mm  (gniazdo śruby zamykającej obudowę)
	#          116.0mm  (wycięcie na konnektory przyłączeniowe)
	#            8.5mm  (gniazdo śruby zamykającej obudowę)
	
	# poziome - góra
	ElementLine [0.0mm    11.5mm   8.5mm    11.5mm  0.4mm]
	ElementLine [8.5mm    2.5mm    124.5mm  2.5mm   0.4mm]
	ElementLine [124.5mm  11.5mm   133.0mm  11.5mm  0.4mm]
	
	# pionowe - prawa strona
	ElementLine [124.5mm  0.0mm    124.5mm  11.5mm  0.4mm]
	ElementLine [133mm    11.5mm   133.0mm  77.5mm  0.4mm]
	ElementLine [124.5mm  77.5mm   124.5mm  89.0mm  0.4mm]
	
	# poziome - dół
	ElementLine [0.0mm    77.5mm   8.5mm    77.5mm  0.4mm]
	ElementLine [8.5mm    86.5mm   124.5mm  86.5mm  0.4mm]
	ElementLine [124.5mm  77.5mm   133.0mm  77.5mm  0.4mm]
	
	# otwory montażowe PCB
	ElementArc[29mm   13mm   3.1mm 3.1mm 0 360 10.00mil]
	Pin       [29mm   13mm   4.8mm 2.0mm 50.0mil 3.1mm "" "s1" ""]
	ElementArc[103mm  13mm   3.1mm 3.1mm 0 360 10.00mil]
	Pin       [103mm  13mm   4.8mm 2.0mm 50.0mil 3.1mm "" "s2" ""]
	ElementArc[29mm   76mm   3.1mm 3.1mm 0 360 10.00mil]
	Pin       [29mm   76mm   4.8mm 2.0mm 50.0mil 3.1mm "" "s3" ""]
	ElementArc[103mm  76mm   3.1mm 3.1mm 0 360 10.00mil]
	Pin       [103mm  76mm   4.8mm 2.0mm 50.0mil 3.1mm "" "s4" ""]
	
	# limit wysokości
	ElementLine [0mm 15mm 133mm 15mm 5.00mil]
	ElementLine [0mm 74mm 133mm 74mm 5.00mil]
	ElementLine [0mm 23mm 133mm 23mm 5.00mil]
	ElementLine [0mm 66mm 133mm 66mm 5.00mil]
)
