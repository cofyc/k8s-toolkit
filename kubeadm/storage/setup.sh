#!/bin/bash

action=${1:-setup}

function usage() {
    echo "Usage: $(basename $0) [setup|teardown]"
    echo ""
}

case $action in
    "setup" | "teardown")
        ;;  
    *)  
        usage
        ;;  
esac

test -d /mnt/disks || mkdir /mnt/disks
for i in $(seq 1 20); do
    # filesystem
    vol=vol$i
    dir=/mnt/disks/$vol
    if [[ "$action" == "setup" ]]; then
        test -d $dir || mkdir $dir
        mountpoint $dir || mount -t tmpfs $vol -osize=10240000 $dir
    else
        test -d $dir && umount $dir
        test -d $dir && rmdir $dir
    fi  
    # block
    blk=/mnt/disks/blk$i
    blkvol=/mnt/disks/blkvol$i
    blkfile=/mnt/disks/blkfile$i
    if [[ "$action" == "setup" ]]; then
        if [[ ! -e "$blk" || "$(stat -L -c '%F' $blk)" != "block special file" ]]; then
            dd if=/dev/zero of=$blkfile bs=512 count=20480
            blkdev=$(losetup -f)
            losetup $blkdev $blkfile
            ln -fs $blkdev $blk
        fi  
        test -d $blkvol || mkdir $blkvol
        mkfs.ext4 $blk
        mountpoint $blkvol || mount $blk $blkvol
    else
        if [[ "$(stat -L -c '%F' $blk)" == "block special file" ]]; then
            losetup -d $blk
            rm $blk
            rm $blkfile
        fi  
        test -d $blkvol && umount $blkvol
        test -d $blkvol && rmdir $blkvol
    fi  
done
