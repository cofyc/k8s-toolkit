#!/bin/bash
#
# If there is process is unkillable, kubelet restart <service> will hang about
# 3 minutes (by default). 
# This is unacceptable sometimes, for example restart kubelet.
# This script is used to move unkillable processes to root cgroup.
#

set -e

function movetoroot() {
    local pid=$1
    # note that there is an additional `systemd`
    for cgroup in $(cat /proc/cgroups | tail -n +2 | cut -f 1) systemd; do
        echo $pid > /sys/fs/cgroup/$cgroup/cgroup.procs
    done
}

function find_kubelet_cgroup_path() {
    local pid=$(ps -C kubelet -opid --no-headers | tr -d "[:space:]")
    if [ -z "$pid" ]; then
        echo "error: kubelet process is not found"
	return 1
    fi
    local systemd_path=$(cat /proc/$pid/cgroup | awk -F: '/name=systemd/ {print $3}')
    if [ -z "$systemd_path" ]; then
        echo "error: kubelet systemd path is not found"
	return 1
    fi
    echo "/sys/fs/cgroup/systemd${systemd_path}"
}

cgroup_path=$(find_kubelet_cgroup_path)
echo "cgroup path: $cgroup_path"
pids=$(cat $cgroup_path/tasks | xargs -n 1 -Itaskid bash -c "echo -n taskid '   '; awk -F: '/^State:/ {print $2}' /proc/taskid/status" | grep -P 'D\s+\(disk sleep\)' | awk '{ print $1 }')

if [[ "$pids" == "" ]]; then
    echo "No processes found."
else
    for pid in $pids; do
        echo "$pid in kubelet.service is unkillable"
        movetoroot $pid
    done
fi
