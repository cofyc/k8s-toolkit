#!/bin/bash
#
# This script is used to clean unmapped rbd images.
#
 
DEVICES=$(rbd showmapped 2>/dev/null | grep ' stage-kube ' | tr -s ' ' | cut -d ' ' -f 5)
 
function rbd_unmap() {
    local dev=$1
    echo rbd unmap $dev
    if [ $? -eq 0 ]; then
        echo "$dev unmap ok"
    else
        echo "$dev unmap failed"
    fi
}
 
function rbd_unmount() {
    local mountpoint=$1
    echo "try to unmount $mountpoint for $dev"
    echo umount $mountpoint
    if [ $? -eq 0 ]; then
        echo "$dev $mountpoint unmount ok"
    else
        echo "$dev $mountpoint failed to umount, skipped"
    fi
}
 
for dev in $DEVICES; do
    mountpoints=$(findmnt -n $dev | cut -d ' ' -f 1)
    mountpoints_num=$(findmnt -n $dev | cut -d ' ' -f 1 | wc -l)
    if [ "$mountpoints_num" -lt 1 ]; then
        "no mountpoint found for $dev, unmap directly"
         rbd_unmap $dev
    elif [ "$mountpoints_num" -eq 1 ]; then
        if [[ "$mountpoints" = /var/lib/kubelet/plugins/kubernetes.io/rbd/* ]]; then
            rbd_unmount $mountpoints
            rbd_unmap $dev
        else
            echo "mountpoint $mountpoints found, ignored"
        fi
   else
       echo "$mountpoints_num mountpoints found for $dev, ignored"
   fi
done
