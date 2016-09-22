#!/bin/bash

function shut_down() {
	echo "Geronimo application shutting down..."
	exit
}
trap "shut_down" SIGKILL SIGTERM SIGHUP SIGINT EXIT

if [ "$1" = 'webserver' ]; then
	if [ -z "$APP_IP" -a -z "$APP_PORT" ]; then
		echo >&2 'You need to specify the location of the Geronimo application - APP_IP and APP_PORT.'
		exit 1
	fi

	sed -i "s/HOSTNAME/$APP_IP/" /etc/apache2/workers.properties
	sed -i "s/PORT/$APP_PORT/"   /etc/apache2/workers.properties

	file="/etc/apache2/sites-available/000-default.conf.orig"
	#### Back up the configuration file of Web server.
	if [ -f "$file" ]
	then
		rm -rf /etc/apache2/sites-available/000-default.conf
		cp /etc/apache2/sites-available/000-default.conf.orig /etc/apache2/sites-available/000-default.conf
	else
		cp  /etc/apache2/sites-available/000-default.conf  /etc/apache2/sites-available/000-default.conf.orig
	fi

	sed -i 's/<\/VirtualHost\>/\tJkMount \/daytrader\/* connect_geronimo\n&/' /etc/apache2/sites-available/000-default.conf
	/usr/sbin/apache2ctl -D FOREGROUND
else
	exec "$@"
fi
