#!/bin/bash
set -e

PREFIX="$(dirname "$(readlink -f "$0")")"
LOGFILE=$PREFIX/logs/check_consistency-$(date "+%d").txt
TENPYDIR="$PREFIX/tenpy"
{
	source "$PREFIX/tenpybot_env/bin/activate"
	cd "$TENPYDIR"
	export PYTHONPATH="$TENPYDIR"
	echo -n "check git status before pull: " && test -z "$(git status -s)" && echo "ok"
	git pull
	echo -n "check git status after pull: " && test -z "$(git status -s)" && echo "ok"
	FILES=($(find * -name '*.py'))  # bash array

	check_regex_esistent () {
		REGEX="$1"
		echo "check regex \"$1\""
		WITHOUT="$(grep -Le "$REGEX" "${FILES[@]}")"
		if [ -z "$WITHOUT" ]
		then
			echo "all the files have \"$REGEX\""
		else
			echo "INCONSISTENCY: regex not found in the following files:"
			echo "$WITHOUT"
			exit 1
		fi
	}
	check_regex_esistent "# Copyright 20[0-9\\-]\\+ TeNPy Developers, GNU GPLv3"

	FILES=($(find "tenpy" -name '*.py'))  # restrict to files inside tenpy/ dir

	check_regex_esistent "__all__ = \["

} &> "$LOGFILE"

# To update the copyright year, one can use the linux command
# (adjust year)
# sed -i -e 's/# Copyright 2018 TeNPy Developers, GNU GPLv3$/# Copyright 2018-2019 TeNPy Developers, GNU GPLv3/' $(find . -name "*.py*") 
# sed -i -e 's/# Copyright 20\([0-9][0-9]\)-2018 TeNPy Developers, GNU GPLv3$/# Copyright 20\1-2019 TeNPy Developers, GNU GPLv3/' $(find . -name "*.py*") 
