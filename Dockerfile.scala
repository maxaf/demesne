# -*- mode: dockerfile -*-
# vi: set ft=dockerfile :

FROM anapsix/alpine-java:8_server-jre_unlimited

RUN apk update
RUN apk add bash git coreutils curl tar
RUN apk cache clean || true

ARG SCALA_VERSION=2.12.2
ENV SCALA_HOME /usr/local/scala-${SCALA_VERSION}
ENV SBT $SCALA_HOME/bin/sbt

RUN mkdir -p $SCALA_HOME

RUN curl -sk https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz \
    | tar zxf - -C $SCALA_HOME --strip-components=1

RUN curl -sk https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt \
    >$SBT \
    && chmod 755 $SBT

ENV PATH $SCALA_HOME/bin:$PATH

ENTRYPOINT ["/bin/bash"]
