#!/bin/sh
# ---------------------------------------------------------------------------
# kali-ai.sh — All-in-One AI Assistant for Kali iOS
#
# A single, self-contained assistant you talk to from your iPhone terminal.
# Describe what you want in plain language; it maps your goal to the right
# Kali tool, gives you the command, and (with your confirmation) runs it.
#
#   * Works fully OFFLINE with a built-in rule-based advisor.
#   * Upgrades to real conversational AI when you add a Claude API key.
#   * Refuses to run active tools without an explicit authorization check.
#
# Part of the Kali iOS project. Educational / authorized testing use ONLY.
# ---------------------------------------------------------------------------
set -u

VERSION="1.0.0"
CONFIG_DIR="${HOME}/.kali-ai"
CONFIG_FILE="${CONFIG_DIR}/config"
API_URL="https://api.anthropic.com/v1/messages"
ANTHROPIC_VERSION="2023-06-01"
DEFAULT_MODEL="claude-sonnet-5"

# Runtime config (overridable via config file / env)
ANTHROPIC_API_KEY="${ANTHROPIC_API_KEY:-}"
MODEL="${KALI_AI_MODEL:-$DEFAULT_MODEL}"

# --- Colors (disabled when not a terminal) ---------------------------------
if [ -t 1 ]; then
    C_RESET='\033[0m'; C_BOLD='\033[1m'; C_DIM='\033[2m'
    C_RED='\033[31m'; C_GRN='\033[32m'; C_YEL='\033[33m'
    C_BLU='\033[34m'; C_CYN='\033[36m'
else
    C_RESET=''; C_BOLD=''; C_DIM=''
    C_RED=''; C_GRN=''; C_YEL=''; C_BLU=''; C_CYN=''
fi

say()  { printf '%b\n' "$1"; }
info() { printf '%b\n' "${C_CYN}$1${C_RESET}"; }
ok()   { printf '%b\n' "${C_GRN}$1${C_RESET}"; }
warn() { printf '%b\n' "${C_YEL}$1${C_RESET}"; }
err()  { printf '%b\n' "${C_RED}$1${C_RESET}"; }
have() { command -v "$1" >/dev/null 2>&1; }

# --- Config persistence -----------------------------------------------------
load_config() {
    [ -f "$CONFIG_FILE" ] && . "$CONFIG_FILE"
    MODEL="${MODEL:-$DEFAULT_MODEL}"
}

save_config() {
    mkdir -p "$CONFIG_DIR"
    umask 077
    {
        printf 'ANTHROPIC_API_KEY=%s\n' "'${ANTHROPIC_API_KEY}'"
        printf 'MODEL=%s\n' "'${MODEL}'"
    } > "$CONFIG_FILE"
    chmod 600 "$CONFIG_FILE" 2>/dev/null || true
}

# --- Banner -----------------------------------------------------------------
banner() {
    say ""
    say "${C_CYN}${C_BOLD}  ┌───────────────────────────────────────────────┐${C_RESET}"
    say "${C_CYN}${C_BOLD}  │   KALI iOS · All-in-One AI Assistant  v${VERSION}   │${C_RESET}"
    say "${C_CYN}${C_BOLD}  └───────────────────────────────────────────────┘${C_RESET}"
    if [ -n "$ANTHROPIC_API_KEY" ]; then
        say "  ${C_DIM}Mode:${C_RESET} ${C_GRN}online AI${C_RESET} ${C_DIM}(${MODEL})${C_RESET}"
    else
        say "  ${C_DIM}Mode:${C_RESET} ${C_YEL}offline advisor${C_RESET} ${C_DIM}(add an API key for full AI)${C_RESET}"
    fi
    say ""
}

