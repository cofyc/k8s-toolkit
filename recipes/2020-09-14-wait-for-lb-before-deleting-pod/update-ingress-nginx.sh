#!/bin/bash
#
# 1, update daemonset's updateStrategy to OnDelete
# 2, update daemonset's pod template spec
# 3, run this script, daemonset controller will create new pod but don't delete the old pod
# 4, delete the old pod with the custom label (cofyc=tmp)

pods=$(kubectl -n ingress-nginx get pods -o json -l app.kubernetes.io/instance=ingress-nginx,app.kubernetes.io/component=controller | jq -r '.items[] | .metadata.name')

function in_svc() {
    local pod="$1"
    local n=$(kubectl -n ingress-nginx get ep ingress-nginx-controller -o json | jq -r '.subsets[0].addresses[] | select(.targetRef.name == "'$pod'") | length')
    [[ "$n" -gt 0 ]]
}

for pod in $pods; do
    echo "info: begin to update $pod"
    if ! in_svc "$pod"; then
        echo "not in service, skipped"
        continue
    fi
    # remove it from the service endpoints
    kubectl -n ingress-nginx label pods $pod app.kubernetes.io/instance-
    echo "info: wait for $pod to be removed from service endpoints"
    while in_svc $pod; do
        sleep 1
    done
    # sleep 3 seconds more
    sleep 3
    # mark it to delete later
    kubectl -n ingress-nginx label pods $pod cofyc=tmp
done
