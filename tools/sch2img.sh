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
#
# On Debian you can install its via:
#   apt install geda-gschem ps2eps ghostscript texlive-font-utils pdf2svg inkscape poppler-utils netpbm


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
	echo "USAGE $execPath [--svg] [--pdf] [--png] [--const-size] [--svg-no-text] filename [filename [...]]"
	echo ""
	echo "For calls as sch2xxx --xxx is added by default (when xxx is svg, pdf or png)."
	echo "For other calls at least one of those option is required."
}

if [ $# -eq 0 ]; then
	printHelp
	exit 1
fi

# defaults settings ...
outModes=""
constScale="true"
textSVG="true"
tmpDir="/tmp"
runDir=$PWD

# set settings based on program name (execName) ...
execPath=$0
execName=`basename $0`
case $execName in
  "sch2svg"|"sch2svg.sh") outModes=svg ;;
  "sch2pdf"|"sch2pdf.sh") outModes=pdf ;;
  "sch2png"|"sch2png.sh") outModes=png ;;
esac

# set settings based on options ...
if ! args=`getopt -n $execPath -o h -l svg,pdf,png,const-size,svg-no-text -- "$@"`; then
	printHelp
	exit 2
fi
eval set -- "$args"

while true; do
  case $1 in
    "--svg") outModes="$outModes svg"; shift;;
    "--pdf") outModes="$outModes pdf"; shift;;
    "--png") outModes="$outModes png"; shift;;
    "--const-size") constScale="false"; shift;;
    "--svg-no-text") textSVG="false"; shift;;
    "--help"|"-h") printHelp; exit 0;;
    --) shift; break;;
  esac
done

# final check for settings ...
if [ "$outModes" = "" ]; then
	echo "You must specify output file type. See --help for details"
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
	echo '(output-color "disabled")'
	echo '(gschem-use-rc-values)'
	echo '(gschem-postscript "dummyfilename")'
	echo '(gschem-exit)'
}

# process single schematic file
proccessSchematic() {
	runDir=$1
	filePath=$2
	constScale=$3
	shift 3
	
	baseDir=`dirname ${filePath}`
	baseName=`basename ${filePath}`
	baseName="${baseName%.sch}"
	tmpFile=`mktemp "$tmpDir/sch2img.XXXXXX"`
	
	printSCM $constScale > ${tmpFile}.scm
	
	cd $runDir/$baseDir
	# this must be call in schematic file directory due to configs and symbols files which can be there
	gschem -q -o ${tmpFile}.ps -s ${tmpFile}.scm -r ${tmpFile}.rc "$baseName.sch" &> /dev/null
	
	cd $tmpDir
	#grep -v 'scale$' ${tmpFile}.ps | grep -v 'translate$' |
	#	sed 's#2 setlinecap#2 setlinecap\n0.04 0.04 scale\n-27500 -33000 translate#g' > ${tmpFile}
	# mv ${tmpFile} ${tmpFile}.ps
	
	if $constScale; then
		ps2eps -O -n -P -l -q ${tmpFile}.ps
	else
		ps2epsi ${tmpFile}.ps ${tmpFile}.eps
	fi
	epstopdf ${tmpFile}.eps* -o ${tmpFile}.pdf
	
	for mode in $@; do
		case $mode in
			"pdf")
				cp ${tmpFile}.pdf "$runDir/$baseName.pdf"
				;;
			"svg")
				if $textSVG; then
					inkscape --without-gui --file=${tmpFile}.pdf --export-plain-svg="$runDir/$baseName.svg"
				else
					pdf2svg ${tmpFile}.pdf "$runDir/$baseName.svg"
				fi
				;;
			"png")
				# convert ${tmpFile}.pdf "$runDir/$baseName.png"
				pdftoppm ${tmpFile}.pdf ${tmpFile}
				pnmtopng ${tmpFile}-*1.ppm > "$runDir/$baseName.png" 2> /dev/null
				;;
		esac
	done
	
	rm ${tmpFile}*
}

for f in "$@"; do
	proccessSchematic "$runDir" "$f" $constScale "$outModes"
done