#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $ROOT

docker rm -f docker-io-proxy || true
docker run --net=host \
    -d \
    --privileged \
    --restart=always \
    --name docker-io-proxy \
    -v $ROOT/docker-io-config.yml:/etc/docker/registry/config.yml \
    -v /data/registry/docker.io:/var/lib/registry \
    registry:2.7
