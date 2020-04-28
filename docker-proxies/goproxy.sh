#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $ROOT

test -d /data/goproxy || mkdir /data/goproxy

NAME=goproxy
docker rm -f $NAME || true
docker run --net=host \
    -d \
    --privileged \
    --restart=always \
    --name $NAME \
    -v /data/registry/goproxy:/go \
    goproxy/goproxy:latest
