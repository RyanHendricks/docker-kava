![https://gitlab.com/appealtoheavenllc/docker-kava](https://gitlab.com/appealtoheavenllc/docker-kava/badges/master/pipeline.svg)

[![MicroBadger Version](https://images.microbadger.com/badges/version/ryanhendricks/docker-kava.svg)](https://microbadger.com/images/ryanhendricks/docker-kava)
[![CircleCI (all branches)](https://img.shields.io/circleci/project/github/RyanHendricks/docker-kava/tree/master.svg?label=build&logo=circleci&logoColor=white)](https://circleci.com/gh/RyanHendricks/docker-kava/tree/master)
[![Docker Pulls](https://img.shields.io/docker/pulls/ryanhendricks/docker-kava.svg?logo=docker&logoColor=white)](https://hub.docker.com/r/ryanhendricks/docker-kava)


[![CircleCI](https://circleci.com/gh/RyanHendricks/docker-kava/tree/master.svg?style=svg&circle-token=5a11bae20d4346a49ee28e97d89c186f711a407c)](https://circleci.com/gh/RyanHendricks/docker-kava/tree/master)


[![MicroBadger Layers (latest)](https://img.shields.io/microbadger/layers/ryanhendricks/docker-kava/latest.svg?logo=docker&logoColor=white)](https://microbadger.com/images/ryanhendricks/docker-kava)
[![MicroBadger Image-Size (latest)](https://img.shields.io/microbadger/image-size/ryanhendricks/docker-kava:latest.svg?logo=docker&logoColor=white)](https://microbadger.com/images/ryanhendricks/docker-kava)

[![Codacy grade](https://img.shields.io/codacy/grade/c35da045d95b4f07b09948d19bacaa47.svg?logo=codacy)](https://www.codacy.com?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=RyanHendricks/docker-kava&amp;utm_campaign=Badge_Grade)

# Docker kava

## Getting Started

- Customize the configuration within scripts/config.sh
- Change ENV variables in Dockerfile (if needed)

## Start Node

```bash
docker-compose up -d --build
```

## Notes

This setup is meant to provide a full node only and not recommended for running a validator node. Although with some additional configuration to the node and the server where it will be running it is entirely possible to do so.
