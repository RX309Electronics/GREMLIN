#!/bin/bash
set -e

BUILD_MARKER="output/.build-complete"

# Define your target directory if not defined
: "${TARGET_DIR:=buildroot/output/target}"

# If the project is freshly built/has not been built, skip this postbuild script for now.
if [ ! -d "${TARGET_DIR}" ]; then
    echo "Project has not yet been built. Skipping post-build..."
    exit 0   # <--- Exit here if it's a fresh build
fi

#If the folders where created, but the process got interrupted somewhere, check for an additional compilation-finished marker, which is just an empty file, marking finished.
if [ ! -f "$BUILD_MARKER" ]; then
    echo "Project compilation has not yet been marked as done! Skipping post-build"
    exit 0
fi

echo "Target dir: ${TARGET_DIR}"
echo "[post-build tweaks]"
chmod 755 "${TARGET_DIR}/etc"
chmod 755 "${TARGET_DIR}/etc/X11"
chmod 755 "${TARGET_DIR}/etc/X11/xorg.conf.d"
chmod 644 "${TARGET_DIR}/etc/X11/xorg.conf.d/40-input.conf"
touch $BUILD_MARKER
sleep 1
rm -rf "${TARGET_DIR}/etc/init.d"
echo "[Post-build tweaks complete]"
