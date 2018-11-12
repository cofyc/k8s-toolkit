#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ROOT=$(unset CDPATH && cd $(dirname "${BASH_SOURCE[0]}")/.. && pwd)
cd $ROOT
source $ROOT/hack/lib.sh

hosts=$(kubectl get nodes -ojsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}')

INVENTORY=output/all.ini
$ROOT/hack/gen-ansible-inventory.sh > $INVENTORY

for h in $hosts; do
    src=$ROOT/output/system:node:$h.conf
    ansible -i $INVENTORY $h -m copy -a "src=$src dest=/etc/kubernetes/kubelet.conf"
    ansible -i $INVENTORY $h -a "systemctl restart kubelet"
done
