<p align="center">
  <h1 align="center">🐉 Advanced Recon Suite (AutoRecon-999)</h1>
</p>

<p align="center">
  <b>An advanced and automated reconnaissance tool designed for cybersecurity professionals and penetration testers.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Version-1.0.0-blue.svg?style=for-the-badge" alt="Version">
  <img src="https://img.shields.io/badge/Python-3.x-orange.svg?style=for-the-badge" alt="Python">
  <img src="https://img.shields.io/badge/Platform-Kali%20Linux-red.svg?style=for-the-badge" alt="Platform">
</p>

---

## 🚀 Overview

**AutoRecon-999** streamlines the initial information-gathering phase during penetration testing. By chaining live host discovery, port scanning, service version analysis, anonymous FTP checks, and automated web directory fuzzing into a single workflow, it saves valuable time for security analysts.

---

## ✨ Features

- **Host Discovery:** Sends ICMP packets to check if the target host is alive.
- **Detailed Port Scanning:** Runs deep Nmap scans to detect open ports and running services.
- **FTP Vulnerability Check:** Automatically checks if FTP is open and attempts an Anonymous Login. Flags potentially exploitable service versions.
- **Web Fuzzing (Gobuster):** Automatically detects if HTTP (Port 80) or HTTPS (Port 443) is open and initiates directory fuzzing using Gobuster.

---

## 📥 Installation

Clone the repository and set up the required dependencies on your Kali Linux system:

```bash
# Clone the repository
git clone [https://github.com/NullByte999/AutoRecon-999.git](https://github.com/NullByte999/AutoRecon-999.git)

# Navigate into the tool directory
cd AutoRecon-999

# Give execution permissions (if required)
chmod +x <your-script-name>.py
