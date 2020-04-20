#!/bin/bash

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $ROOT

source ./init.sh

mv /etc/kubernetes/controller-manager.conf /etc/kubernetes/controller-manager.conf.old
mv /etc/kubernetes/scheduler.conf /etc/kubernetes/scheduler.conf.old
mv /etc/kubernetes/admin.conf /etc/kubernetes/admin.conf.old

kubeadm init phase kubeconfig admin \
    --cert-dir $CONTROL_PLANE_SSL_DIR
kubeadm init phase kubeconfig controller-manager \
    --cert-dir $CONTROL_PLANE_SSL_DIR
kubeadm init phase kubeconfig scheduler \
    --cert-dir $CONTROL_PLANE_SSL_DIR

for p in kube-controller-manager kube-scheduler; do
    ps -C $p -o pid,args
    pkill -f $p
    sleep 5
    ps -C $p -o pid,args
done
