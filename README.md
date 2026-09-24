# AutoRecon-9999
An advanced and automated reconnaissance tool designed for cybersecurity professionals and penetration testers. It performs live host discovery via ICMP, executes detailed Nmap scans, automatically tests for Anonymous FTP logins and exploitable service versions, and runs Gobuster directory fuzzing on HTTP/HTTPS ports.

# 🚀 Advanced Recon Suite (ReconDragon v1.0)

An all-in-one automated reconnaissance script built for penetration testing and bug bounty hunting. It streamlines the initial information-gathering phase by chaining live host discovery, port scanning, vulnerability detection, and web fuzzing into a single workflow.

## 🛠️ Features
- **Host Discovery:** Sends ICMP packets to check if the target host is alive.
- **Detailed Port Scanning:** Runs comprehensive Nmap scans to detect open ports and services.
- **FTP Vulnerability Check:** Automatically checks if FTP is open and attempts an Anonymous Login. Version analysis flags potentially exploitable services.
- **Web Fuzzing (Gobuster):** Automatically detects if HTTP (Port 80) or HTTPS (Port 443/custom) is open and initiates directory fuzzing using Gobuster.

## ⚙️ How It Works
1. Inputs a target IP address.
2. Checks host live status via ICMP.
3. Executes deep Nmap enumeration.
4. Automatically branches into FTP anonymous tests and Gobuster web directory discovery based on open ports.
