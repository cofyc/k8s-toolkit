#!/bin/bash
#
# This script is used to verify all certificates on all nodes.
#

function check_kubeconfig() {
    local file=$1
    echo -n "checking $file: "
    if [ -f $file ]; then
        cat $1 | grep client-certificate-data | cut -f2 -d : | tr -d ' ' | base64 -d | openssl x509 -enddate -noout
    else
        echo " does not exist, skipped"
    fi
}

function check_cert() {
    local file=$1
    echo -n "checking $file: "
    if [ -f $file ]; then
	openssl x509 -enddate -in $file -noout
    else
        echo " does not exist, skipped"
    fi
}

# kubelet /etc/kubernetes/kubelet.conf
check_kubeconfig /etc/kubernetes/kubelet.conf

# ~/.kube/config
check_kubeconfig ~/.kube/config

for i in $(find /etc/kubernetes/pki -name '*.crt'); do
     check_cert $i
done