# ---------------------------------------------------------------------------
# Knowledge base: map a plain-language goal to Kali tools.
# Used offline, and also given to the online model as grounding.
# ---------------------------------------------------------------------------
offline_advisor() {
    q=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
    matched=0
    suggest() {
        matched=1
        say "  ${C_GRN}▸${C_RESET} ${C_BOLD}$1${C_RESET}"
        say "    ${C_DIM}$2${C_RESET}"
        say "    ${C_CYN}$3${C_RESET}"
        say ""
    }

    case "$q" in
        *port*|*open\ service*|*service\ scan*|*host*discov*|*live\ host*|*network\ scan*)
            suggest "Nmap" "Port scan, service/version detection, host discovery." "nmap -sV -sC <target>" ;;
    esac
    case "$q" in
        *fast\ scan*|*whole\ range*|*mass\ scan*|*internet\ scan*)
            suggest "Masscan" "Very fast asynchronous port scanner." "masscan -p1-65535 <cidr> --rate=1000" ;;
    esac
    case "$q" in
        *subdomain*|*dns\ enum*|*enumerate\ dns*|*find\ domain*)
            suggest "Amass / Sublist3r / dnsrecon" "Subdomain & DNS enumeration." "amass enum -d <domain>" ;;
    esac
    case "$q" in
        *osint*|*email*harvest*|*public\ info*|*recon\ person*)
            suggest "theHarvester / Recon-ng / SpiderFoot" "OSINT & attack-surface intel." "theHarvester -d <domain> -b all" ;;
    esac
    case "$q" in
        *sql*inject*|*sqli*|*database\ inject*)
            suggest "sqlmap" "Automated SQL-injection detection & exploitation." "sqlmap -u \"<url>?id=1\" --batch" ;;
    esac
    case "$q" in
        *scan*web*|*website\ vuln*|*web\ vuln*|*check\ website*|*web\ server\ scan*)
            suggest "Nikto / Nuclei / OWASP ZAP" "Web server & app vulnerability scanning." "nuclei -u https://<target>" ;;
    esac
    case "$q" in
        *directory\ brute*|*hidden\ dir*|*find\ dir*|*content\ discov*|*fuzz*dir*)
            suggest "ffuf / Gobuster" "Directory & content brute-forcing." "ffuf -u https://<target>/FUZZ -w list.txt" ;;
    esac
    case "$q" in
        *wordpress*|*wp\ scan*|*cms*)
            suggest "wpscan / WhatWeb" "CMS fingerprinting & WordPress auditing." "wpscan --url <url> --enumerate u" ;;
    esac
    case "$q" in
        *xss*|*cross\ site*)
            suggest "XSStrike" "Cross-site scripting detection & fuzzing." "xsstrike -u \"<url>?q=1\"" ;;
    esac
    case "$q" in
        *crack*hash*|*hash*crack*|*offline\ password*|*recover\ hash*)
            suggest "John the Ripper / Hashcat" "Offline password/hash cracking." "john --wordlist=rockyou.txt hash.txt" ;;
    esac
    case "$q" in
        *brute*force\ login*|*brute*ssh*|*online\ password*|*login\ brute*|*guess\ password*)
            suggest "Hydra / Medusa" "Online login brute-forcing (authorized only)." "hydra -l admin -P list.txt ssh://<target>" ;;
    esac
    case "$q" in
        *wordlist*|*password\ list*)
            suggest "Crunch / CeWL" "Generate custom wordlists." "cewl <url> -w words.txt" ;;
    esac
    case "$q" in
        *wifi*|*wireless*|*wpa*|*wep*|*handshake*)
            suggest "Aircrack-ng / Wifite (limited on iOS)" "Wi-Fi auditing — needs radio access iOS lacks." "aircrack-ng capture.cap" ;;
    esac
    case "$q" in
        *exploit*|*metasploit*|*payload*|*get\ shell*|*reverse\ shell*)
            suggest "Metasploit / msfvenom" "Exploitation framework & payload generation." "msfconsole" ;;
    esac
    case "$q" in
        *sniff*|*capture\ traffic*|*packet*|*network\ traffic*|*mitm*|*intercept*)
            suggest "Wireshark / tcpdump / mitmproxy (capture limited on iOS)" "Traffic capture & interception." "mitmproxy" ;;
    esac
    case "$q" in
        *reverse\ engineer*|*disassemble*|*decompile*|*analyze\ binary*|*malware\ analysis*)
            suggest "Ghidra / radare2 / GDB" "Binary reverse engineering & analysis." "r2 ./binary" ;;
    esac
    case "$q" in
        *apk*|*android\ app*)
            suggest "apktool / jadx" "Decompile & inspect Android apps." "jadx <app.apk>" ;;
    esac
    case "$q" in
        *vuln*scan*|*vulnerability\ scan*|*find\ vuln*)
            suggest "Nuclei / OpenVAS / Lynis" "Vulnerability scanning & auditing." "nuclei -u https://<target>" ;;
    esac
    case "$q" in
        *privilege\ esc*|*privesc*|*post\ exploit*|*after\ shell*)
            suggest "LinPEAS / WinPEAS / pspy" "Post-exploitation & priv-esc enumeration." "./linpeas.sh" ;;
    esac
    case "$q" in
        *firewall*detect*|*waf*)
            suggest "wafw00f" "Detect & fingerprint web application firewalls." "wafw00f https://<target>" ;;
    esac

    if [ "$matched" -eq 0 ]; then
        warn "  I couldn't map that to a specific tool from the offline knowledge base."
        say  "  Try describing the goal, e.g. \"scan ports on my server\", \"crack this hash\","
        say  "  \"test a site for SQL injection\". Or browse the full list: ${C_BOLD}option 2${C_RESET}."
        say  "  Add a Claude API key (${C_BOLD}option 5${C_RESET}) for open-ended conversational answers."
        say  ""
    else
        say "  ${C_DIM}See TOOLS.md for the full top-100 reference. Always confirm authorization"
        say "  before running any active tool against a target.${C_RESET}"
        say ""
    fi
}

