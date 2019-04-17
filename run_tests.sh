#!/bin/bash
set -e

PREFIX="$(dirname "$(readlink -f "$0")")"
LOGFILE=$PREFIX/logs/run-tests-$(date "+%d").txt
TENPYDIR="$PREFIX/tenpy"
TENPYDIRCOMPILED="$PREFIX/tenpy"
{
	source "$PREFIX/tenpybot_env/bin/activate"
	cd "$TENPYDIR"
	echo "in $TENPYDIR"
	export PYTHONPATH="$TENPYDIR"
	echo -n "check git status before pull: " && test -z "$(git status -s)" && echo "ok"
	git pull
	echo -n "check git status after pull: " && test -z "$(git status -s)" && echo "ok"
	cd tests
	nosetests
	echo -n "check git status after tests: " && test -z "$(git status -s)" && echo "ok"
	if [ -d "$TENPYDIRCOMPILED" ]
	then
		echo "in $TENPYDIRCOMPILED"
		cd "$TENPYDIRCOMPILED"
		export PYTHONPATH="$TENPYDIR"
		echo -n "check git status before pull: " && test -z "$(git status -s)" && echo "ok"
		git pull
		echo "compile"
		bash ./compile.sh
		echo -n "check git status after pull: " && test -z "$(git status -s)" && echo "ok"
		cd tests
		nosetests
		echo -n "check git status after tests: " && test -z "$(git status -s)" && echo "ok"
	fi
} &> "$LOGFILE"
