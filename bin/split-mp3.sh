#!/bin/bash

function print_help()
{
	echo $(basename "$0") '<infile> <time> [out1 out2]'
	echo $(basename "$0") '-m <infile> <time1> [time2 time3 ...]'
}

if [ "$1" = '-h' -o -z "$1" ]; then
	print_help
	exit 1
fi

function segment_name()
{
	echo "${1%.*}_$2.${1##*.}"
}


if [ "$1" = '-m' ]; then
	shift
	in="$1"
	shift

	i=0
	begin=0
	for end in $*; do
		out=$(segment_name "$in" $i)
		ffmpeg -i "$in" -codec copy -ss "$begin" -to "$end" "${out}"

		i=$(expr $i + 1)
		begin="$end"
	done
	out=$(segment_name "$in" $i)
	ffmpeg -i "$in" -codec copy -ss "$begin" "$out"
else
	in="$1"
	st="$2"

	out1="$3"
	out2="$4"
	[ -z "${out1}" ] && out1="${in%.*}_1.${in##*.}"
	[ -z "${out2}" ] && out2="${in%.*}_2.${in##*.}"

	[ "${out1}" != '-' ] && ffmpeg -i "$in" -codec copy  -to "$st" "${out1}"
	[ "${out2}" != '-' ] && ffmpeg -i "$in" -codec copy  -ss "$st" "${out2}"

fi
