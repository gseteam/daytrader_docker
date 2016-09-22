DayTrader - Dockerized
======================

![Daytrader](/images/daytrader.jpg?raw=true "Daytrader")

DayTrader is benchmark application built around the paradigm of an online stock trading system.
Originally developed by IBM as the Trade Performance Benchmark Sample, DayTrader was donated to
the Apache Geronimo community in 2005. This application allows users to login, view their portfolio,
lookup stock quotes, and buy or sell stock shares. With the aid of a Web-based load driver such as
HPE LoadRunner, Rational Performance Tester, or Apache JMeter, the real-world workload provided by
DayTrader can be used to measure and compare the performance of Java Platform, Enterprise Edition
(Java EE) application servers offered by a variety of vendors.

In addition to the full workload, the application also contains a set of primitives used for functional
and performance testing of various Java EE components and common design patterns.

For more detailed information on Daytrader please refer to - http://geronimo.apache.org/GMOxDOC22/daytrader-a-more-complex-application.html

The goal of this project is to dockerize the Daytrader three-tier application. The component containers are:
  - MySQL
  - Geronimo application server
  - Apache webserver

You can optionally also have multiple web server containers sitting behind a load balancer (ha-proxy).
For now, this is beyond the scope of the current release.

### Version
1.0

### Build
The first thing we need to do is to build the application and web tier of the application. For the DB tier,
we will use the standard MySQL image that can be found at http://hub.docker.com.

#### Web Layer
```sh
$ cd web/
$ docker build -t geronimo_web .
```

#### Application Layer

```sh
$ cd appserver/
$ docker build -t geronimo_app .
```

NOTE:

If you are sitting behind corporate Proxy, you have to add proxy environment variable in both(Web layer and Application layer) Dockerfile.

Example:
ENV http_proxy=http://web-proxy.cup.hp.com:8080
ENV https_proxy=https://web-proxy.cup.hp.com:8080

### Running the Daytrader application

Running the Daytrader application is basically three steps:
  - Run the MySQL container
  - Run the Geronimo application container. Provide the MySQL IP and PORT as input when starting the container.
  - Run the Web server. Provide the Geronimo application server IP and PORT as input when starting the container.

#### Starting the MySQL container

Start the MySQL container and mount the daytrader.sql (found in the Git repository in db/ directory). This will start
a MySQL container with an empty "tradedb" database.
```sh
$ docker run -d -P -v <path to daytrader.sql>:/docker-entrypoint-initdb.d/daytrader.sql -e MYSQL_ROOT_PASSWORD=mysql mysql:latest
```

If you want to retain the MySQL DB changes even after the container is killed/removed, you can map a host directory into the container's
directory corresponding to the MySQL DB.

### Starting the Geronimo application server

When the Geronimo application server starts, it needs to know where the hostname/IP and port where MySQL is listening on.
  - MYSQL_IP - this can be host or container IP. If you are using bridge networking and give the container IP/PORT, note that both containers need to run on the same host. If you are using host IP/PORT, it doesn't matter if you are using bridge or overlay networking.
  - MYSQL_PORT - The corresponding host/container port.
```sh
$ docker run -d -P -e MYSQL_IP=<host or container hostname/IP> -e MYSQL_PORT=<host or container port> geronimo_app geronimo
```

### Starting the Geronimo web server

When the Geronimo web server starts, it needs to know where the hostname/IP and port where Geronimo application is listening on.
  - APP_IP - this can be host or container IP. If you are using bridge networking and give the container IP/PORT, note that both containers need to run on the same host. If you are using host IP/PORT, it doesn't matter if you are using bridge or overlay networking.
  - APP_PORT - The corresponding host/container port.
```sh
$ docker run -d -P -e APP_IP=<host or container hostname/IP> -e APP_PORT=<host or container port> geronimo_web webserver
```

### Accessing the application
Access the application pointing your browser to http://WEB_HOST:WEB_PORT/daytrader, where:
  - WEB_HOST is the hostname/IP of the server where the web container runs.
  - WEB_PORT is the host-port mapped to the port 80 of the web container.

### Todos

 - Multiple web servers sitting behind a load balance (ha-proxy)
 - Docker compose file (or DAB for docker 1.12) for all three containers.
