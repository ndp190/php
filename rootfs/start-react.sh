#!/bin/bash
if [ ! -z "$REACT_WORKER_COUNT" ]; then
	NEWLINE=$'\n'
	react_sock="upstream reactor {${NEWLINE}"
	for ((i=1; i<=$REACT_WORKER_COUNT; i++)); do
	    react_sock+="    server unix:${REACT_WORKER_SOCK/\%s/${i}} fail_timeout=10;${NEWLINE}"
	done
	react_sock+="}"
fi

if [ ! -z "$react_sock" ]; then
	echo "$react_sock"
        echo "$react_sock" > /tmp/default.conf
        cat /etc/nginx/sites-available/default.conf >> /tmp/default.conf
        mv /tmp/default.conf /etc/nginx/sites-available/default.conf
fi

if [ ! -z "$REACT_WORKER_COUNT" ]; then
	for ((i=1; i<=$REACT_WORKER_COUNT; i++)); do
		echo "Running worker #$i" && REACT_WORKER_NUM=$i php ${APP_NAME} &
	done
fi
