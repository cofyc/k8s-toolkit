#!/bin/bash
#
# This script is used to start a kubernetes cluster on baremetal machine quickly.
#

set -e

# install docker
# https://docs.docker.com/install/linux/docker-ce/centos/
# https://docs.docker.com/install/linux/docker-ce/ubuntu/
# TODO

# install kubeadm kubectl
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

setenforce 0
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
systemctl enable kubelet 

# set up bash-completion
yum install bash-completion -y
kubectl completion bash  > /etc/bash_completion.d/kubectl
