#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $ROOT

if ! systemctl is-enabled docker; then
    systemctl enable docker
fi

if systemctl is-enabled firewalld.service; then
    systemctl stop firewalld.service
    systemctl disable firewalld.service
fi
