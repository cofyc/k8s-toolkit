#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $ROOT

docker rm -f quay-io-proxy || true
docker run --net=host \
    -d \
    --privileged \
    --restart=always \
    --name quay-io-proxy \
    -v $ROOT/quay-io-config.yml:/etc/docker/registry/config.yml \
    -v /data/registry/quay.io:/var/lib/registry \
    registry:2.7
