#!/bin/bash


# The variables
OUTPUT_DIR="buildroot/output/images"
KERNEL_IMG="bzImage"
RAMDISK="rootfs.cpio.lz4"
DISK_IMG="disk.img"
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


# Allow the user to choose if they want to boot the test VM with a RAMDISK or a ext disk image
read -p "How do you want to boot up the VM? (1=ramdisk, 2=disk_image): " boot_opt
case $boot_opt in
    1)
        if [ ! -f "$RAMDISK" ]; then
            echo "RAMDISK Image not found"
            exit 1
        fi

        QEMU_ARGS="-kernel $KERNEL_IMG -initrd $RAMDISK -nic model=e1000 -vga std -usb -device usb-tablet -m 2048 -enable-kvm"
        qemu-system-x86_64 $QEMU_ARGS | tee -a $LOGFILE 2>&1
        ;;
    2)
        if [ ! -f "$DISK_IMG" ]; then
            echo "DISK Image not found"
            exit 1
        fi

        QEMU_ARGS="-kernel $KERNEL_IMG -drive file=$DISK_IMG,format=raw -append root=/dev/sda2 -nic model=e1000 -vga std -usb -device usb-tablet -m 2048 -enable-kvm"
        qemu-system-x86_64 $QEMU_ARGS | tee -a $LOGFILE 2>&1
        ;;
    *)
        echo "Invalid argument"
        ;;
esac




