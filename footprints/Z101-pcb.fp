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
	ElementLine [7.0mm    0.0mm    7.0mm   11.5mm   0.4mm]
	ElementLine [0.0mm    11.5mm   0.0mm   77.5mm   0.4mm]
	ElementLine [7.0mm    77.5mm   7.0mm   89.0mm   0.4mm]
	
	# w poziomie:
	#            7.0mm  (gniazdo śruby zamykającej obudowę)
	#           89.0mm  (wycięcie na konnektory przyłączeniowe)
	#            7.0mm  (gniazdo śruby zamykającej obudowę)
	
	# poziome - góra
	ElementLine [0.0mm    11.5mm   7.0mm    11.5mm  0.4mm]
	ElementLine [7.0mm    2.5mm    96.0mm   2.5mm   0.4mm]
	ElementLine [96.0mm   11.5mm   103.0mm  11.5mm  0.4mm]
	
	# pionowe - prawa strona
	ElementLine [96.0mm   0.0mm    96.0mm   11.5mm  0.4mm]
	ElementLine [103.0mm  11.5mm   103.0mm  77.5mm  0.4mm]
	ElementLine [96.0mm   77.5mm   96.0mm   89.0mm  0.4mm]
	
	# poziome - dół
	ElementLine [0.0mm    77.5mm   7.0mm    77.5mm  0.4mm]
	ElementLine [7.0mm    86.5mm   96.0mm   86.5mm  0.4mm]
	ElementLine [96.0mm   77.5mm   103.0mm  77.5mm  0.4mm]
	
	# otwory montażowe PCB
	ElementArc[16.0mm  19.5mm   3.1mm 3.1mm 0 360 10.00mil]
	Pin       [16.0mm  19.5mm   4.8mm 2.0mm 50.0mil 3.1mm "" "s1" ""]
	ElementArc[88.0mm  19.5mm   3.1mm 3.1mm 0 360 10.00mil]
	Pin       [88.0mm  19.5mm   4.8mm 2.0mm 50.0mil 3.1mm "" "s2" ""]
	ElementArc[16.0mm  68.5mm   3.1mm 3.1mm 0 360 10.00mil]
	Pin       [16.0mm  68.5mm   4.8mm 2.0mm 50.0mil 3.1mm "" "s3" ""]
	ElementArc[88.0mm  68.5mm   3.1mm 3.1mm 0 360 10.00mil]
	Pin       [88.0mm  68.5mm   4.8mm 2.0mm 50.0mil 3.1mm "" "s4" ""]
	
	# limit wysokości
	ElementLine [0mm 13mm 103mm 13mm 5.00mil]
	ElementLine [0mm 76mm 103mm 76mm 5.00mil]
	ElementLine [0mm 23mm 103mm 23mm 5.00mil]
	ElementLine [0mm 66mm 103mm 66mm 5.00mil]
	
	# 100mm długości płytki
	ElementLine [100mm 11.5mm 100mm 77.5mm 5.00mil]
)
