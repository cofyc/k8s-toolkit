#!/bin/bash
#
# If there is process is unkillable, kubelet restart <service> will hang about
# 3 minutes (by default). 
# This is unacceptable sometimes, for example restart kubelet.
# This script is used to move unkillable processes to root cgroup.
#

pids=$(cat /sys/fs/cgroup/systemd/system.slice/kubelet.service/tasks | xargs -n 1 -Itaskid bash -c "echo -n taskid '   '; awk -F: '/^State:/ {print $2}' /proc/taskid/status" | grep -P 'D\s+\(disk sleep\)' | awk '{ print $1 }')

function movetoroot() {
    local pid=$1
    # note that there is an additional `systemd`
    for cgroup in $(cat /proc/cgroups | tail -n +2 | cut -f 1) systemd; do
        echo $pid > /sys/fs/cgroup/$cgroup/cgroup.procs
    done
}

if [[ "$pids" == "" ]]; then
    echo "No processes found."
else
    for pid in $pids; do
        echo "$pid in kubelet.service is unkillable"
        movetoroot $pid
    done
fi
