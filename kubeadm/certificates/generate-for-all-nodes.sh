#!/bin/bash

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $ROOT

source ./init.sh

for n in kubectl get nodes --no-headers | awk '{print $1}'; do
    kubeadm init phase kubeconfig kubelet \
        --cert-dir $CONTROL_PLANE_SSL_DIR \
        --node-name $n \
        --kubeconfig-dir ./kubelets
done
