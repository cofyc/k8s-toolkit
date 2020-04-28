#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $ROOT

docker rm -f gcr-io-proxy || true
docker run --net=host \
    -d \
    --privileged \
    --restart=always \
    --name gcr-io-proxy \
    -v $ROOT/gcr-io-config.yml:/etc/docker/registry/config.yml \
    -v /data/registry/gcr.io:/var/lib/registry \
    registry:2.7
