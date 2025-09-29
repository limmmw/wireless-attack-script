#!/bin/bash

GREEN='\033[1;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Check dependencies
for cmd in iw ip systemctl; do
    if ! command -v $cmd &>/dev/null; then
        echo -e "${RED}[!] $cmd not found. Please install it first.${RESET}"
        exit 1
    fi
done

# List available wireless interfaces
echo -e "${YELLOW}[*] Available wireless interfaces:${RESET}"
iw dev | awk '$1=="Interface"{print " - "$2}'
read -p "[?] Enter your wireless interface: " INTERFACE
if [ -z "$INTERFACE" ]; then
    echo -e "${RED}[!] Interface cannot be empty.${RESET}"
    exit 1
fi

stop_services() {
    echo "[*] Disabling NetworkManager and wpa_supplicant..."
    sudo systemctl stop NetworkManager 2>/dev/null
    sudo systemctl stop wpa_supplicant 2>/dev/null
}

start_services() {
    echo "[*] Enabling NetworkManager and wpa_supplicant..."
    sudo systemctl start NetworkManager 2>/dev/null
    sudo systemctl start wpa_supplicant 2>/dev/null
}

get_mode() {
    iw dev "$INTERFACE" info | grep -i type | awk '{print $2}'
}

enable_monitor() {
    if [ "$(get_mode)" == "monitor" ]; then
        echo -e "${GREEN}[✔] $INTERFACE is already in Monitor Mode.${RESET}"
        return
    fi
    stop_services
    sudo ip link set "$INTERFACE" down
    sudo iw dev "$INTERFACE" set type monitor
    sudo ip link set "$INTERFACE" up
    echo -e "${GREEN}[✔] $INTERFACE is now in Monitor Mode.${RESET}"
}

disable_monitor() {
    if [ "$(get_mode)" == "managed" ]; then
        echo -e "${GREEN}[✔] $INTERFACE is already in Managed Mode.${RESET}"
        return
    fi
    sudo ip link set "$INTERFACE" down
    sudo iw dev "$INTERFACE" set type managed
    sudo ip link set "$INTERFACE" up
    start_services
    echo -e "${GREEN}[✔] $INTERFACE is now back to Managed Mode.${RESET}"
}

clear
echo -e "${GREEN}=== Monitor Mode Toggle ===${RESET}"
echo "[1] Enter Monitor Mode"
echo "[2] Enter Managed Mode"
echo "[3] Show Current Mode"
echo "[4] Exit"
read -p "[?] Choose Option: " Choose

case $Choose in
    1) enable_monitor ;;
    2) disable_monitor ;;
    3) 
        MODE=$(get_mode)
        echo -e "${YELLOW}[*] $INTERFACE current mode: $MODE${RESET}"
        ;;
    4) exit ;;
    *) echo -e "${RED}[!] Invalid Choice.${RESET}" ;;
esac