#!/bin/sh

PLATFORMS="linux/amd64,linux/arm64,linux/arm/v6,linux/arm/v7,linux/ppc64le"

docker buildx build --platform "$PLATFORMS" -t sylabsio/aufs-sanity:latest --push docker-aufs-sanity
docker buildx build --platform "$PLATFORMS" -t sylabsio/issue4525:latest --push docker-issue4525
docker buildx build --platform "$PLATFORMS" -t sylabsio/linkwh:latest --push docker-linkwh
docker buildx build --platform "$PLATFORMS" -t sylabsio/lolcow:latest --push docker-lolcow
docker buildx build --platform "$PLATFORMS" -t sylabsio/userperms:latest --push docker-userperms

