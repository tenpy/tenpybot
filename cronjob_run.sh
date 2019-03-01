#!/bin/bash
PREFIX="$(dirname "$(readlink -f "$0")")"
FAILURE=""
test -d "$PREFIX/logs" || export FAILURE="log directory does not exist"
# if [ -z "$FAILURE" ]
# then
#     bash "$PREFIX/autoformat.sh" || export FAILURE="autoformat.sh failed"
# fi
if [ -z "$FAILURE" ]
then
	bash "$PREFIX/doc_src2rst.sh" || export FAILURE="doc_src2rst.sh failed"
fi
if [ -z "$FAILURE" ]
then
	bash "$PREFIX/update_doc.sh" || export FAILURE="update_doc.sh failed"
fi
if [ -n "$FAILURE" ]
then
	EMAIL="$(cat "$PREFIX/my_email.txt")"
	MSG="Some error occured: ${FAILURE}"
	MSG="$MSG\nCheck the logfiles in $PREFIX/logs"
	MSG="$MSG\n\n(This message should be sent to $EMAIL)"
	echo -e "$MSG" | mail -s "tenpybot cronjob failed" "$EMAIL"
fi