# ---------------------------------------------------------------------------
# Online AI via the Claude Messages API (optional).
# ---------------------------------------------------------------------------
SYSTEM_PROMPT="You are the Kali iOS AI Assistant, running in a text terminal on an \
iPhone (Kali Linux via the iSH emulator). Help the user with penetration testing and \
security tasks by mapping their goal to the right Kali tool, giving concise, correct \
commands, and explaining briefly. Environment limits: iSH is single-core x86 usermode \
with no kernel/hardware access, so raw Wi-Fi radio control, monitor mode, packet \
injection, and live packet capture are unavailable on stock iOS — say so when relevant. \
Ethics are mandatory: only ever assist with systems the user is authorized to test, and \
remind them to confirm authorization before any active/intrusive action. Keep answers \
short and terminal-friendly. Never help with clearly illegal or non-consensual targeting."

json_escape() {
    # Escape a string for embedding in JSON, using python3/jq when available.
    if have jq; then
        printf '%s' "$1" | jq -Rs .
    elif have python3; then
        S="$1" python3 -c 'import json,os;print(json.dumps(os.environ["S"]))'
    else
        # Minimal fallback: escape backslash, quote, control chars.
        printf '%s' "$1" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' \
            | awk 'BEGIN{printf "\""} {printf "%s\\n", $0} END{printf "\""}'
    fi
}

extract_text() {
    resp="$1"
    if have jq; then
        printf '%s' "$resp" | jq -r '.content[0].text // .error.message // "‹no response›"'
    elif have python3; then
        RESP="$resp" python3 -c '
import json,os
try:
    d=json.loads(os.environ["RESP"])
    if "content" in d and d["content"]:
        print(d["content"][0].get("text",""))
    elif "error" in d:
        print("API error: "+d["error"].get("message",""))
    else:
        print("‹no response›")
except Exception as e:
    print("Could not parse response: %s" % e)'
    else
        printf '%s' "$resp" | sed -n 's/.*"text":"\(.*\)".*/\1/p'
    fi
}

call_claude() {
    q="$1"
    if [ -z "$ANTHROPIC_API_KEY" ]; then
        return 2
    fi
    if ! have curl; then
        err "  curl is required for online AI mode. Install it, or use offline mode."
        return 1
    fi
    esc_sys=$(json_escape "$SYSTEM_PROMPT")
    esc_msg=$(json_escape "$q")
    payload=$(printf '{"model":"%s","max_tokens":1024,"system":%s,"messages":[{"role":"user","content":%s}]}' \
        "$MODEL" "$esc_sys" "$esc_msg")

    info "  Thinking…"
    resp=$(curl -sS -X POST "$API_URL" \
        -H "x-api-key: ${ANTHROPIC_API_KEY}" \
        -H "anthropic-version: ${ANTHROPIC_VERSION}" \
        -H "content-type: application/json" \
        -d "$payload" 2>/dev/null)

    if [ -z "$resp" ]; then
        err "  No response (network or proxy issue). Falling back to offline advisor."
        return 1
    fi
    say ""
    extract_text "$resp" | while IFS= read -r line; do
        say "  ${line}"
    done
    say ""
    return 0
}

ai_query() {
    q="$1"
    [ -z "$q" ] && return
    if [ -n "$ANTHROPIC_API_KEY" ]; then
        if call_claude "$q"; then
            return
        fi
    fi
    say ""
    say "  ${C_BOLD}Recommended tools:${C_RESET}"
    say ""
    offline_advisor "$q"
}

# ---------------------------------------------------------------------------
# Browse / search the tool catalog (from TOOLS.md when present).
# ---------------------------------------------------------------------------
tools_file() {
    for p in "./TOOLS.md" "$(dirname "$0")/TOOLS.md" "${HOME}/TOOLS.md"; do
        [ -f "$p" ] && { printf '%s' "$p"; return 0; }
    done
    return 1
}

browse_categories() {
    tf=$(tools_file) || { warn "  TOOLS.md not found next to this script."; return; }
    say ""
    info "  Categories in TOOLS.md:"
    say ""
    grep -n '^## ' "$tf" | sed 's/^\([0-9]*\):## /  /'
    say ""
    printf "  Type a keyword to jump to a section (or Enter to go back): "
    read term
    [ -z "$term" ] && return
    search_tools "$term"
}

