#!/bin/bash

set -e

num=10
password=$1
group=tutorial

if [ -z "$password" ]; then
    echo "error: no password specified"
    exit 1
fi

groupadd -f $group

for i in $(seq 1 10); do
    user="user$i"
    if ! getent passwd user1 &>/dev/null; then
        useradd -m -s /bin/bash -g $group $user
    else
        echo "$user already created"
    fi
    echo "$user:$password" | chpasswd

    # examples
    rsync -av examples/ /home/$user/examples
    chown -R $user:$group /home/$user/examples
    find /home/$user/examples -name '*.yaml' | xargs sed -i "s#namespace: default#namespace: $user#g"
    sed -i "s/name: default/name: $user/g" /home/$user/examples/ns.yaml

    # kubectl kubeconfig
    mkdir -p /home/$user/.kube
    sudo cp /etc/kubernetes/admin.conf /home/$user/.kube/config
    chown -R $user:$group /home/$user/.kube
    kubectl config --kubeconfig=/home/$user/.kube/config set-context kubernetes-admin@kubernetes --namespace=$user
done

