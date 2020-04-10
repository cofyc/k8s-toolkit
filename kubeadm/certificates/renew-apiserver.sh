#!/bin/bash

CERTS_DIR=/etc/kubernetes/ssl
SERVICE_CIDR="10.233.0.0/18"

mv $CERTS_DIR/apiserver.key $CERTS_DIR/apiserver.key.old
mv $CERTS_DIR/apiserver.crt $CERTS_DIR/apiserver.crt.old
mv $CERTS_DIR/apiserver-kubelet-client.crt $CERTS_DIR/apiserver-kubelet-client.crt.old
mv $CERTS_DIR/apiserver-kubelet-client.key $CERTS_DIR/apiserver-kubelet-client.key.old
mv $CERTS_DIR/front-proxy-client.crt $CERTS_DIR/front-proxy-client.crt.old
mv $CERTS_DIR/front-proxy-client.key $CERTS_DIR/front-proxy-client.key.old

kubeadm init phase certs apiserver \
    --apiserver-cert-extra-sans 172.1172.16.4.62,172.16.4.63 \
    --service-cidr $SERVICE_CIDR --service-dns-domain cluster.local -v 4
kubeadm init phase certs apiserver-kubelet-client -v 4
kubeadm init phase certs front-proxy-client -v 
