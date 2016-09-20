#!/bin/bash

function shut_down() {
	echo "Geronimo application shutting down..."
	exit
}
trap "shut_down" SIGKILL SIGTERM SIGHUP SIGINT EXIT

if [ "$1" = 'geronimo' ]; then

	if [ -z "$MYSQL_IP" -a -z "$MYSQL_PORT"]; then
		echo >&2 'You need to specify the location of mysql - MYSQL_IP and MYSQL_PORT.'
		exit 1
	fi
	JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
	PATH=$PATH:$HOME/bin:$JAVA_HOME/bin
	JRE_HOME=/usr/lib/jvm/java-7-openjdk-amd64/jre
	export JAVA_HOME
	export JRE_HOME
	export PATH

	# Starting geronimo...
	DAYTRADER_MYSQL_FILE=/opt/work/geronimo-tomcat7-javaee6-3.0.1/deploy/daytrader-mysql-xa-plan.xml
	sed -i 's/name="PortNumber">.*/name=\"PortNumber\">'$MYSQL_PORT'<\/config-property-setting>/g' $DAYTRADER_MYSQL_FILE
	sed -i 's/name="ServerName">.*/name=\"ServerName\">'$MYSQL_IP'<\/config-property-setting>/g' $DAYTRADER_MYSQL_FILE

	/opt/work/geronimo-tomcat7-javaee6-3.0.1/bin/geronimo start -c 
	sleep 240
	/opt/work/geronimo-tomcat7-javaee6-3.0.1/bin/deploy -u system -p manager redeploy /opt/work/geronimo-tomcat7-javaee6-3.0.1/deploy/daytrader-ear-3.0.0.ear $DAYTRADER_MYSQL_FILE

	# Let it run forever
	tail -f /dev/null

else
	exec "$@"
fi
