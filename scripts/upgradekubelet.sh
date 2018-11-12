#!/bin/bash

set -e

version="$1"
if [ -z "$version" ]; then
    echo "error: no version specified"
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive
#apt-get update -y
apt-get update -o Dir::Etc::sourcelist="sources.list.d/kirk.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
apt-get install -y kubelet="$version"
