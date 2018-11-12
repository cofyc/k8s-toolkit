#!/bin/bash

pids=$(cat /sys/fs/cgroup/systemd/system.slice/kubelet.service/tasks | xargs -n 1 -Itaskid bash -c "echo -n taskid '   '; awk -F: '/^State:/ {print $2}' /proc/taskid/status" | grep -P 'D\s+\(disk sleep\)' | awk '{ print $1 }')

if [[ "$pids" == "" ]]; then
    echo "No processes found."
else
    for pid in $pids; do
        echo "$pid in kubelet.service is unkillable"
        ps -opid,etime,cmd -p $pid
    done
fi
