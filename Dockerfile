FROM debian:stable

ARG USER

ARG UID_ARG
ARG GID

ARG DOCKER_GROUP
ARG DOCKER_GID

ENV USER=$USER
ENV HOME /home/$USER

RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y sudo apt-utils libterm-readline-gnu-perl locales curl \
    && apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common \
    && curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce \
    && apt-get autoremove -y \
    && apt-get autoclean -y

RUN \
    dpkg-reconfigure -f noninteractive tzdata && \
    echo 'en_US.UTF-8 UTF-8' >/etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8

RUN getent group $GID >/dev/null || addgroup --gid $GID $USER
RUN groupadd -g $DOCKER_GID -o $DOCKER_GROUP || true
RUN useradd -l -r -d $HOME $UID_ARG -g $GID $USER
RUN mkdir -p $HOME && chown -R $USER $HOME
RUN echo $USER:password | chpasswd
RUN sudo adduser $USER sudo
RUN echo '%sudo ALL=(ALL:ALL) NOPASSWD: ALL' >/etc/sudoers.d/demesne
RUN groupmod -o -g $DOCKER_GID docker
RUN usermod -G docker,$DOCKER_GROUP -a $USER

WORKDIR $HOME
USER $USER

ENTRYPOINT ["/bin/bash"]
