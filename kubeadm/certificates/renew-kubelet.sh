#!/bin/bash
#
# When the kubelet client certificate expires and you didn't enable rotation. You can regenerate a bootstrap kubeconfig for it.
#

CONTROL_PLANE_SSL_DIR=${CONTROL_PLANE_SSL_DIR:-/etc/kubernetes/pki}

mv /etc/kubernetes/kubelet.conf  /etc/kubernetes/kubelet.conf.bak
kubeadm init phase kubeconfig kubelet \
    --cert-dir $CONTROL_PLANE_SSL_DIR
systemctl restart kubelet
