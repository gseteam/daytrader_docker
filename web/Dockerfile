FROM ubuntu:16.04

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
EXPOSE 443

