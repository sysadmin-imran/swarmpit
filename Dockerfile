FROM debian:buster-slim

RUN apt-get update && \
    mkdir -p /usr/share/man/man1 && \
    apt-get install -y ca-certificates curl openjdk-11-jre-headless libjffi-java

ADD dev/script/install-docker-client.sh .
RUN bash install-docker-client.sh

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY target/swarmpit.jar /usr/src/app/

ENV JMX_PORT 9010
ENV HOST "0.0.0.0"

EXPOSE 8080 9010
CMD java \
 -Dsun.management.jmxremote.level=FINEST \
 -Dsun.management.jmxremote.handlers=java.util.logging.ConsoleHandler \
 -Djava.util.logging.ConsoleHandler.level=FINEST \
 -Dcom.sun.management.jmxremote.local.only=false \
 -Dcom.sun.management.jmxremote.ssl=false \
 -Dcom.sun.management.jmxremote.authenticate=false \
 -Dcom.sun.management.jmxremote.port=$JMX_PORT \
 -Dcom.sun.management.jmxremote.rmi.port=$JMX_PORT \
 -Dcom.sun.management.jmxremote.host=$HOST \
 -Djava.rmi.server.hostname=$HOST \
 -jar swarmpit.jar