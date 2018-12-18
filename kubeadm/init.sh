#!/bin/bash

set -e

k8s_version=v1.13.1

images=(
    kube-apiserver-amd64:$k8s_version
    kube-controller-manager-amd64:$k8s_version
    kube-scheduler-amd64:$k8s_version
    kube-proxy-amd64:$k8s_version
    pause:3.1
    etcd-amd64:3.2.18
    coredns:1.1.3
    pause-amd64:3.1
)

registry="registry.cn-hangzhou.aliyuncs.com/google_containers"

# check images
for image in ${images[@]}; do
    docker pull $registry/$image
done

kubeadm init --pod-network-cidr 10.244.0.0/16 --image-repository "$registry"

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# calico
# https://docs.projectcalico.org/v3.4/getting-started/kubernetes/
kubectl apply -f calico/etcd.yaml
kubectl apply -f calico/calico.yaml

# wait calico pods are ready

# wait nodes are ready
