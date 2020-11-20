#!/bin/bash -x
# 0. Prerequisite: brefs-progs installation
sudo apt install -y btrfs-progs

# 1. Creation file
FILE=file
LOOP=$(losetup -f)
DIR=$PWD/btrfs_dir
LABEL=mylabel
SUBVOLUME1=subvolume1
SUBVOLUME2=subvolume2
SUBVOLUME1_DIR=$PWD/subvolume1_dir
SUBVOLUME2_DIR=$PWD/subvolume2_dir
echo $LOOP
echo $PWD/$FILE
dd if=/dev/zero of=$FILE bs=1M count=100

# 2. Create connection between file and loop device
sudo losetup -f $PWD/$FILE
losetup $LOOP

# 3. Format loop device with btrfs
sudo mkfs.btrfs $LOOP

# 4. Create dirs
mkdir -p $DIR
mkdir -p $SUBVOLUME1_DIR
mkdir -p $SUBVOLUME2_DIR

# 5. Mount btrfs on local dir
sudo mount $LOOP $DIR
sudo chmod -R 777 $DIR
echo "main volume" > $DIR/main_volume.txt
find $DIR

# 6. Assign a label
sudo btrfs filesystem label $DIR $LABEL
echo "New label: "
sudo btrfs filesystem label $DIR

# 7. Create Subvolume test
sudo btrfs subvolume create $DIR/$SUBVOLUME1
sudo btrfs subvolume create $DIR/$SUBVOLUME2
sudo chmod -R 777 $DIR/$SUBVOLUME1
sudo chmod -R 777 $DIR/$SUBVOLUME2
sudo echo "subvolume1" > $DIR/$SUBVOLUME1/subvolume1.txt
sudo echo "subvolume2" > $DIR/$SUBVOLUME2/subvolume2.txt
sudo umount $DIR

sudo mount $LOOP $SUBVOLUME1_DIR -o subvol=$SUBVOLUME1
find $SUBVOLUME1_DIR
sudo mount $LOOP $SUBVOLUME2_DIR -o subvol=$SUBVOLUME2
find $SUBVOLUME2_DIR
sudo df -h

# 99. Unmount and remove connection file / loop device
sleep 1
sudo umount $SUBVOLUME2_DIR
sleep 1
sudo umount $SUBVOLUME1_DIR
sudo losetup -d $LOOP
