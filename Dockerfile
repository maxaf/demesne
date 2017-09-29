FROM debian:unstable

ARG USER

ARG UID_ARG
ARG GID

ARG DOCKER_GROUP
ARG DOCKER_GID

ENV USER=$USER
ENV HOME /home/$USER

RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y sudo apt-utils libterm-readline-gnu-perl locales curl docker.io \
    && apt-get autoremove -y \
    && apt-get autoclean -y

RUN \
    dpkg-reconfigure -f noninteractive tzdata && \
    echo 'en_US.UTF-8 UTF-8' >/etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8

RUN getent group $GID >/dev/null || addgroup --gid $GID $USER \
    && adduser --quiet --system --home $HOME $UID_ARG --gid $GID --disabled-login $USER \
    && echo $USER:password | chpasswd \
    && sudo adduser $USER sudo \
    && echo '%sudo ALL=(ALL:ALL) NOPASSWD: ALL' >/etc/sudoers.d/demesne \
    && groupmod -o -g $DOCKER_GID docker \
    && usermod -G docker,$DOCKER_GROUP -a $USER

ADD .bash_env $HOME/.bash_env

WORKDIR $HOME
USER $USER

ENTRYPOINT ["/bin/bash"]
