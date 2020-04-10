#!/bin/bash

CONTROL_PLANE_SSL_DIR=${CONTROL_PLANE_SSL_DIR:-/etc/kubernetes/pki}

for n in kubectl get nodes --no-headers | awk '{print $1}'; do
    kubeadm init phase kubeconfig kubelet \
        --cert-dir $CONTROL_PLANE_SSL_DIR \
        --node-name $n \
        --kubeconfig-dir ./kubelets
done
