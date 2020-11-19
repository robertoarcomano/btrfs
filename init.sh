#!/bin/bash -x
# 0. Prerequisite: brefs-progs installation
sudo apt install -y btrfs-progs

# 1. Creation file
FILE=file
LOOP=$(losetup -f)
DIR=$PWD/btrfs_dir
LABEL=mylabel
echo $LOOP
echo $PWD/$FILE
dd if=/dev/zero of=$FILE bs=1M count=100

# 2. Create connection between file and loop device
sudo losetup -f $PWD/$FILE
losetup $LOOP

# 3. Format loop device with btrfs
sudo mkfs.btrfs $LOOP

# 4. Create mount dir
mkdir -p $DIR

# 5. Mount btrfs on local dir
sudo mount $LOOP $DIR

# 6. Assign a label
sudo btrfs filesystem label $DIR $LABEL
echo "New label: "
sudo btrfs filesystem label $DIR

# 99. Unmount and remove connection file / loop device
sudo umount $DIR
sudo losetup -d $LOOP
