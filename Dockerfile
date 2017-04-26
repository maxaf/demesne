FROM alpine:latest

RUN apk update
RUN apk add bash git coreutils
RUN apk cache clean || true

ENTRYPOINT ["/bin/bash"]
