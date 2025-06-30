#!/bin/bash

INTERFACE="wlp3s0"  # Ganti sesuai nama interface kamu

stop_services() {
    echo "[*] Disable NetworkManager and wpa_supplicant..."
    sudo systemctl stop NetworkManager 2>/dev/null
    sudo systemctl stop wpa_supplicant 2>/dev/null
}

start_services() {
    echo "[*] Activate NetworkManager dan wpa_supplicant..."
    sudo systemctl start NetworkManager 2>/dev/null
    sudo systemctl start wpa_supplicant 2>/dev/null
}

enable_monitor() {
    echo "[*] Activate monitor mode on $INTERFACE..."
    stop_services
    sudo ip link set $INTERFACE down
    sudo iw dev $INTERFACE set type monitor
    sudo ip link set $INTERFACE up
    echo "[✔] $INTERFACE Now on the Monitor Mode."
}

disable_monitor() {
    echo "[*] Set back to Normal Mode..."
    sudo ip link set $INTERFACE down
    sudo iw dev $INTERFACE set type managed
    sudo ip link set $INTERFACE up
    start_services
    echo "[✔] $INTERFACE Back to Normal Mode."
}

clear
echo "=== Monitor Mode Toggle ==="
echo "[1] Enter to Monitor Mode"
echo "[2] Enter to Manage Mode"
echo "[3] Exit"
read -p "[?] Choose Options: " Choose

case $pilih in
    1) enable_monitor ;;
    2) disable_monitor ;;
    3) exit ;;
    *) echo "[!] Invalid Choice." ;;
esac

