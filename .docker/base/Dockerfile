FROM golang:1.16.2-buster AS go-build-env

RUN apt update && apt install -y git

WORKDIR /src

ARG MINTER_HUB_TAG

# Add source files
RUN  git clone https://github.com/MinterTeam/minter-hub.git /src
RUN git checkout $MINTER_HUB_TAG

RUN cd chain && make install
RUN cd minter-connector && make install
RUN cd oracle && make install
RUN cd keys-generator && make install


FROM rust:1.51.0-slim-buster AS rust-build-env

RUN apt-get update && apt install -y libssl-dev build-essential pkg-config

COPY --from=go-build-env /src/ /src/

RUN cd /src/orchestrator && \
    cargo install --locked --path orchestrator && \
    cargo install --locked --path register_delegate_keys

#Final image
FROM debian:buster-slim

RUN apt-get update && apt install -y libssl1.1 wget && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Copy over binaries from the build-env
COPY --from=go-build-env /go/bin/ /usr/local/bin/
COPY --from=rust-build-env /src/orchestrator/target/release/orchestrator /usr/local/bin/orchestrator
COPY --from=rust-build-env /src/orchestrator/target/release/register-peggy-delegate-keys /usr/local/bin/register-peggy-delegate-keys

###
### Envs
###
ENV MY_USER="mhub" \
    MY_GROUP="mhub"

ARG DOCKER_UID=1000
ARG DOCKER_GID=1000

###
### User/Group
###
RUN set -eux \
	&& groupadd -g ${DOCKER_GID} -r ${MY_GROUP} \
	&& useradd -d /home/${MY_USER} -u ${DOCKER_UID} -m -s /bin/bash -g ${MY_GROUP} ${MY_USER}



COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

RUN apt-get update && apt-get install -y procps

USER mhub
WORKDIR /home/mhub

ENTRYPOINT ["/docker-entrypoint.sh"]

