#!/bin/bash

CONTROL_PLANE_SSL_DIR=${CONTROL_PLANE_SSL_DIR:-/etc/kubernetes/pki}
SERVICE_CIDR="10.233.0.0/18"

mv $CONTROL_PLANE_SSL_DIR/apiserver.key $CONTROL_PLANE_SSL_DIR/apiserver.key.old
mv $CONTROL_PLANE_SSL_DIR/apiserver.crt $CONTROL_PLANE_SSL_DIR/apiserver.crt.old
mv $CONTROL_PLANE_SSL_DIR/apiserver-kubelet-client.crt $CONTROL_PLANE_SSL_DIR/apiserver-kubelet-client.crt.old
mv $CONTROL_PLANE_SSL_DIR/apiserver-kubelet-client.key $CONTROL_PLANE_SSL_DIR/apiserver-kubelet-client.key.old
mv $CONTROL_PLANE_SSL_DIR/front-proxy-client.crt $CONTROL_PLANE_SSL_DIR/front-proxy-client.crt.old
mv $CONTROL_PLANE_SSL_DIR/front-proxy-client.key $CONTROL_PLANE_SSL_DIR/front-proxy-client.key.old

KUBE_VERSION=$(kubectl version --client --short | awk '/Client Version:/ { sub("^v", "", $3); print $3 }')

kubeadm init phase certs apiserver \
    --apiserver-cert-extra-sans  172.16.4.149,172.16.4.150,172.16.4.151 \
    --service-cidr $SERVICE_CIDR --service-dns-domain cluster.local -v 4 \
    --cert-dir "$CONTROL_PLANE_SSL_DIR"

kubeadm init phase certs apiserver-kubelet-client -v 4 \
    --cert-dir "$CONTROL_PLANE_SSL_DIR"

kubeadm init phase certs front-proxy-client -v 4 \
    --cert-dir "$CONTROL_PLANE_SSL_DIR"
