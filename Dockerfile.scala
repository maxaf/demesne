# -*- mode: dockerfile -*-
# vi: set ft=dockerfile :

FROM demesne

ARG SCALA_VERSION=2.12.2
ENV SCALA_HOME /usr/local/scala-${SCALA_VERSION}
ENV SBT $SCALA_HOME/bin/sbt
ENV COURSIER $SCALA_HOME/bin/coursier

RUN sudo mkdir -p $SCALA_HOME

RUN sudo apt install -y openjdk-8-jdk-headless git docker.io procps xterm
RUN sudo usermod -G docker -a $USER

RUN curl -s https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz \
    | sudo tar zxf - -C $SCALA_HOME --strip-components=1

RUN sudo curl -s -o $SBT https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt \
    && sudo chmod 755 $SBT

RUN sudo curl -sL -o $COURSIER https://git.io/vgvpD \
    && sudo chmod 755 $COURSIER

ENV PATH $SCALA_HOME/bin:$PATH

RUN mkdir -p $HOME/.sbt/0.13/plugins \
    && echo 'addSbtPlugin("io.get-coursier" % "sbt-coursier" % "1.0.0-RC3")' >$HOME/.sbt/0.13/plugins/build.sbt

ENV WD /usr/local/bin/wrapdocker
ENV WD_URL https://raw.githubusercontent.com/jpetazzo/dind/master/wrapdocker
RUN sudo curl -sL -o $WD $WD_URL && sudo chmod 755 $WD

ENV INTELLIJ_IDEA_URL https://download-cf.jetbrains.com/idea/ideaIC-2017.1.4-no-jdk.tar.gz
ENV INTELLIJ_IDEA_HOME $HOME/.intellij-idea-home
RUN mkdir $INTELLIJ_IDEA_HOME && \
    curl -sL $INTELLIJ_IDEA_URL | tar zvxf - -C $INTELLIJ_IDEA_HOME

ENTRYPOINT ["sudo", "/usr/local/bin/wrapdocker", "sudo", "-u", "demesne", "/bin/cat"]
