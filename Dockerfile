FROM golang:1.13-alpine AS build-env


ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev
ENV VERSION=v0.3.1
ENV GO111MODULE=on

# Set up dependencies
RUN apk add --no-cache $PACKAGES

# Set working directory for the build
WORKDIR /go/src/github.com/Kava-Labs/

# Add source files
RUN git clone --recursive https://www.github.com/Kava-Labs/kava.git
WORKDIR /go/src/github.com/Kava-Labs/kava
RUN git checkout $VERSION

# Install minimum necessary dependencies and build binaries
RUN make install


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

COPY ./scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod u+x /usr/local/bin/entrypoint.sh
ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
