#!/bin/bash
set -e

# Vertica should be shut down properly
function shut_down() {
  echo "Shutting Down"
  gosu dbadmin /opt/vertica/bin/admintools -t stop_db -d DEFAULTDB -i
  exit
}

trap "shut_down" SIGKILL SIGTERM SIGHUP SIGINT EXIT

chown -R dbadmin:verticadba "$VERTICADATA"

ulimit -n 32768

if [ -z "$(ls -A "$VERTICADATA")" ]; then
  echo "Creating database"
  gosu dbadmin /opt/vertica/bin/admintools -t drop_db -d DEFAULTDB
  gosu dbadmin /opt/vertica/bin/admintools -t create_db -s localhost -d DEFAULTDB -c /home/dbadmin/DEFAULTDB/catalog -D /home/dbadmin/DEFAULTDB/data
else
  gosu dbadmin /opt/vertica/bin/admintools -t start_db -d DEFAULTDB -i
fi

echo "Vertica is now running"

while true; do
  sleep 1
done
