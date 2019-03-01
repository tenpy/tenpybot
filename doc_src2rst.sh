#!/bin/bash
set -e

PREFIX="$(dirname "$(readlink -f "$0")")"
LOGFILE=$PREFIX/logs/doc-src2rst-$(date "+%d").txt
TENPYDIR="$PREFIX/tenpy"
{
	source "$PREFIX/tenpybot_env/bin/activate"
	cd "$TENPYDIR"
	export PYTHONPATH="$TENPYDIR"
	echo -n "check git status before pull: " && test -z "$(git status -s)" && echo "ok"
	git pull
	echo -n "check git status after pull: " && test -z "$(git status -s)" && echo "ok"
	MSG="Documentation: make src2rst"
	cd doc
	make src2rst
	if [ -n "$(git status -s)" ]
	then
		echo "Repo changed, commit & push"
		git add reference
		git commit --author "tenpybot <tenpybot@johannes-hauschild.de>" -m "$MSG"
		git push
		echo "git push finished"
	else
		echo "Repo up to date, don't commit/push"
	fi
} &> "$LOGFILE"
