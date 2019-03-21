#!/bin/bash

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

# OPTIONS
out_dir=$1
mode=1
max_rows=48
min_rows=1


if
	! test -x ${TRAGESYM:=`dirname $0`/tragesym} ||
	! ${TRAGESYM} -h | grep 'version .*rrp$' >& /dev/null;
then
	echo "set TRAGESYM environment variable to modyfied tragesym executable file path"
	echo "or put it to current TRAGESYM location: ${TRAGESYM}"
	exit
fi


if   [ $# -eq 4 ]; then
	min_rows=$4
	max_rows=$3
	mode=$2
elif [ $# -eq 3 ]; then
	max_rows=$3
	mode=$2
elif [ $# -eq 2 ]; then
	mode=$2
elif [ $# -ne 1 ]; then
	echo "Script generate connectors symbols fo gschem using tragesym"
	echo ""
	echo "USAGE: $0 output_directory_path [mode [max_rows [min_rows]]]"
	echo "       default: mode=$mode (1==one_side, 2==two_side), max_rows=$max_rows, min_rows=$min_rows"
	exit
fi


CONFIG="
[options]
wordswap=no
rotate_labels=no
sort_labels=no
generate_pinseq=yes
sym_width=$[$mode * 400]
pinwidthvertical=400
pinwidthhorizontal=400

[geda_attr]
version=20060113 1
author=Robert Paciorek <rrp@opcode.eu.org>
dist-license=dual X11 or GPL
use-license=free/unlimited
refdes=CONN?
numslots=0
"

TMPFILE=`mktemp`
mkdir -p $out_dir


for i in `seq $min_rows $max_rows`; do
	echo "$CONFIG" > $TMPFILE
	echo "footprint=connector($i, $mode, silkmark=externaly)" >> $TMPFILE
	echo "[pins]" >> $TMPFILE
	if [ $mode -eq 1 ]; then
		for j in `seq 1 $i`; do
			echo "$j		io	line	l		 \#" >> $TMPFILE
		done;
	else
		for j in `seq 1 2 $[ $i * 2]`; do
			k=$[ $j + 1 ]
			echo "$j		io	line	l		 \#" >> $TMPFILE
			echo "$k		io	line	r		 \#" >> $TMPFILE
		done;
	fi
	${TRAGESYM} $TMPFILE $out_dir/connector_${mode}x${i}.sym
done

/bin/rm $TMPFILE
