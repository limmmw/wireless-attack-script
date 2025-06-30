#!/bin/bash

INTERFACE="wlp3s0"  # Ganti sesuai nama interface kamu

# Fungsi untuk mematikan service pengganggu
stop_services() {
    echo "[*] Mematikan NetworkManager dan wpa_supplicant..."
    sudo systemctl stop NetworkManager 2>/dev/null
    sudo systemctl stop wpa_supplicant 2>/dev/null
}

# Fungsi untuk menyalakan kembali service
start_services() {
    echo "[*] Menyalakan kembali NetworkManager dan wpa_supplicant..."
    sudo systemctl start NetworkManager 2>/dev/null
    sudo systemctl start wpa_supplicant 2>/dev/null
}

# Fungsi untuk masuk monitor mode
enable_monitor() {
    echo "[*] Mengaktifkan monitor mode pada $INTERFACE..."
    stop_services
    sudo ip link set $INTERFACE down
    sudo iw dev $INTERFACE set type monitor
    sudo ip link set $INTERFACE up
    echo "[✔] $INTERFACE sekarang berada di monitor mode."
}

# Fungsi untuk keluar monitor mode (kembali ke managed mode)
disable_monitor() {
    echo "[*] Mengembalikan ke managed mode..."
    sudo ip link set $INTERFACE down
    sudo iw dev $INTERFACE set type managed
    sudo ip link set $INTERFACE up
    start_services
    echo "[✔] $INTERFACE kembali ke mode normal."
}

# Menu utama
clear
echo "=== Monitor Mode Toggle ==="
echo "[1] Masuk ke monitor mode"
echo "[2] Kembali ke managed mode"
echo "[3] Keluar"
read -p "[?] Pilih opsi: " pilih

case $pilih in
    1) enable_monitor ;;
    2) disable_monitor ;;
    3) exit ;;
    *) echo "[!] Pilihan tidak valid." ;;
esac

