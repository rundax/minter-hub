FROM golang:1.16.2-alpine AS go-build-env

# Set up dependencies
ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev python3 curl wget zip


## Install minimum necessary dependencies, build Cosmos SDK, remove packages
RUN apk add --no-cache $PACKAGES

ARG MINTER_HUB_TAG

WORKDIR /src

# Add source files
RUN  git clone https://github.com/MinterTeam/minter-hub.git /src
RUN git checkout $MINTER_HUB_TAG


RUN cd chain && make install
RUN cd minter-connector && make install
RUN cd oracle && make install
RUN cd keys-generator && make install


FROM rust:alpine as rust-build-env

ENV OPENSSL_STATIC=true
RUN apk add --no-cache musl-dev openssl openssl-dev

RUN apk add mc


COPY --from=go-build-env /src/ /src/

ENV RUST_BACKTRACE=full
RUN cd /src/orchestrator && cargo install --locked --path orchestrator
RUN cd /src/orchestrator && cargo install --locked --path register_delegate_keys


## Final image
#FROM alpine:latest
#
## Install ca-certificates
#RUN apk add --update ca-certificates bash
#WORKDIR /root
#
## Copy over binaries from the build-env
#COPY --from=go-build-env /go/bin/ /usr/local/bin/
#COPY --from=go-build-env /src/orchestrator/target /usr/local/bin/
#
####
#### Envs
####
#ENV MY_USER="mhub" \
#    MY_GROUP="mhub" \
#    MY_UID="1000" \
#    MY_GID="1000"
#
#####
##### User/Group
#####
#RUN set -eux \
#    && addgroup -g ${MY_GID} ${MY_GROUP} \
#    && adduser -u ${MY_UID} -G ${MY_GROUP} -s /bin/sh -D ${MY_USER}
#
#
#COPY ./docker-entrypoint.sh /docker-entrypoint.sh
#
## Must set this value for the bash shell to source
## the '/etc/bashrc' file.
## See: https://stackoverflow.com/q/29021704
#ENV BASH_ENV /etc/bashrc
#COPY data/bashrc /etc/bashrc
#
#
#RUN chmod +x /docker-entrypoint.sh
#
#
#USER mhub
#WORKDIR /home/mhub
#
#ENTRYPOINT ["/docker-entrypoint.sh"]