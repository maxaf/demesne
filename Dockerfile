FROM debian:unstable

ARG USER
ARG UID
ARG GID

ENV USER=$USER
ENV HOME /home/$USER

RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y sudo apt-utils libterm-readline-gnu-perl curl \
    && apt-get autoremove \
    && apt-get autoclean

RUN getent group $GID >/dev/null || addgroup --gid $GID $USER \
    && adduser --quiet --system --home $HOME --uid $UID --gid $GID --disabled-login $USER \
    && echo $USER:password | chpasswd \
    && sudo adduser $USER sudo \
    && echo '%sudo ALL=(ALL:ALL) NOPASSWD: ALL' >/etc/sudoers.d/demesne

WORKDIR $HOME
USER $USER

ENTRYPOINT ["/bin/bash"]
