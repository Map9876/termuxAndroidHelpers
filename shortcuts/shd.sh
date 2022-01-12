#!/bin/bash

export extra="-v 16 -y"

cd ~/Download/shrink/ || exit 1
mkdir -p 'done' 'shrunk'

ls -1 *.mp3 *.m4a 2>/dev/null | while read f; do
	echo "$f:"
	clean-audio.sh "$f" "shrunk/" </dev/null  && \
		mv "$f" "done/"
done