search_tools() {
    tf=$(tools_file) || { warn "  TOOLS.md not found."; return; }
    term="$1"
    say ""
    info "  Matches for \"${term}\":"
    say ""
    grep -i "$term" "$tf" | grep '|' | sed 's/^/  /' | head -n 40
    say ""
}

# ---------------------------------------------------------------------------
# Run a tool with a mandatory authorization gate.
# ---------------------------------------------------------------------------
run_tool() {
    say ""
    printf "  Enter the full command to run (e.g. 'nmap -sV example.com'): "
    read cmd
    [ -z "$cmd" ] && return
    base=$(printf '%s' "$cmd" | awk '{print $1}')

    say ""
    warn "  ┌─ AUTHORIZATION REQUIRED ───────────────────────────────────┐"
    warn "  │ Active security tools may only be used against systems you  │"
    warn "  │ OWN or have EXPLICIT WRITTEN PERMISSION to test.            │"
    warn "  └────────────────────────────────────────────────────────────┘"
    printf "  Do you have authorization for this target? (type 'yes'): "
    read consent
    case "$consent" in
        yes|YES|Yes) : ;;
        *) err "  Aborted — no authorization confirmed."; return ;;
    esac

    if ! have "$base"; then
        warn "  '$base' is not installed in this environment."
        say  "  In Kali:  ${C_CYN}sudo apt-get update && sudo apt-get install $base${C_RESET}"
        return
    fi
    say ""
    info "  Running: $cmd"
    say  "  ${C_DIM}(Ctrl-C to stop)${C_RESET}"
    say ""
    sh -c "$cmd"
}

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
configure() {
    say ""
    info "  Configuration"
    say  "  ${C_DIM}Get an API key at https://console.anthropic.com/ (kept locally, chmod 600).${C_RESET}"
    say ""
    printf "  Claude API key [%s]: " "$( [ -n "$ANTHROPIC_API_KEY" ] && echo 'set — Enter to keep' || echo 'not set' )"
    read newkey
    [ -n "$newkey" ] && ANTHROPIC_API_KEY="$newkey"

    printf "  Model [%s]: " "$MODEL"
    read newmodel
    [ -n "$newmodel" ] && MODEL="$newmodel"

    save_config
    ok "  Saved to $CONFIG_FILE"
    say "  ${C_DIM}Model tips: claude-opus-4-8 (most capable), claude-sonnet-5 (balanced),"
    say "  claude-haiku-4-5 (fastest/cheapest).${C_RESET}"
    say ""
}

about() {
    say ""
    info "  Kali iOS · All-in-One AI Assistant  v${VERSION}"
    say  "  A conversational front-end to the top-100 Kali toolset (see TOOLS.md)."
    say  "  Offline advisor works with no network or key; add a Claude API key for"
    say  "  full conversational AI. Educational / authorized testing use ONLY."
    say ""
}

# ---------------------------------------------------------------------------
# Main menu loop
# ---------------------------------------------------------------------------
menu() {
    banner
    while true; do
        say "  ${C_BOLD}What do you want to do?${C_RESET}"
        say "    ${C_CYN}1${C_RESET}) Ask the assistant (describe your goal in plain language)"
        say "    ${C_CYN}2${C_RESET}) Browse tools by category"
        say "    ${C_CYN}3${C_RESET}) Search tools"
        say "    ${C_CYN}4${C_RESET}) Run a tool (with authorization check)"
        say "    ${C_CYN}5${C_RESET}) Configure API key / model"
        say "    ${C_CYN}6${C_RESET}) About"
        say "    ${C_CYN}0${C_RESET}) Exit"
        printf "  ${C_BOLD}> ${C_RESET}"
        read choice
        case "$choice" in
            1) printf "\n  ${C_BOLD}Describe your goal:${C_RESET} "; read goal; ai_query "$goal" ;;
            2) browse_categories ;;
            3) printf "\n  Search term: "; read t; search_tools "$t" ;;
            4) run_tool ;;
            5) configure ;;
            6) about ;;
            0|q|quit|exit) say "\n  Stay ethical. Bye 👋\n"; exit 0 ;;
            "") : ;;
            *) warn "  Unknown option: $choice" ;;
        esac
        say ""
    done
}

# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------
main() {
    load_config
    case "${1:-}" in
        ask)   shift; banner; ai_query "$*" ;;
        search) shift; search_tools "$*" ;;
        -h|--help|help)
            about
            say "  Usage:"
            say "    kali-ai.sh                 # interactive menu"
            say "    kali-ai.sh ask \"<goal>\"    # one-shot question"
            say "    kali-ai.sh search \"<term>\" # search the tool catalog"
            say "" ;;
        *) menu ;;
    esac
}

main "$@"
