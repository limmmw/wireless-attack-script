# 🔥 Deauth Attack Script + Interface Toggle Tool

A dual-script Bash toolkit to automate wireless deauthentication attacks and manage wireless interface modes like a pro — inspired by tools like Airgeddon, with a flashy multi-terminal interface.

## 📂 Contents

- `deauth.sh`  
  Launches 4 synchronized red-themed xterm windows to perform deauthentication attacks using `aireplay-ng`.

- `toggle.sh`  
  Quickly toggle your WiFi interface into **Monitor Mode** or back to **Managed Mode** (with service control).

---

## ⚙️ Requirements

Make sure the following tools are installed:

```bash
sudo apt update
sudo apt install aircrack-ng xterm iw net-tools
```

## 🛠 Setup
1. Clone this repo:
   ```bash
   git clone https://github.com/limmmw/wireless-attack-script.git
   cd wireless-attack-script

2. Make the script executable:
   ```bash
   chmod +x deauth-multi.sh toggle.sh

Before running any script, edit the interface name inside both files:
```bash
# Inside toggle.sh and deauth-multi.sh
INTERFACE="wlp3s0"  # ← CHANGE THIS to match your system (e.g., wlan0, wlan1, etc.)
```
You can check your wireless interface name using:
```bash
iwconfig
```

## 🚀 Usage
1. Run toggle Scirpt
   ```bash
   ./toggle.sh

Choose [1] to switch your wireless card to Monitor Mode.

2. Start Deauth Attack:
   ```bash
   ./deauth.sh

Features:
- Interactive BSSID and channel input
- Choose between single client or all-clients deauth.
- To stop the Attack, press CTRL+C on the main terminal.

3. Restore interface:
   ```bash
   ./toggle.sh
Choose [2] to restore normal network functionality.

## ADDITIONAL
mutli-deauth.sh still doesn't work yet, this scirpt is used for multiple-selected-targets deauth attack. We will fix it soon.

## 🛡 Disclaimer
⚠️ For educational and authorized testing only.

Unauthorized access to wireless networks is illegal. The developer assumes no responsibility for any misuse.

## 🧑‍💻 Author
limmmw

🔗 https://github.com/limmmw