FROM openjdk:7

RUN mkdir /opt/work
ADD geronimo-tomcat7-javaee6-3.0.1.tar /opt/work

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /opt/work

EXPOSE 8009
EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["geronimo"]

