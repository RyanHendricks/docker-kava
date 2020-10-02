<div align="center">

# Docker Kava

<a href="https://github.com/Kava-Labs/"><img src="https://raw.githubusercontent.com/RyanHendricks/docker-kava/master/.github/kava.svg" alt="drawing" width="100"/></a>

[![Docker Pulls](https://img.shields.io/docker/pulls/ryanhendricks/docker-kava.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/ryanhendricks/docker-kava) [![MicroBadger Layers (latest)](https://img.shields.io/microbadger/layers/ryanhendricks/docker-kava/latest.svg?logo=docker&logoColor=white)](https://microbadger.com/images/ryanhendricks/docker-kava) [![MicroBadger Version](https://images.microbadger.com/badges/version/ryanhendricks/docker-kava.svg)](https://microbadger.com/images/ryanhendricks/docker-kava) [![CircleCI (all branches)](https://img.shields.io/circleci/build/github/RyanHendricks/docker-kava/master?logo=circleci&token=5a11bae20d4346a49ee28e97d89c186f711a407c)](https://img.shields.io/circleci/build/github/RyanHendricks/docker-kava/master?logo=circleci&token=5a11bae20d4346a49ee28e97d89c186f711a407c) [![Codacy grade](https://img.shields.io/codacy/grade/738a34f90f1641ea9321abb27dd981f5.svg?logo=codacy)](https://www.codacy.com?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=RyanHendricks/docker-kava&amp;utm_campaign=Badge_Grade)

</div>

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=2 orderedList=false} -->

<!-- code_chunk_output -->

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Build](#build)
- [Run](#run)
- [Supervisor](#supervisor)
- [Contributing](#contributing)
- [License](#license)

<!-- /code_chunk_output -->

## Prerequisites

- Docker
- Docker-Compose (optional)

## Quick Start

The image can be run without any configuration and defaults to mainnet (currently kava-3)

```bash
docker  run --rm -it -P ryanhendricks/docker-kava:latest
```

## Configuration

### Config.toml Parameters

- The config.toml is created dynamically when starting the container.
- All parameters specified in the standard config.toml file can be set using environmental variables with the same name as the config parameter but in all caps. See [entrypoint script](./scripts/entrypoint.sh) for more details.
- If left unset the default values will be used.
- Parameters can be set directly by modifying the config.toml portion of ./scripts/entrypoint.sh if you are cloning and building the image yourself.

### Environment Variables

You can set ENV variables either in a docker-compose file or in the docker run command if running the container directly. If left unchanged they will default to the standard value except for the following:

- MONIKER
  - defaults to "nonamenode"
- CHAIN_ID
  - defaults to kava-3
- GENESIS_URL
  - defaults to kava-3 github [genesis file url](https://raw.githubusercontent.com/Kava-Labs/launch/master/kava-3/genesis.json)

Some examples:

```bash
MONIKER=nonamenode
CHAIN_ID=kava-3
BOOTSTRAP=TRUE
PROMETHEUS=true
GENESIS_URL=https://raw.githubusercontent.com/Kava-Labs/launch/master/kava-3/genesis.json
KVD_HOME=/.kvd
```

Running multiple nodes with the same IP address is possible using different ports. This is easily accomplished with the following ENV variabes.

```bash
PROMETHEUS_LISTEN_ADDR=46660
MAX_OPEN_CONNECTIONS=10
LCD_PORT=4317
RPC_PORT=46657
P2P_PORT=46656
PROXY_APP_PORT=46658
```

### Bootstrapping

  The entrypoint script allows for the node to be bootstrapped upon creation. This drastically reduces the time required to fully sync with the network. The start up time is increased relative to the amount of time it takes the host machine to download the archived data and extract it into the data directory.

  Set the ENV variable ```BOOTSTRAP=TRUE``` to enable bootstrapping.

## Build

The following command will build the image.

```bash
docker build --rm -f Dockerfile -t docker-kava:latest .
```

## Run

```sh
docker-compose up -d --build
```

## Supervisor

The image uses Supervisor to run both kvd and kvcli simultaneously (in the same container) at container runtime. Supervisor also restarts either process should it fail for some reason.

### Kvd

After starting the container you can check the status here: [http://0.0.0.0:26657/status](http://0.0.0.0:26657/status).

or from the terminal

```bash
curl -X GET \
  http://127.0.0.1:26657/status? \
  -H 'cache-control: no-cache'
```

### Kvcli Rest-Server

Supervisor starts the rest-server with the following command:

```bash
kvcli rest-server --trust-node --cors * --home $KVD_HOME --laddr tcp://0.0.0.0:1317

```

You can verify that the rest-server is running using the following example

```bash
curl -X GET \
  http://0.0.0.0:1317/blocks/latest \
  -H 'cache-control: no-cache'
```

## Contributing

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?)](http://makeapullrequest.com)

### Contributors

[![Keybase PGP](https://img.shields.io/keybase/pgp/ryanhendricks.svg?label=keybase&logo=keybase&logoColor=white)](https://keybase.io/ryanhendricks)

## License

![GitHub](https://img.shields.io/github/license/ryanhendricks/docker-kava.svg)
