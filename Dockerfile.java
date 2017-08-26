# -*- mode: dockerfile -*-
# vi: set ft=dockerfile :

FROM scala

RUN sudo apt install -y maven

ENTRYPOINT ["/bin/cat"]
