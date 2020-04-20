#!/bin/bash
#
# When the kubelet client certificate expires and you didn't enable rotation. You can regenerate a bootstrap kubeconfig for it.
#

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $ROOT

source ./init.sh

mv /etc/kubernetes/kubelet.conf  /etc/kubernetes/kubelet.conf.bak
kubeadm init phase kubeconfig kubelet \
    --cert-dir $CERT_DIR
systemctl restart kubelet
