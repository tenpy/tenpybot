#!/bin/bash
set -e

PREFIX="$(dirname "$(readlink -f "$0")")"
LOGFILE=$PREFIX/logs/autoformat-$(date "+%d").txt
TENPYDIR="$PREFIX/tenpy"
{
	source "$PREFIX/tenpybot_env/bin/activate"
	cd "$TENPYDIR"
	export PYTHONPATH="$TENPYDIR"
	echo -n "check git status before pull: " && test -z "$(git status -s)" && echo "ok"
	git pull
	echo -n "check git status after pull: " && test -z "$(git status -s)" && echo "ok"
	MSG="Autoformat with $(yapf --version) and $(docformatter --version)"
	yapf -r -i ./
	docformatter -r -i --wrap-summaries 99 --wrap-descriptions 99 ./
	if [ -n "$(git status -s)" ]
	then
		echo "Repo changed, commit & push"
		git add .
		git commit --author "tenpybot <tenpybot@johannes-hauschild.de>" -m "$MSG"
		git push
		echo "git push finished"
	else
		echo "Repo up to date, don't commit/push"
	fi
} &> "$LOGFILE"
