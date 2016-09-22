FROM ubuntu:16.04

ENV http_proxy=http://web-proxy.cup.hp.com:8080
ENV https_proxy=https://web-proxy.cup.hp.com:8080

RUN apt-get update 
RUN apt-get install apache2 -y

####Install apache2 module mod-jk
RUN apt-get install libapache2-mod-jk -y

COPY workers.properties /etc/apache2/workers.properties

RUN sed -i 's/JkWorkersFile*.*/JkWorkersFile \/etc\/apache2\/workers.properties/' /etc/apache2/mods-available/jk.conf

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["webserver"]

EXPOSE 80
