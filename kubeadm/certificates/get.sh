#!/bin/bash

# kubeadm 1.12.x and before is hard to use.
curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubeadm
chmod +x kubeadm
