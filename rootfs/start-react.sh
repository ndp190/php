#!/bin/bash
if [ ! -z "$REACT_WORKER_COUNT" ]; then
	NEWLINE=$'\n'
	react_sock="upstream reactor {${NEWLINE}"
	for ((i=1; i<=$REACT_WORKER_COUNT; i++)); do
	    react_sock+="    server unix:${REACT_WORKER_SOCK/\%s/${i}}${NEWLINE}"
	done
	react_sock+="}"
fi

if [ ! -z "$react_sock" ]; then
	echo "$react_sock"
	sed -i "s/{upstream}/${react_sock}/g" /etc/nginx/sites-available/default.conf
fi

if [ ! -z "$REACT_WORKER_COUNT" ]; then
	for ((i=1; i<=$REACT_WORKER_COUNT; i++)); do
		echo "Running" && REACT_WORKER_NUM=$i php ${APP_NAME} &
	done
fi