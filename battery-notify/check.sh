#!/bin/bash

CONFIG_DIR="$HOME/.config/battery-notify"
ROFI_SCRIPT="$HOME/.config/rofi/scripts/battery-warning.sh"

# Auto-detect battery (BAT0, BAT1, etc.)
BATTERY=$(ls /sys/class/power_supply | grep -E "BAT" | head -n1)
BAT_PATH="/sys/class/power_supply/$BATTERY"

THRESHOLD=20
STATE_FILE="$CONFIG_DIR/.notified"

capacity=$(cat "$BAT_PATH/capacity")
status=$(cat "$BAT_PATH/status")

if [ "$status" = "Discharging" ] && [ "$capacity" -le "$THRESHOLD" ]; then
    if [ ! -f "$STATE_FILE" ]; then
        "$ROFI_SCRIPT" "$capacity"
        touch "$STATE_FILE"
    fi
else
    [ "$status" = "Charging" ] && rm -f "$STATE_FILE"
fi
