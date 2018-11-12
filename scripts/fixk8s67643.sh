#!/bin/bash

PROGRAMS="ceph-fuse java"

function movetoroot() {
    local pid=$1
    # note that there is an additional `systemd`
    for cgroup in $(cat /proc/cgroups | tail -n +2 | cut -f 1) systemd; do
        echo $pid > /sys/fs/cgroup/$cgroup/cgroup.procs
    done
}

for p in $PROGRAMS; do
    echo "Checking for program $p"
    pids=$(ps -C "$p" -opid --no-headers)
    if [[ "$pids" == "" ]]; then
        echo "No processes found."
        continue
    else
        for pid in $pids; do
            echo "Checking process $pid..."
            cat /proc/$pid/cgroup | grep kubelet.service
            if [ $? -eq 0 ]; then
                echo "Move it to root."
                movetoroot $pid
            else
                echo "Not in kubelet.service, skipped."
            fi
        done
    fi
done
