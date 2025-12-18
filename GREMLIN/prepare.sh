#!/bin/bash

BR_CONFIG="buildroot-external/configs/buildroot.config"
BR_URL="https://buildroot.org/downloads/buildroot-2025.02.9.tar.xz"
CONFIGURE_LOG="prepare.log"
GREMLIN_VERSION="2025-03-15"

clear
sleep 1

# Download + extract Buildroot if needed
if [ ! -d "buildroot" ]; then
    if [ ! -f "buildroot.tar.xz" ]; then
        echo "[Download Buildroot]"
        wget "$BR_URL" -O buildroot.tar.xz >> "$CONFIGURE_LOG" 2>&1
        sleep 1
        echo "Done!"
        sleep 1
    fi

    echo "[Extract Buildroot]"
    mkdir -p buildroot
    tar -xvf buildroot.tar.xz -C buildroot --strip-components=1 >> "$CONFIGURE_LOG" 2>&1
    sleep 1
    echo "Done!"
else
    echo "Buildroot already downloaded and extracted. Skipping this step."
fi

sleep 1

# Configure Buildroot
if [ ! -f "buildroot/.config" ]; then
    echo "[Configure Buildroot]"
    sleep 1
    cd buildroot
    make pc_x86_64_efi_defconfig >> "../$CONFIGURE_LOG" 2>&1
    echo "Copying GREMLIN config..."
    cp "../$BR_CONFIG" .config
    echo "Done!"
    cd ..
else
    if grep -qF "GREMLIN_BUILDID=$GREMLIN_VERSION" buildroot/.config; then
        echo "$GREMLIN_VERSION"
        echo "Buildroot already configured with GREMLIN config. Skipping this step."
        echo "GREMLIN_VERSION=$GREMLIN_VERSION"
    else
        echo "$GREMLIN_VERSION"
        echo "[(Re)Configure Buildroot]"
        sleep 1
        cd buildroot
        make pc_x86_64_efi_defconfig >> "../$CONFIGURE_LOG" 2>&1
        cp "../$BR_CONFIG" .config
        echo "Done!"
        cd ..
    fi
fi

# Cleanup
echo "[Cleanup]"
if [ -d "buildroot" ] && [ -f "buildroot.tar.xz" ]; then
    rm -f buildroot.tar.xz
    echo "Done!"
else
    echo "Nothing to clean up."
fi

if [ -f "prepare.log" ]; then
    read -p "Do you want to remove the log file? {y/n}?: " yn
    [ "$yn" = "y" ] && rm -f prepare.log
fi


