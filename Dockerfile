FROM debian:buster-slim

RUN apt-get update && \
    mkdir -p /usr/share/man/man1 && \
    apt-get install -y ca-certificates curl openjdk-11-jre-headless libjffi-java

ADD dev/script/install-docker-client.sh .
RUN bash install-docker-client.sh

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY target/swarmpit.jar /usr/src/app/

ENV JAVA_OPTS "-Dcom.sun.management.jmxremote.rmi.port=9090 \
               -Dcom.sun.management.jmxremote=true \
               -Dcom.sun.management.jmxremote.port=9090 \
               -Dcom.sun.management.jmxremote.ssl=false \
               -Dcom.sun.management.jmxremote.authenticate=false \
               -Dcom.sun.management.jmxremote.local.only=false \
               -Djava.rmi.server.hostname=localhost"

EXPOSE 8080 9090
CMD java $JAVA_OPTS -jar swarmpit.jar