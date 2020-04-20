#!/bin/bash

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $ROOT

source ./init.sh

for n in $(kubectl get nodes --no-headers | awk '{print $1}'); do
    kubeadm init phase kubeconfig kubelet \
        --cert-dir $CERT_DIR \
        --node-name $n \
        --kubeconfig-dir ./kubelets/$n
done
