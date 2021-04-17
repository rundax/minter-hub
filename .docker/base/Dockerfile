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



FROM debian:buster AS rust-build-env

ENV RUSTUP_VER=1.51.0

RUN apt update && apt install -y curl build-essential wget curl libssl-dev pkg-config

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/run  && \
    sh /tmp/run -y --default-toolchain $RUSTUP_VER

COPY --from=go-build-env /src/ /src/


RUN cd /src/orchestrator && /root/.cargo/bin/cargo install --locked --path orchestrator
RUN cd /src/orchestrator && /root/.cargo/bin/cargo install --locked --path register_delegate_keys


# Final image
FROM alpine:latest

# Install ca-certificates
RUN apk add --update ca-certificates bash
WORKDIR /root

# Copy over binaries from the build-env
COPY --from=go-build-env /go/bin/ /usr/local/bin/
COPY --from=rust-build-env /src/orchestrator/target/release/orchestrator /usr/local/bin/orchestrator
COPY --from=rust-build-env /src/orchestrator/target/release/register-peggy-delegate-keys /usr/local/bin/register-peggy-delegate-keys

###
### Envs
###
ENV MY_USER="mhub" \
    MY_GROUP="mhub" \
    MY_UID="1000" \
    MY_GID="1000"

####
#### User/Group
####
RUN set -eux \
    && addgroup -g ${MY_GID} ${MY_GROUP} \
    && adduser -u ${MY_UID} -G ${MY_GROUP} -s /bin/sh -D ${MY_USER}


COPY ./docker-entrypoint.sh /docker-entrypoint.sh

# Must set this value for the bash shell to source
# the '/etc/bashrc' file.
# See: https://stackoverflow.com/q/29021704
ENV BASH_ENV /etc/bashrc
COPY data/bashrc /etc/bashrc


RUN chmod +x /docker-entrypoint.sh


USER mhub
WORKDIR /home/mhub

ENTRYPOINT ["/docker-entrypoint.sh"]