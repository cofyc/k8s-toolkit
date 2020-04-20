#!/bin/bash

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $ROOT

source ./init.sh

SERVICE_CIDR="10.233.0.0/18"
MASTER_SERVER_IPS="172.16.4.2,172.16.4.3,172.16.4.4,127.0.0.1" # UPDATE THIS!!!

mv $CONTROL_PLANE_SSL_DIR/apiserver.key $CONTROL_PLANE_SSL_DIR/apiserver.key.old
mv $CONTROL_PLANE_SSL_DIR/apiserver.crt $CONTROL_PLANE_SSL_DIR/apiserver.crt.old
mv $CONTROL_PLANE_SSL_DIR/apiserver-kubelet-client.crt $CONTROL_PLANE_SSL_DIR/apiserver-kubelet-client.crt.old
mv $CONTROL_PLANE_SSL_DIR/apiserver-kubelet-client.key $CONTROL_PLANE_SSL_DIR/apiserver-kubelet-client.key.old
mv $CONTROL_PLANE_SSL_DIR/front-proxy-client.crt $CONTROL_PLANE_SSL_DIR/front-proxy-client.crt.old
mv $CONTROL_PLANE_SSL_DIR/front-proxy-client.key $CONTROL_PLANE_SSL_DIR/front-proxy-client.key.old

KUBE_VERSION=$(kubectl version --client --short | awk '/Client Version:/ { sub("^v", "", $3); print $3 }')

kubeadm init phase certs apiserver \
    --apiserver-cert-extra-sans $MASTER_SERVER_IPS \
    --service-cidr $SERVICE_CIDR --service-dns-domain cluster.local -v 4 \
    --cert-dir "$CONTROL_PLANE_SSL_DIR"

kubeadm init phase certs apiserver-kubelet-client -v 4 \
    --cert-dir "$CONTROL_PLANE_SSL_DIR"

kubeadm init phase certs front-proxy-client -v 4 \
    --cert-dir "$CONTROL_PLANE_SSL_DIR"

for p in kube-apiserver; do
    ps -C $p -o pid,args
    pkill -f $p
    sleep 5
    ps -C $p -o pid,args
done
