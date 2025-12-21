#!/bin/bash

BR_SOURCE="buildroot"
BR_EXTERNAL="buildroot-external"
BR_OVERLAY="$BR_EXTERNAL/overlay"
BUILD_MARKER="output/.build-complete"
BUILD_LOG="../GREMLIN_build.log"

# Check to make sure all files and the buildroot source are available
clear
echo "[Checking Files]"
sleep 1
if [ -d "$BR_SOURCE" ]; then # Check if the buildroot source is available
    echo "Buildroot source is available ✓"
else
    echo "ERROR: Buildroot source is not available. Please run './prepare.sh' first."
    exit 1
fi

if [ -d "$BR_EXTERNAL" ]; then # Check if the buildroot-external directory is available
    echo "buildroot-external is available ✓"

    if [ -d "$BR_EXTERNAL/configs" ]; then # Check if the configs subdirectory in buildroot-external is available.
        echo "Configs sub-directory is available ✓"
    else
        echo "ERROR: '$BR_EXTERNAL/configs' is not available. Please make sure you downloaded everything."
        exit 1
    fi

    if [ -d "$BR_OVERLAY" ]; then
        echo "Overlay sub-directory is available ✓"
    else
        echo "ERROR: ''$BR_OVERLAY' is not available. Please make sure you downloaded everything."
        exit 1
    fi

else
    echo "ERROR: buildroot-external is not available. Please make sure you downloaded everything."
    exit 1
fi

# If the user wants to tweak the Buildroot configuration before build.
echo "[User configuration]"
cd buildroot
make olddefconfig
read -p "Do you want to modify the buildroot configuration (open menuconfig)? (y/n): " choice
[ "$choice" = "y" ] && make menuconfig

# If the user wants to tweak the kernel configuration after the kernel has already been built.
KERNEL_DIR=$(ls -d output/build/linux-6* 2>/dev/null | sort -V | tail -n 1)
if [ ! -z "$KERNEL_DIR" ]; then
    read -p "Do you want to modify the kernel configuration (open menuconfig)? (y/n): " choice2
    [ "$choice2" = "y" ] && make linux-menuconfig
fi

# Build GREMLIN
echo "[Build GREMLIN]"
make -j $(nproc) | tee -a "$BUILD_LOG"
echo $? > $exitcode


# First check if build completed with no errors, Then apply post-build tweaks.
if [ $exitcode -ne 0 ]; then
    echo "[Build FAIL]"
    echo "ERROR: Build process exited with error code $exitcode"
    exit $exitcode
else
    clear
    echo "[Apply Post-Build tweaks]"
    make rootfs-cpio rootfs-ext2
    pb_exitcode=$?
    if [ $pb_exitcode -eq 0 ]; then
        echo "[Build SUCCESS]"
        touch $BUILD_MARKER
        exit 0
    fi
fi
