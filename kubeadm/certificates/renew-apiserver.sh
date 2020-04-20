#!/bin/bash

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $ROOT

source ./init.sh

SERVICE_CIDR="10.233.0.0/18"
APISERVER_CERT_EXTRA_SANS="172.16.4.2,172.16.4.3,172.16.4.4,127.0.0.1" # UPDATE THIS!!!

mv $CERT_DIR/apiserver.key $CERT_DIR/apiserver.key.old
mv $CERT_DIR/apiserver.crt $CERT_DIR/apiserver.crt.old
mv $CERT_DIR/apiserver-kubelet-client.crt $CERT_DIR/apiserver-kubelet-client.crt.old
mv $CERT_DIR/apiserver-kubelet-client.key $CERT_DIR/apiserver-kubelet-client.key.old
mv $CERT_DIR/front-proxy-client.crt $CERT_DIR/front-proxy-client.crt.old
mv $CERT_DIR/front-proxy-client.key $CERT_DIR/front-proxy-client.key.old

kubeadm init phase certs apiserver -v 4\
    --apiserver-cert-extra-sans "$APISERVER_CERT_EXTRA_SANS" \
    --service-cidr "$SERVICE_CIDR" \
    --service-dns-domain "$CLUSTER_DOMAIN" \
    --cert-dir "$CERT_DIR"

kubeadm init phase certs apiserver-kubelet-client -v 4 \
    --cert-dir "$CERT_DIR"

kubeadm init phase certs front-proxy-client -v 4 \
    --cert-dir "$CERT_DIR"

for p in kube-apiserver; do
    ps -C $p -o pid,args
    pkill -f $p
    sleep 5
    ps -C $p -o pid,args
done
