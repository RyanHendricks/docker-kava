# Docker kava

[![Docker Pulls](https://img.shields.io/docker/pulls/ryanhendricks/docker-kava.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/ryanhendricks/docker-kava)
[![MicroBadger Layers (latest)](https://img.shields.io/microbadger/layers/ryanhendricks/docker-kava/latest.svg?logo=docker&logoColor=white)](https://microbadger.com/images/ryanhendricks/docker-kava)
[![MicroBadger Version](https://images.microbadger.com/badges/version/ryanhendricks/docker-kava.svg)](https://microbadger.com/images/ryanhendricks/docker-kava)

[![CircleCI (all branches)](https://img.shields.io/circleci/build/github/RyanHendricks/docker-kava/master?logo=circleci&token=5a11bae20d4346a49ee28e97d89c186f711a407c)](https://img.shields.io/circleci/build/github/RyanHendricks/docker-kava/master?logo=circleci&token=5a11bae20d4346a49ee28e97d89c186f711a407c)
[![Codacy grade](https://img.shields.io/codacy/grade/738a34f90f1641ea9321abb27dd981f5.svg?logo=codacy)](https://www.codacy.com?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=RyanHendricks/docker-kava&amp;utm_campaign=Badge_Grade)

## Getting Started

- Customize the configuration within scripts/config.sh
- Change ENV variables in Dockerfile (if needed)

## Start Node

```bash
docker-compose up -d --build
```

## Notes

This setup is meant to provide a full node only and not recommended for running a validator node. Although with some additional configuration to the node and the server where it will be running it is entirely possible to do so.
