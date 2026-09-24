#!/bin/bash

# Color Codes for Modern Theme
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Function for Typewriter Animation Effect with Correct #9999 Logo
print_banner() {
    clear
    BANNER="
${PURPLE} #   #   ████   ████   ████   ████ ${NC}
${PURPLE} #   #  █    █ █    █ █    █ █    █${NC}
${PURPLE} #####   █████  █████  █████  █████${NC}
${PURPLE} #   #       █      █      █      █${NC}
${PURPLE} #   #   ████   ████   ████   ████ ${NC}
${CYAN}   #9999 AUTOMATED RECON & ENUMERATION TOOL       ${NC}
${BLUE}====================================================${NC}"

    # Print banner with a smooth typing/fade effect
    while IFS= read -r line; do
        echo -e "$line"
        sleep 0.04
    done <<< "$BANNER"
}

print_banner

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[!] Error: Please run this script with sudo (root privileges).${NC}"
  exit 1
fi

# Prompt for Target IP Address
read -p "[?] Enter Target IP Address: " TARGET_IP

if [ -z "$TARGET_IP" ]; then
    echo -e "${RED}[!] Error: IP address cannot be empty!${NC}"
    exit 1
fi

# Step 1: Ping Check (ICMP Packets)
echo -e "\n${YELLOW}[+] Checking if target $TARGET_IP is alive (ICMP Ping)...${NC}"
ping -c 3 -W 2 $TARGET_IP > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}[✔] Host is alive! ICMP packets successfully received.${NC}"
else
    echo -e "${RED}[!] Warning: Host did not respond to ICMP ping. Continuing anyway...${NC}"
fi

# Create Output Directory
OUTPUT_DIR="recon_$TARGET_IP"
mkdir -p $OUTPUT_DIR

# Step 2: Comprehensive Nmap Scan
echo -e "\n${YELLOW}[+] Starting Full Nmap Scan (All Ports & Service Detection)...${NC}"
nmap -p- --min-rate=2000 -sV -sC $TARGET_IP -oN "$OUTPUT_DIR/nmap_scan.txt"

echo -e "${GREEN}[✔] Nmap scan completed! Results saved to '$OUTPUT_DIR/nmap_scan.txt'.${NC}"

# Step 3: Universal FTP Anonymous Check
FTP_OPEN=false
FTP_ANON=false

if grep -Eq "([0-9]+/tcp\s+open\s+ftp)" "$OUTPUT_DIR/nmap_scan.txt"; then
    FTP_OPEN=true
    echo -e "\n${YELLOW}[+] FTP service detected. Checking for Anonymous Login...${NC}"
    
    if grep -q "ftp-anon: Anonymous FTP login allowed" "$OUTPUT_DIR/nmap_scan.txt"; then
        FTP_ANON=true
        echo -e "${GREEN}[✔] Yes! Anonymous Login Exists on FTP!${NC}"
        echo "Anonymous Login: SUCCESS" > "$OUTPUT_DIR/ftp_anon_check.txt"
    else
        echo -e "${RED}[-] Anonymous Login Doesn't Exist on this target's FTP.${NC}"
        echo "Anonymous Login: FAILED" > "$OUTPUT_DIR/ftp_anon_check.txt"
    fi
else
    echo -e "\n${RED}[-] No FTP service detected. Skipping FTP check.${NC}"
fi

# Step 4: Universal Web Enumeration
WORDLIST="/usr/share/wordlists/dirb/common.txt"
if [ ! -f "$WORDLIST" ]; then
    WORDLIST="/usr/share/wordlists/seclists/Discovery/Web-Content/directory-list-2.3-small.txt"
fi

WEB_PORTS=$(grep -E "open\s+http" "$OUTPUT_DIR/nmap_scan.txt" | awk -F'/' '{print $1}')

if [ -z "$WEB_PORTS" ]; then
    echo -e "\n${RED}[-] No HTTP/Web ports detected. Skipping Web Enum.${NC}"
else
    echo -e "\n${GREEN}[✔] Web service(s) detected dynamically! Starting Gobuster...${NC}"
    
    for PORT in $WEB_PORTS; do
        PROTOCOL="http"
        if [ "$PORT" -eq 443 ] || grep -q "$PORT/tcp.*ssl" "$OUTPUT_DIR/nmap_scan.txt"; then
            PROTOCOL="https"
        fi
        
        TARGET_URL="$PROTOCOL://$TARGET_IP:$PORT"
        echo -e "\n${YELLOW}[+] Running Gobuster on $TARGET_URL (Port $PORT)...${NC}"
        
        if [ -f "$WORDLIST" ]; then
            gobuster dir -u $TARGET_URL -w $WORDLIST -t 50 -o "$OUTPUT_DIR/gobuster_port_$PORT.txt" --no-error
            echo -e "${GREEN}[✔] Gobuster scan for port $PORT finished!${NC}"
        else
            echo -e "${RED}[!] Wordlist not found. Skipping.${NC}"
        fi
    done
fi

# Step 5: Final Summary Dashboard
echo -e "\n"
echo -e "${BLUE}====================================================${NC}"
echo -e "${CYAN}                 SCAN SUMMARY DASHBOARD             ${NC}"
echo -e "${BLUE}====================================================${NC}"
echo -e "${GREEN}[+] Target IP       :${NC} $TARGET_IP"
echo -e "${GREEN}[+] Report Folder   :${NC} $PWD/$OUTPUT_DIR"
echo -e "${GREEN}[+] Nmap Report     :${NC} $OUTPUT_DIR/nmap_scan.txt"

if [ "$FTP_OPEN" = true ]; then
    if [ "$FTP_ANON" = true ]; then
        echo -e "${GREEN}[+] FTP Anonymous   :${NC} ${GREEN}EXISTS (Success)${NC}"
    else
        echo -e "${RED}[+] FTP Anonymous   :${NC} ${RED}Does Not Exist${NC}"
    fi
fi

if [ ! -z "$WEB_PORTS" ]; then
    echo -e "${GREEN}[+] Web Scans       :${NC}"
    for PORT in $WEB_PORTS; do
        echo -e "                      -> Port $PORT : $OUTPUT_DIR/gobuster_port_$PORT.txt"
    done
fi

echo -e "${BLUE}====================================================${NC}"
echo -e "${CYAN}          All tasks completed successfully!         ${NC}"
echo -e "${BLUE}====================================================${NC}"
