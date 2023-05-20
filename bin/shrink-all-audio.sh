#!/bin/bash
# clean & shring all audio recordings in directory (to somewhere else)

[ -z "$1" -o "$1" = '-h' ] && echo -e"$0 <srcdir> <dstdir>\n\tdefaults: srcdir=.; dstdir=../small" && exit 0
basedir=$(pwd)

src="$1"
out="$2"
[ -z "$src" ] && src="$basedir"
[ -z "$out" ] && out=$(dirname "$src")/$(basename "$src")-small

src=$(readlink -f "$src")
mkdir -p "${out}"
out=$(readlink -f "$out")

rm -rf "${out}/debug.txt" "${out}/success" "${out}/failed" "${out}/candidates"

get_size()
{
	ls -s "$1" | cut -d ' ' -f 1
}
size_diff()
{
	expr $(get_size "$1") - $(get_size "$2")
}

export extra=-y

cd "$src"
alist=$(mktemp)
find ./* -type d >"$alist"
albums=(); while read f;do albums+=( "$f" ); done<"$alist"
for album in "${albums[@]}"; do
	mkdir -p "${out}/${album}"
	cd "$src/$album"

	find . -maxdepth 1 -type f >"$alist"
	tracks=(); while read f;do tracks+=( "$f" ); done<"$alist"
	for track in "${tracks[@]}"; do
		ftrack="$album/$track"
		otrack="${album}/${track%.*}.mp3"
		echo -n "$ftrack:" 
		if clean-audio.sh "${track}" "${out}/${otrack}" </dev/zero &>>debug.txt; then 
			echo "$ftrack" >> "${out}/success"
			echo -e "\tsuccess"
			[ $(size_diff "${track}" "${out}/${otrack}") -gt $(($(get_size "${track}") / 10)) ] && echo "${ftrack}" >> "${out}/candidates"
		else 
			echo "$ftrack" >> "${out}/failed"
			echo -e "\tfail"
			rm -f "${out}/${otrack}"
		fi
	done
done
rm "$alist"

cd "$basedir"
