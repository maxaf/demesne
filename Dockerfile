FROM debian:unstable

ARG USER

ARG UID
ARG GID

ARG DOCKER_GROUP
ARG DOCKER_GID

ENV USER=$USER
ENV HOME /home/$USER

RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y sudo apt-utils libterm-readline-gnu-perl curl docker.io \
    && apt-get autoremove \
    && apt-get autoclean

RUN getent group $GID >/dev/null || addgroup --gid $GID $USER \
    && adduser --quiet --system --home $HOME --uid $UID --gid $GID --disabled-login $USER \
    && echo $USER:password | chpasswd \
    && sudo adduser $USER sudo \
    && echo '%sudo ALL=(ALL:ALL) NOPASSWD: ALL' >/etc/sudoers.d/demesne \
    && groupmod -o -g $DOCKER_GID docker \
    && usermod -G docker,$DOCKER_GROUP -a $USER

WORKDIR $HOME
USER $USER

ENTRYPOINT ["/bin/bash"]
