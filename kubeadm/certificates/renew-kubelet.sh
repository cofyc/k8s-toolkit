#!/bin/bash

mv /etc/kubernetes/kubelet.conf  /etc/kubernetes/kubelet.conf.bak
kubeadm init phase kubeconfig kubelet \
    --apiserver-advertise-address 172.16.4.61
