#!/bin/bash

# Convert schematic file to image. For more details see printHelp function.
#
# This script needs for PDF output:
#  - gschem (geda-gschem package)
#  - ps2eps (ps2eps package)
#  - ps2epsi (ghostscript package)
#  - epstopdf (texlive-font-utils package)
# and _additionally_ for SVG and PNG output:
#  - pdf2svg (pdf2svg package)
#  - inkscape (inkscape package)
#  - pdftoppm (poppler-utils package)
#  - pnmtopng (netpbm package)

# Copyright (c) 2003-2019 Robert Ryszard Paciorek <rrp@opcode.eu.org>
# 
# MIT License
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

printHelp() {
	echo "Convert schematic file (gEDA/gschem) to image (svg, pdf or png)"
	echo ""
	echo "USAGE $1 [--svg] [--pdf] [--png] [--dpi=val] [--output=filepath] [--const-size] [--svg-no-text] [--show-endpoints] filename [filename [...]]"
	echo ""
	echo "For calls as sch2xxx --xxx is added by default (when xxx is svg, pdf or png)."
	echo "For other calls at least one of those option (or --output with file extension) is required."
}

if [ $# -eq 0 ]; then
	printHelp "$0"
	exit 1
fi

set -e

# defaults settings ...
outModes=""
outFile=""
dpi=150
constScale="true"
textSVG="true"
showEndPoints="false"

# set settings based on program name (execName) ...
execPath=$0
execName=`basename $0`
case $execName in
  "sch2svg"|"sch2svg.sh") outModes=svg ;;
  "sch2pdf"|"sch2pdf.sh") outModes=pdf ;;
  "sch2png"|"sch2png.sh") outModes=png ;;
esac

# set settings based on options ...
if ! args=`getopt -n $execPath -o h -l svg,pdf,png,dpi:,output:,const-size,svg-no-text,show-endpoints -- "$@"`; then
	printHelp
	exit 2
fi
eval set -- "$args"

while true; do
	case $1 in
		"--svg") outModes="$outModes svg"; shift;;
		"--pdf") outModes="$outModes pdf"; shift;;
		"--png") outModes="$outModes png"; shift;;
		"--dpi") dpi=$2; shift 2;;
		"--output") outFile="$2"; shift 2;;
		"--const-size") constScale="false"; shift;;
		"--svg-no-text") textSVG="false"; shift;;
		"--show-endpoints") showEndPoints="true"; shift;;
		"--help"|"-h") printHelp; exit 0;;
		--) shift; break;;
	esac
done

if [ "$outModes" = "" ]; then
	outModes=${outFile##*.}
fi

# final check for settings ...
if [ "$outModes" = "" ]; then
	echo "You must specify output file type. See --help for details"
	exit 3;
fi

if [ "$dpi" = "" ]; then
	echo "DPI must be numeric value"
	exit 3;
fi


# print scm script for printing from gschem
printSCM() {
	if $1; then
		echo '(output-type "current window")'
		echo '(view-zoom-full)'
		echo '(paper-size 47.0 111.0)'
	else
		echo '(paper-size 3.5 9.0)'
	fi
	echo '(output-orientation "portrait")'
	if $showEndPoints; then
		echo '(output-color "disabled")'
	else
		echo '(output-color "enabled")'
		echo "(print-color-map '("
		echo '(background         "#ffffff")
			(pin                "#000000")
			(net-endpoint       "#ffffff")
			(graphic            "#000000")
			(net                "#000000")
			(attribute          "#000000")
			(logic-bubble       "#000000")
			(grid               #f)
			(detached-attribute "#000000")
			(text               "#000000")
			(bus                "#000000")
			(select             #f)
			(bounding-box       #f)
			(zoom-box           #f)
			(stroke             #f)
			(lock               "#000000")
			(output-background  "#ffffff")
			(junction           "#000000")
			(freestyle1         #f)
			(freestyle2         #f)
			(freestyle3         #f)
			(freestyle4         #f)
		))'
	fi
	echo '(gschem-use-rc-values)'
	echo '(gschem-postscript "dummyfilename")'
	echo '(gschem-exit)'
}

# process single schematic file
proccessSchematic() {(
	inputFile="$1"
	outputFile="$2"
	constScale=$3
	dpi=$4
	outModes="$5"
	
	if [ $# -lt 3 ]; then
		echo "USAGE $0 inputFile outFile true|false dpi [pdf svg png]"
	fi
	
	if [ "$outModes" = "" ]; then
		outModes=${outputFile##*.}
	fi
	
	tmpFile=`mktemp /tmp/sch2img.XXXXXX`
	
	if ! which lepton-cli > /dev/null; then
		printSCM $constScale > ${tmpFile}.scm
		
		cd "$(dirname "$inputFile")"
		# this must be call in schematic file directory due to configs and symbols files which can be there
		gschem -qp -o ${tmpFile}.ps -s ${tmpFile}.scm "$(basename "$inputFile")" &> /dev/null
		
		cd $(dirname $tmpFile)
		#grep -v 'scale$' ${tmpFile}.ps | grep -v 'translate$' |
		#	sed 's#2 setlinecap#2 setlinecap\n0.04 0.04 scale\n-27500 -33000 translate#g' > ${tmpFile}
		# mv ${tmpFile} ${tmpFile}.ps
		
		if $constScale; then
			ps2eps -O -n -P -l -q ${tmpFile}.ps
		else
			ps2epsi ${tmpFile}.ps ${tmpFile}.eps
		fi
		epstopdf ${tmpFile}.eps* -o ${tmpFile}.pdf
	else
		cd "$(dirname "$inputFile")"
		lepton-cli export --no-color -o ${tmpFile}.pdf "$(basename "$inputFile")"
	fi
	
	for mode in $outModes; do
		case $mode in
			"pdf")
				cp ${tmpFile}.pdf "${outputFile%.pdf}.pdf"
				;;
			"svg")
				if $textSVG; then
					inkscape --without-gui --file=${tmpFile}.pdf --export-plain-svg=${tmpFile}.svg
					sed -e "s#font-family:Helvetica;#font-family:'DejaVu Sans', sans-serif;#g" ${tmpFile}.svg > "${outputFile%.svg}.svg"
				else
					pdf2svg ${tmpFile}.pdf "${outputFile%.svg}.svg"
				fi
				;;
			"png")
				pdftoppm -r $dpi -png ${tmpFile}.pdf ${tmpFile}
				mv ${tmpFile}-1.png "${outputFile%.png}.png"
				;;
			*)
				echo "Unsupported output file type ($mode)" >&2
				;;
		esac
	done
	
	rm ${tmpFile}*
)}

if [ "$outFile" = "" ]; then
	for f in "$@"; do
		outFile="$PWD/$(basename "$f")"
		outFile="${outFile%.sch}"
		proccessSchematic "$f" "$outFile" $constScale $dpi "$outModes"
	done
else
	outFile=$(realpath "$outFile")
	proccessSchematic "$1" "$outFile" $constScale $dpi "$outModes"
fi
