#!/bin/bash


# The variables
OUTPUT_DIR="buildroot/output/images"
KERNEL_IMG="bzImage"
RAMDISK="rootfs.cpio.lz4"
DISK_IMG="rootfs.ext2"
LOG_LEVEL="5"
LOGFILE="../../../QEMU.log"

# Check if the output files are present
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "ERROR: Output directory is not present. Please build the project first by executing './build.sh'."
    exit 1
fi

cd "$OUTPUT_DIR"

# Check if the kernel Image is present
if [ ! -f "$KERNEL_IMG" ]; then
    echo "ERROR: Kernel Image '$KERNEL_IMG' could not be found. Please make sure the project has been built without any errors."
    exit 1
fi

# Check if there is a ramdisk, otherwise try a ext2 filesystem. Also set QEMU_ARGS
if [ ! -f "$RAMDISK" ]; then
    echo "WARNING: RAMDISK Image '$RAMDISK' could not be found. Attempting to launch with a normal ext2/ext4 disk image"
    sleep 1
    if [ ! -f "$DISK_IMG" ]; then
        echo "ERROR: No Disk image or ramdisk could be found. Please make sure the project was properly built and has generated either a disk image or ramdisk."
        exit 1
    else
        echo "Launching Using a Disk Image..."
        QEMU_ARGS="-kernel $KERNEL_IMG -drive file=$DISK_IMG,format=raw -vga std -m 2048 -nic model=e1000 -append "loglevel=$LOG_LEVEL" -usb -device usb-tablet"
    fi
else
    echo "Launching Using RAMDISK Image..."
    QEMU_ARGS="-kernel $KERNEL_IMG -initrd $RAMDISK -m 2048 -nic model=e1000 -append "loglevel=$LOG_LEVEL" -usb -device usb-tablet"
fi

# Execute qemu
qemu-system-x86_64 $QEMU_ARGS >> $LOGFILE 2>&1






