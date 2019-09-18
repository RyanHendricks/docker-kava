FROM golang:1.12.7-alpine AS build-env


ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev
ENV VERSION=master
ENV GO111MODULE=on

# Set up dependencies
RUN apk add --no-cache $PACKAGES

# Set working directory for the build
WORKDIR /go/src/github.com/Kava-Labs/

# Add source files
RUN git clone --recursive https://www.github.com/Kava-Labs/kava.git
WORKDIR /go/src/github.com/Kava-Labs/kava
RUN git checkout $VERSION

# Install minimum necessary dependencies, build Kava SDK, remove packages
RUN go install -tags "ledger" ./cmd/kvd ./cmd/kvcli

# # Final image
FROM alpine:edge


# Install ca-certificates
RUN apk add --no-cache --update ca-certificates supervisor wget lz4

RUN mkdir -p /tmp/bin

WORKDIR /tmp/bin

# Copy over binaries from the build-env
COPY --from=build-env /go/bin/kvd /tmp/bin
COPY --from=build-env /go/bin/kvcli /tmp/bin
RUN install -m 0755 -o root -g root -t /usr/local/bin kvd
RUN install -m 0755 -o root -g root -t /usr/local/bin kvcli

RUN rm -r /tmp/bin

# Add supervisor configuration files
RUN mkdir -p /etc/supervisor/conf.d/
COPY /supervisor/supervisord.conf /etc/supervisor/supervisord.conf 
COPY /supervisor/conf.d/* /etc/supervisor/conf.d/

ENV KVD_HOME=/.kvd
WORKDIR $KVD_HOME

EXPOSE 26656 26657 26658
EXPOSE 1317

USER root

ADD ./scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod u+x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

# STOPSIGNAL SIGHUP





















# FROM ubuntu:16.04

# ENV IRISHOME=/.iris
# ENV CHAIN_ID=irishub
# ENV VERSION=0.13.1
# ENV NETWORK=mainnet

# # Install prerequisites
# RUN apt-get update && apt-get upgrade -y && apt-get install unzip wget -y

# # Download binaries
# RUN mkdir /tmp/iris
# WORKDIR /tmp/iris
# RUN wget https://github.com/irisnet/irishub/releases/download/v"$VERSION"/irishub_"$VERSION"_"$NETWORK"_linux_amd64.zip
# RUN unzip irishub_"$VERSION"_"$NETWORK"_linux_amd64.zip
# RUN install -m 0755 -o root -g root -t /usr/local/bin `find . -maxdepth 1 -executable -type f`
# RUN mkdir $IRISHOME
# WORKDIR $IRISHOME
# RUN rm -r /tmp/iris

# COPY /scripts/config.sh $IRISHOME/entrypoint.sh
# RUN chmod u+x entrypoint.sh
# # RUN sh config.sh
# # RUN rm $IRISHOME/config.sh

# EXPOSE 26656
# EXPOSE 26657
# EXPOSE 26658
# EXPOSE 6060

# STOPSIGNAL SIGINT

# ENTRYPOINT [ "entrypoint.sh" ]
# ADD ./scripts/start_iris.sh /usr/local/bin/start_iris.sh
# RUN chmod u+x /usr/local/bin/start_iris.sh
# CMD [ "/usr/local/bin/start_iris.sh" ]
