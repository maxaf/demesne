FROM alpine:edge

ARG USER

ARG UID
ARG GID

ARG DOCKER_GROUP
ARG DOCKER_GID

ENV USER=$USER
ENV HOME /home/$USER

RUN apk --no-cache upgrade
RUN apk --no-cache add bash build-base sudo curl ca-certificates podman podman-docker buildah

ENV LANG=en_US.UTF-8

RUN getent group $GID >/dev/null || sh -x -c "addgroup --gid $GID $USER"
RUN test -n "$DOCKER_GID" && test -n "$DOCKER_GROUP" && addgroup -g $DOCKER_GID $DOCKER_GROUP || true
RUN adduser -h $HOME -u $UID -G $USER -D $USER
RUN mkdir -p $HOME && chown -R $USER $HOME
RUN echo $USER:password | chpasswd
RUN echo 'demesne ALL=(ALL:ALL) NOPASSWD: ALL' >/etc/sudoers.d/demesne

WORKDIR $HOME
USER $USER

RUN echo password | sudo -S true

ENTRYPOINT ["/bin/bash"]
