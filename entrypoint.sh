#!/bin/bash
set -e

bash /home/tf2/hlserver/plugins.sh

if command -v runuser >/dev/null 2>&1; then
	exec runuser -u tf2 -- /home/tf2/hlserver/tf.sh "$@"
elif command -v su >/dev/null 2>&1; then
	exec su -s /bin/sh tf2 -c "/home/tf2/hlserver/tf.sh \"$@\""
else
	exec /home/tf2/hlserver/tf.sh "$@"
fi
