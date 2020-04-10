#!/bin/bash

APISEVER_ADVERTISE_ADDRESS="172.16.4.61"

CERTS_DIR=/etc/kubernetes/ssl

mv /etc/kubernetes/controller-manager.conf /etc/kubernetes/controller-manager.conf.old
mv /etc/kubernetes/scheduler.conf /etc/kubernetes/scheduler.conf.old
mv /etc/kubernetes/admin.conf /etc/kubernetes/admin.conf.old

kubeadm init phase kubeconfig admin --apiserver-advertise-address $APISEVER_ADVERTISE_ADDRESS \
    --cert-dir $CERTS_DIR
kubeadm init phase kubeconfig controller-manager --apiserver-advertise-address $APISEVER_ADVERTISE_ADDRESS \
    --cert-dir $CERTS_DIR
kubeadm init phase kubeconfig scheduler --apiserver-advertise-address $APISEVER_ADVERTISE_ADDRESS \
    --cert-dir $CERTS_DIR

for p in kube-controller-manager kube-scheduler; do
    ps -C $p -o pid,args
    pkill -f $p
    sleep 5
    ps -C $p -o pid,args
done
