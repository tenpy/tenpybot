#!/bin/bash
set -e

PREFIX="$(dirname "$(readlink -f "$0")")"
LOGFILE=$PREFIX/logs/docupdate-$(date "+%d").txt
TENPYDIR="$PREFIX/tenpy"
DOCDIR="$PREFIX/tenpy.github.io"
{
	source "$PREFIX/tenpybot_env/bin/activate"
	cd "$TENPYDIR"
	export PYTHONPATH="$TENPYDIR"
	echo -n "check git status before pull: " && test -z "$(git status -s)" && echo "ok"
	git pull
	echo -n "check git status after pull: " && test -z "$(git status -s)" && echo "ok"
	COMMIT="$(git rev-parse HEAD)"
	DESCR="$(git describe)"
	MSG1="Nightly build of documentation for $DESCR"
	# URL="$(git config --get remote.origin.url)"
	MSG2="Commit $COMMIT of https://github.com/tenpy/tenpy.git"
	cd doc
	make html
	rsync -auv --delete --exclude-from="$PREFIX/exclude-docsync.txt" $TENPYDIR/doc/sphinx_build/html/ $DOCDIR
	cd "$DOCDIR"
	if [ -n "$(git status -s)" ]
	then
		echo "Documentation changed, commit & push"
		git add .
		git commit --author "tenpybot <tenpybot@johannes-hauschild.de>" -m "$MSG1" -m "$MSG2"
		git push
		echo "git push finished"
	else
		echo "Documentation up to date, don't commit/push"
	fi
} &> "$LOGFILE"
