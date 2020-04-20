#!/bin/bash

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}") && pwd)
cd $ROOT

source ./init.sh

for i in $(find $CERT_DIR -name '*.crt' -o -name '*.pem'); do
    echo $i
    openssl x509 -enddate -in $i -noout
done
for f in $(ls /etc/kubernetes/{admin,controller-manager,scheduler}.conf); do
    echo $f
    kubectl --kubeconfig $f config view --raw -o jsonpath='{range .users[*]}{.user.client-certificate-data}{end}' | base64 -d | openssl x509 -enddate -noout
done
