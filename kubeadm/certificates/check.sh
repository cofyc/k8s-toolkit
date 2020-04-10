#!/bin/bash

APISERVER_ADDRESS=${APISERVER_ADDRESS:-}
CONTROL_PLANE_SSL_DIR=${CONTROL_PLANE_SSL_DIR:-/etc/kubernetes/pki}

echo | openssl s_client -servername ${APISERVER_ADDRESS} -connect ${APISERVER_ADDRESS}:6443 2>/dev/null | openssl x509 -text -noout

for i in $(find $CONTROL_PLANE_SSL_DIR -name '*.crt'); do
    echo $i
    openssl x509 -enddate -in $i -noout
done
