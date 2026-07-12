# Top 100 Security Tools for Kali iOS

A curated reference of the top 100 penetration-testing and security tools you
can run inside the **Kali iOS** environment (Kali Linux in text mode via the
iSH Shell). Tools are grouped by category so the built-in AI assistant — or a
human operator — can quickly find the right one for a task.

> **⚠️ Legal & Ethical Notice**
> These tools are for **educational purposes and authorized security
> assessments only**. Only test systems, networks, and accounts that you own
> or have **explicit written permission** to assess. Unauthorized access to
> computer systems is illegal in most jurisdictions. You are solely
> responsible for your actions.

> **📱 iOS / iSH note**
> Kali iOS runs on the iSH emulator (x86 usermode). It is single-core, has no
> real kernel access, and no raw Wi-Fi radio control. Tools that need root
> hardware access — raw packet injection, monitor-mode Wi-Fi, kernel modules,
> USB — will have **limited or no functionality** on stock iOS. Such tools are
> marked *(limited on iOS)*. They remain useful for learning, scripting, and
> remote work against lab targets.

---

## Table of Contents

1. [Information Gathering & Reconnaissance](#1-information-gathering--reconnaissance)
2. [Vulnerability Analysis](#2-vulnerability-analysis)
3. [Web Application Analysis](#3-web-application-analysis)
4. [Database Assessment](#4-database-assessment)
5. [Password Attacks](#5-password-attacks)
6. [Wireless Attacks](#6-wireless-attacks)
7. [Exploitation Frameworks](#7-exploitation-frameworks)
8. [Sniffing & Spoofing](#8-sniffing--spoofing)
9. [Reverse Engineering](#9-reverse-engineering)
10. [Post-Exploitation](#10-post-exploitation)
11. [Forensics](#11-forensics)
12. [Reporting & Utilities](#12-reporting--utilities)

---

## 1. Information Gathering & Reconnaissance

| # | Tool | What it does | Quick start |
|---|------|--------------|-------------|
| 1 | **Nmap** | Network/port scanner & host discovery; the de-facto recon standard. | `nmap -sV -sC target.com` |
| 2 | **Masscan** | Internet-scale asynchronous port scanner (very fast). | `masscan -p1-65535 10.0.0.0/24 --rate=1000` |
| 3 | **dnsrecon** | DNS enumeration: records, zone transfers, brute force. | `dnsrecon -d target.com` |
| 4 | **dnsenum** | Multithreaded DNS info gathering. | `dnsenum target.com` |
| 5 | **Fierce** | DNS reconnaissance / subdomain locator. | `fierce --domain target.com` |
| 6 | **theHarvester** | OSINT: emails, subdomains, hosts from public sources. | `theHarvester -d target.com -b all` |
| 7 | **Amass** | In-depth subdomain enumeration & attack-surface mapping. | `amass enum -d target.com` |
| 8 | **Sublist3r** | Fast subdomain enumeration via search engines. | `sublist3r -d target.com` |
| 9 | **whois** | Domain / IP registration lookups. | `whois target.com` |
| 10 | **Recon-ng** | Full modular OSINT reconnaissance framework. | `recon-ng` |
| 11 | **SpiderFoot** | Automated OSINT & attack-surface intelligence. | `spiderfoot -l 127.0.0.1:5001` |
| 12 | **Maltego (CE)** | Visual link-analysis / OSINT graphing. | GUI-oriented; use CE transforms |
| 13 | **Netdiscover** | ARP-based host discovery on a LAN. *(limited on iOS)* | `netdiscover -r 10.0.0.0/24` |
| 14 | **dmitry** | Deepmagic info-gathering (whois, subdomains, ports). | `dmitry -winse target.com` |
| 15 | **Shodan CLI** | Query the Shodan search engine for exposed devices. | `shodan search apache` |
| 16 | **Nikto** | Web server scanner for known issues & misconfig. | `nikto -h http://target.com` |
| 17 | **WhatWeb** | Fingerprints web technologies / CMS. | `whatweb target.com` |
| 18 | **wafw00f** | Detects and fingerprints web application firewalls. | `wafw00f https://target.com` |

## 2. Vulnerability Analysis

| # | Tool | What it does | Quick start |
|---|------|--------------|-------------|
| 19 | **OpenVAS / GVM** | Full-featured vulnerability scanner & manager. | `gvm-setup && gvm-start` |
| 20 | **Nuclei** | Fast template-based vulnerability scanner. | `nuclei -u https://target.com` |
| 21 | **Nessus (Essentials)** | Industry-standard vuln scanner (free tier). | Web UI on `:8834` |
| 22 | **Lynis** | Security auditing & hardening for Unix hosts. | `lynis audit system` |
| 23 | **Legion** | Automated network recon + vuln discovery frontend. | `legion` |
| 24 | **Vuls** | Agentless Linux/BSD vulnerability scanner. | `vuls scan` |
| 25 | **searchsploit** | Offline search of the Exploit-DB archive. | `searchsploit apache 2.4` |
| 26 | **nmap NSE (vuln)** | Nmap scripting engine vuln category. | `nmap --script vuln target.com` |

## 3. Web Application Analysis

| # | Tool | What it does | Quick start |
|---|------|--------------|-------------|
| 27 | **Burp Suite** | The leading web proxy / app-testing platform. | Launch, set browser proxy `127.0.0.1:8080` |
| 28 | **OWASP ZAP** | Open-source web app scanner & intercepting proxy. | `zaproxy` |
| 29 | **sqlmap** | Automated SQL-injection detection & exploitation. | `sqlmap -u "http://t/?id=1" --batch` |
| 30 | **Gobuster** | Directory / DNS / vhost brute-forcing (Go). | `gobuster dir -u http://t -w list.txt` |
| 31 | **ffuf** | Fast web fuzzer for content & parameters. | `ffuf -u http://t/FUZZ -w list.txt` |
| 32 | **dirb / dirbuster** | Classic web content brute-forcers. | `dirb http://target.com` |
| 33 | **wpscan** | WordPress vulnerability & user enumeration. | `wpscan --url http://t --enumerate u` |
| 34 | **Nikto** | (see recon) also core to web testing. | `nikto -h http://target.com` |
| 35 | **wfuzz** | Web app fuzzer for params, dirs, auth. | `wfuzz -w list.txt http://t/FUZZ` |
| 36 | **XSStrike** | Advanced XSS detection & fuzzing suite. | `xsstrike -u "http://t/?q=1"` |
| 37 | **commix** | Automated command-injection exploitation. | `commix -u "http://t/?p=1"` |
| 38 | **Arjun** | HTTP parameter discovery. | `arjun -u https://target.com` |
| 39 | **Wapiti** | Black-box web application vulnerability scanner. | `wapiti -u http://target.com` |
| 40 | **Skipfish** | High-speed active web recon scanner. | `skipfish -o out http://t` |
| 41 | **cadaver** | WebDAV client for testing DAV endpoints. | `cadaver http://target.com/dav` |
| 42 | **whatweb** | Web tech fingerprinting (also recon). | `whatweb -a3 target.com` |

## 4. Database Assessment

| # | Tool | What it does | Quick start |
|---|------|--------------|-------------|
| 43 | **sqlmap** | SQLi discovery + DB takeover (also web). | `sqlmap -u URL --dbs` |
| 44 | **NoSQLMap** | Automated NoSQL (MongoDB, etc.) injection. | `nosqlmap` |
| 45 | **jSQL Injection** | Java GUI for automatic SQL injection. | `jsql` |
| 46 | **sqlninja** | MSSQL injection exploitation toolkit. | `sqlninja -m test` |
| 47 | **mssql / mysql clients** | Direct DB connection & manual assessment. | `mysql -h host -u user -p` |
| 48 | **oscanner** | Oracle database assessment tool. | `oscanner -s target -P 1521` |

## 5. Password Attacks

| # | Tool | What it does | Quick start |
|---|------|--------------|-------------|
| 49 | **John the Ripper** | Versatile offline password cracker. | `john --wordlist=rockyou.txt hash.txt` |
| 50 | **Hashcat** | GPU-accelerated password recovery. *(CPU-only on iOS)* | `hashcat -m 0 hash.txt rockyou.txt` |
| 51 | **Hydra** | Fast online brute-forcer (many protocols). | `hydra -l admin -P list.txt ssh://t` |
| 52 | **Medusa** | Parallel network login brute-forcer. | `medusa -h t -u admin -P list.txt -M ssh` |
| 53 | **Ncrack** | High-speed network auth cracking. | `ncrack -p 22 --user admin -P list.txt t` |
| 54 | **CeWL** | Custom wordlist generator from web content. | `cewl http://target.com -w words.txt` |
| 55 | **Crunch** | Wordlist generator by pattern/charset. | `crunch 6 8 abc123 -o list.txt` |
| 56 | **hashid / hash-identifier** | Identify hash types. | `hashid '5f4dcc3b...'` |
| 57 | **hashcat-utils** | Wordlist & mask helper utilities. | `combinator a.txt b.txt` |
| 58 | **Patator** | Multi-purpose modular brute-forcer. | `patator ssh_login host=t user=admin ...` |
| 59 | **chntpw** | Reset / edit Windows SAM passwords offline. | `chntpw -i SAM` |
| 60 | **CrackMapExec** | AD/SMB post-exploitation & credential sweep. | `crackmapexec smb 10.0.0.0/24` |

## 6. Wireless Attacks

*(Wi-Fi radio control is unavailable on stock iOS — these are for learning,
scripting, and use with external adapters on supported platforms.)*

| # | Tool | What it does | Quick start |
|---|------|--------------|-------------|
| 61 | **Aircrack-ng** | Wi-Fi WEP/WPA cracking suite. *(limited on iOS)* | `aircrack-ng capture.cap` |
| 62 | **Reaver** | WPS PIN brute-force attack. *(limited on iOS)* | `reaver -i wlan0 -b BSSID` |
| 63 | **Wifite** | Automated wireless auditing wrapper. *(limited on iOS)* | `wifite` |
| 64 | **Kismet** | Wireless network detector / sniffer. *(limited on iOS)* | `kismet` |
| 65 | **Bully** | Alternative WPS brute-forcer. *(limited on iOS)* | `bully wlan0 -b BSSID` |
| 66 | **Fern Wifi Cracker** | GUI wireless security auditor. *(limited on iOS)* | `fern-wifi-cracker` |
| 67 | **hcxdumptool / hcxtools** | Capture & convert PMKID/handshakes. *(limited on iOS)* | `hcxdumptool -i wlan0` |
| 68 | **MDK4** | Wireless stress/deauth testing. *(limited on iOS)* | `mdk4 wlan0 d` |
| 69 | **Bettercap** | Modular network attack & MITM framework. | `bettercap -iface eth0` |

## 7. Exploitation Frameworks

| # | Tool | What it does | Quick start |
|---|------|--------------|-------------|
| 70 | **Metasploit Framework** | The premier exploitation & payload platform. | `msfconsole` |
| 71 | **msfvenom** | Payload generator/encoder (part of MSF). | `msfvenom -p linux/x86/... -f elf` |
| 72 | **Exploit-DB / searchsploit** | Archive of public exploits. | `searchsploit -m 12345` |
| 73 | **BeEF** | Browser Exploitation Framework. | `beef-xss` |
| 74 | **SET (Social-Engineer Toolkit)** | Social-engineering attack simulations. | `setoolkit` |
| 75 | **RouterSploit** | Exploitation framework for embedded/IoT. | `rsf` then `use exploits/...` |
| 76 | **Sliver** | Modern open-source C2 framework. | `sliver-server` |
| 77 | **Empire / Starkiller** | PowerShell/Python post-exploit C2. | `powershell-empire server` |
| 78 | **Villain** | Multi-session backdoor & C2 handler. | `villain` |

## 8. Sniffing & Spoofing

| # | Tool | What it does | Quick start |
|---|------|--------------|-------------|
| 79 | **Wireshark** | Deep packet capture & protocol analysis. *(capture limited on iOS)* | `wireshark` / `tshark` |
| 80 | **tcpdump** | Command-line packet capture. *(limited on iOS)* | `tcpdump -i any -w cap.pcap` |
| 81 | **Ettercap** | MITM suite for LAN sniffing/spoofing. *(limited on iOS)* | `ettercap -T -M arp` |
| 82 | **Bettercap** | Modern MITM/recon framework (also wireless). | `bettercap` |
| 83 | **Responder** | LLMNR/NBT-NS/mDNS poisoner & credential grabber. | `responder -I eth0` |
| 84 | **mitmproxy** | Interactive HTTPS intercepting proxy. | `mitmproxy` |
| 85 | **dnschef** | Configurable DNS proxy for spoofing. | `dnschef --fakeip 10.0.0.1` |
| 86 | **arpspoof (dsniff)** | ARP cache poisoning utility. *(limited on iOS)* | `arpspoof -t victim gateway` |
| 87 | **scapy** | Interactive packet crafting in Python. | `scapy` |

## 9. Reverse Engineering

| # | Tool | What it does | Quick start |
|---|------|--------------|-------------|
| 88 | **Ghidra** | NSA's full-featured reverse-engineering suite. | `ghidra` |
| 89 | **radare2 / rizin** | Command-line RE & binary analysis framework. | `r2 ./binary` |
| 90 | **GDB (+ pwndbg/gef)** | Debugger with exploit-dev enhancements. | `gdb ./binary` |
| 91 | **objdump / binutils** | Disassembly & object inspection. | `objdump -d ./binary` |
| 92 | **strings** | Extract printable strings from binaries. | `strings ./binary` |
| 93 | **Cutter** | GUI frontend for radare2/rizin. | `cutter` |
| 94 | **apktool** | Decompile / rebuild Android APKs. | `apktool d app.apk` |
| 95 | **jadx** | Android DEX-to-Java decompiler. | `jadx app.apk` |

## 10. Post-Exploitation

| # | Tool | What it does | Quick start |
|---|------|--------------|-------------|
| 96 | **Mimikatz** | Windows credential extraction (via MSF/CME). | `sekurlsa::logonpasswords` |
| 97 | **LinPEAS / WinPEAS** | Automated privilege-escalation enumeration. | `./linpeas.sh` |
| 98 | **pspy** | Snoop on processes without root. | `./pspy64` |

## 11. Forensics

| # | Tool | What it does | Quick start |
|---|------|--------------|-------------|
| 99 | **Autopsy / Sleuth Kit** | Digital-forensics disk analysis platform. | `autopsy` / `fls -r image.dd` |
| 100 | **Volatility** | Memory-forensics framework. | `vol.py -f mem.raw windows.info` |

---

## 12. Reporting & Utilities

Beyond the ranked 100, these general-purpose utilities are indispensable
for scripting, pivoting, and reporting inside Kali iOS:

- **netcat (nc) / socat** — Swiss-army networking, listeners, and relays.
- **curl / wget** — HTTP clients for probing and data transfer.
- **git** — Clone tools and manage engagement notes.
- **tmux / screen** — Persist sessions across the iSH terminal.
- **jq** — Parse JSON output from scanners and APIs.
- **proxychains** — Route tools through SOCKS/HTTP proxies for pivoting.
- **openssl** — Certificate inspection, hashing, and crypto testing.
- **CherryTree / Faraday** — Organize findings and write up reports.

---

## How the AI Assistant Should Use This List

When a user describes a goal, map it to a category, then a tool:

| User goal | Category | Suggested tools |
|-----------|----------|-----------------|
| "Find live hosts / open ports" | Recon | Nmap, Masscan, Netdiscover |
| "Enumerate subdomains" | Recon | Amass, Sublist3r, dnsrecon |
| "Scan a website for issues" | Web / Vuln | Nikto, Nuclei, ZAP, OWASP tools |
| "Test for SQL injection" | Web / DB | sqlmap |
| "Crack a captured hash" | Passwords | John, Hashcat, hashid |
| "Brute-force a login" | Passwords | Hydra, Medusa (authorized only) |
| "Analyze a binary" | Reverse Eng. | Ghidra, radare2, GDB |
| "Inspect network traffic" | Sniffing | Wireshark, tcpdump, tshark |

Always confirm the user has **authorization** for the target before
suggesting or running any active or intrusive tool.

---

*This document is part of the [Kali iOS](README.md) project and is provided
for educational and authorized security-testing use only. See the project
[Disclaimer](README.md#disclaimer).*
