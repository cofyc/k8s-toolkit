#!/bin/bash

kubeadm init phase kubeconfig kubelet \
    --apiserver-advertise-address 172.16.4.61 \
    --kubeconfig-dir $(pwd) \
    --node-name 172.16.4.65
