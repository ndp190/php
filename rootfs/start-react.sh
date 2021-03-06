#!/bin/bash

NEWLINE=$'\n'

if [ ! -z "$REACT_WORKER_COUNT" -a -z "$REACT_COMMAND_ONLY" ]; then
	react_sock="upstream reactor {${NEWLINE}"
	for ((i=1; i<=$REACT_WORKER_COUNT; i++)); do
	    react_sock+="    server unix:${REACT_WORKER_SOCK/\%s/${i}} fail_timeout=10;${NEWLINE}"
	done
	react_sock+="}"

	echo "$react_sock"
    echo "$react_sock" > /tmp/default.conf
    cat /etc/nginx/sites-available/default-react.conf >> /tmp/default.conf
    mv /tmp/default.conf /etc/nginx/sites-available/default.conf
fi

if [ -f /etc/supervisord.conf ]; then
	echo "Start supervisord${NEWLINE}"
	supervisord &
else
	echo "Start ReactPHP workers${NEWLINE}"
	if [ ! -z "$REACT_WORKER_COUNT" ]; then
		for ((i=1; i<=$REACT_WORKER_COUNT; i++)); do
			echo "Running worker #$i" && REACT_WORKER_NUM=$i php ${APP_NAME} &
		done
	fi
fi

if [ ! -z "$REACT_WORKER_COUNT" -a -z "$REACT_COMMAND_ONLY" ]; then
	# Wait for sock(s) to open
	echo "Sleep for 5 second(s)" && sleep 5
	for ((i=1; i<=$REACT_WORKER_COUNT; i++)); do
		echo "Set permission to sock #${i}${NEWLINE}"
        chown www-data ${REACT_WORKER_SOCK/\%s/${i}}
	done
fi

echo "Run start.sh${NEWLINE}"
/start.sh
