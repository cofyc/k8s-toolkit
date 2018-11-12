#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

IMAGE=
COMPONENT=kube-scheduler

docker pull "$IMAGE"

cp /etc/kubernetes/manifests/${COMPONENT}.yaml /tmp/${COMPONENT}.yaml

sed -i "s#image: .*#image: ${IMAGE}#g" /tmp/${COMPONENT}.yaml

diff -u /etc/kubernetes/manifests/${COMPONENT}.yaml /tmp/${COMPONENT}.yaml || true

cp /tmp/${COMPONENT}.yaml /etc/kubernetes/manifests/${COMPONENT}.yaml
