#!/bin/bash

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $ROOT

export PATH=$(pwd):$PATH

SERVICE_CIDR=${SERVICE_CIDR:-"10.96.0.0/12"}
APISERVER_CERT_EXTRA_SANS=${APISERVER_CERT_EXTRA_SANS:-"127.0.0.1"}
CERT_DIR=${CERT_DIR:-/etc/kubernetes/pki}
KUBE_VERSION=$(kubeadm version -o short)
