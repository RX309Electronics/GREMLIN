#!/bin/sh

# Run xinput_calibrator and capture its output
echo "Opening calibration menu"
sleep 1
calibration_output=$(xinput_calibrator)

# Extract the calibration snippet
calibration_snippet=$(echo "$calibration_output" | awk '/Section "InputClass"/,/EndSection/')


SAVE_PATH="/etc/X11/xorg.conf.d/99-calibration.conf"

if [ -n "$calibration_snippet" ]; then
    echo "$calibration_snippet" > "$SAVE_PATH"
    echo "Calibration saved to $SAVE_PATH"
else
    echo "No calibration snippet found!"
fi
