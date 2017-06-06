# -*- mode: dockerfile -*-
# vi: set ft=dockerfile :

FROM demesne

ARG SCALA_VERSION=2.12.2
ENV SCALA_HOME /usr/local/scala-${SCALA_VERSION}
ENV SBT $SCALA_HOME/bin/sbt

RUN sudo mkdir -p $SCALA_HOME

RUN sudo apt-get install -y openjdk-8-jdk-headless
RUN curl -sk https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz \
    | sudo tar zxf - -C $SCALA_HOME --strip-components=1

RUN sudo curl -sk -o $SBT https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt \
    && sudo chmod 755 $SBT

ENV PATH $SCALA_HOME/bin:$PATH

RUN mkdir -p $HOME/.sbt/0.13/plugins \
    && echo 'addSbtPlugin("io.get-coursier" % "sbt-coursier" % "1.0.0-RC3")' >$HOME/.sbt/0.13/plugins/build.sbt

ENTRYPOINT ["/bin/bash"]
