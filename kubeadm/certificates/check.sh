#!/bin/bash

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/.. && pwd)
cd $ROOT

source ./init.sh

echo | openssl s_client -servername ${APISERVER_ADDRESS} -connect ${APISERVER_ADDRESS}:6443 2>/dev/null | openssl x509 -text -noout

for i in $(find $CONTROL_PLANE_SSL_DIR -name '*.crt'); do
    echo $i
    openssl x509 -enddate -in $i -noout
done

for i in $(find $ETCD_SSL_DIR -name '*.pem'); do
    echo $i
    openssl x509 -enddate -in $i -noout
done
