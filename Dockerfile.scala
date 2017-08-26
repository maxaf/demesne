# -*- mode: dockerfile -*-
# vi: set ft=dockerfile :

FROM demesne

ARG SCALA_VERSION=2.12.3
ENV SCALA_HOME /usr/local/scala-${SCALA_VERSION}
ENV SBT $SCALA_HOME/bin/sbt
ENV COURSIER $SCALA_HOME/bin/coursier

RUN sudo mkdir -p $SCALA_HOME

RUN sudo apt install -y openjdk-8-jdk-headless git procps xterm

RUN curl -s https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz \
    | sudo tar zxf - -C $SCALA_HOME --strip-components=1

RUN sudo curl -s -o $SBT https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt \
    && sudo chmod 755 $SBT

RUN sudo curl -sL -o $COURSIER https://git.io/vgvpD \
    && sudo chmod 755 $COURSIER

RUN \
  $COURSIER bootstrap \
    com.geirsson:scalafmt-cli_2.12:1.2.0 \
    -o /tmp/scalafmt \
    --standalone \
    --main org.scalafmt.cli.Cli \
  && sudo install -m 0755 -p /tmp/scalafmt /usr/local/bin/ \
  && rm -f /tmp/scalafmt

ENV PATH $SCALA_HOME/bin:$PATH

RUN mkdir -p $HOME/.sbt/0.13/plugins \
    && echo 'addSbtPlugin("io.get-coursier" % "sbt-coursier" % "1.0.0-RC6")' >$HOME/.sbt/0.13/plugins/build.sbt

ENTRYPOINT ["/bin/cat"]
