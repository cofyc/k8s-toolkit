#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/.. && pwd)
cd $ROOT
source $ROOT/hack/lib.sh

INVENTORY=output/all.ini
$ROOT/hack/gen-ansible-inventory.sh > $INVENTORY

for h in $@; do
    # admin.conf
    src=$ROOT/output/kubernetes-admin.conf
    ansible -i $INVENTORY $h -m copy -a "src=$src dest=/etc/kubernetes/admin.conf"
    # controller-manager.conf
    src=$ROOT/output/system:kube-controller-manager.conf
    ansible -i $INVENTORY $h -m copy -a "src=$src dest=/etc/kubernetes/controller-manager.conf"
    # scheduler.conf
    src=$ROOT/output/system:kube-scheduler.conf
    ansible -i $INVENTORY $h -m copy -a "src=$src dest=/etc/kubernetes/scheduler.conf"
    # apiserver-kubelet-client.{crt,key}
    src=$ROOT/output/kube-apiserver-kubelet-client.crt
    ansible -i $INVENTORY $h -m copy -a "src=$src dest=/etc/kubernetes/pki/apiserver-kubelet-client.crt"
    src=$ROOT/output/kube-apiserver-kubelet-client.key
    ansible -i $INVENTORY $h -m copy -a "src=$src dest=/etc/kubernetes/pki/apiserver-kubelet-client.key"
    # front-proxy-client.{crt,key}
    src=$ROOT/output/front-proxy-client.crt
    ansible -i $INVENTORY $h -m copy -a "src=$src dest=/etc/kubernetes/pki/front-proxy-client.crt"
    src=$ROOT/output/front-proxy-client.key
    ansible -i $INVENTORY $h -m copy -a "src=$src dest=/etc/kubernetes/pki/front-proxy-client.key"
done
