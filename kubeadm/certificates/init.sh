#!/bin/bash

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $ROOT

CONTROL_PLANE_SSL_DIR=${CONTROL_PLANE_SSL_DIR:-/etc/kubernetes/pki}
APISERVER_ADDRESS=${APISERVER_ADDRESS:-}
ETCD_SSL_DIR=${ETCD_SSL_DIR:-$CONTROL_PLANE_SSL_DIR/etcd}

export PATH=$(pwd):$PATH
