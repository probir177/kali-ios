# Kali iOS — All-in-One AI Assistant

`kali-ai.sh` is a single, self-contained assistant you talk to from your iPhone
terminal. Describe what you want in plain language and it maps your goal to the
right Kali tool, gives you the exact command, and — with your confirmation — can
run it. It ties the [Top 100 tools](TOOLS.md) together behind one conversational
front-end.

> **⚠️ Educational & authorized-testing use ONLY.** Only assess systems you own
> or have explicit written permission to test. The assistant enforces an
> authorization check before running any active tool, but the responsibility is
> yours. See the project [Disclaimer](README.md#disclaimer).

---

## Why "all-in-one"

- **One file, zero required dependencies.** Pure POSIX shell — runs in the Kali
  iOS / iSH environment as-is.
- **Works fully offline.** A built-in rule-based advisor recommends tools and
  commands with no network and no API key.
- **Upgrades to real AI.** Add a Claude API key and it becomes a full
  conversational assistant powered by the Claude Messages API.
- **Safety built in.** Active tools are gated behind an explicit authorization
  confirmation, and the assistant is told to refuse illegal or non-consensual
  targeting.
- **iOS-aware.** It knows iSH can't do raw Wi-Fi/packet-capture and says so
  instead of pretending.

## Install

```sh
# From inside your Kali iOS environment, in the project directory:
chmod +x kali-ai.sh

# Optional: put it on your PATH so you can call it from anywhere
cp kali-ai.sh /usr/local/bin/kali-ai
```

## Usage

```sh
./kali-ai.sh                      # interactive menu
./kali-ai.sh ask "scan my server for open ports and check for SQLi"
./kali-ai.sh search "hydra"       # search the tool catalog
./kali-ai.sh --help
```

### Interactive menu

```
1) Ask the assistant   – describe your goal in plain language
2) Browse tools        – by category, pulled from TOOLS.md
3) Search tools        – keyword search across the catalog
4) Run a tool          – with a mandatory authorization check
5) Configure           – set your Claude API key / model
6) About
0) Exit
```

### Example (offline mode)

```
$ ./kali-ai.sh ask "test a site for sql injection"

  Recommended tools:

  ▸ sqlmap
    Automated SQL-injection detection & exploitation.
    sqlmap -u "<url>?id=1" --batch
```

## Enabling full AI (optional)

1. Get a key from <https://console.anthropic.com/>.
2. Run `./kali-ai.sh`, choose **5) Configure**, and paste the key.
   It's stored in `~/.kali-ai/config` with `chmod 600` (never committed).
3. The banner will switch to **online AI** mode.

You can also set it via environment variables instead of the config file:

```sh
export ANTHROPIC_API_KEY="sk-ant-..."
export KALI_AI_MODEL="claude-sonnet-5"
./kali-ai.sh
```

### Model choices

| Model | Best for |
|-------|----------|
| `claude-opus-4-8`  | Maximum capability / hardest problems |
| `claude-sonnet-5`  | Balanced default (recommended) |
| `claude-haiku-4-5` | Fastest & cheapest, good for quick lookups |

If neither `jq` nor `python3` is present, online mode falls back to a minimal
JSON parser; installing `jq` (`apt-get install jq`) is recommended for the most
reliable request/response handling. If the API is unreachable, the assistant
automatically falls back to the offline advisor.

## How it decides what to recommend

- **Offline:** your phrase is matched against a keyword knowledge base derived
  from `TOOLS.md`, returning the tool, a one-line description, and a starter
  command.
- **Online:** the same intent is sent to Claude with a system prompt that grounds
  it in the Kali iOS toolset, the iSH hardware limitations, and the mandatory
  authorization/ethics rules — so answers stay accurate and safe for this
  environment.

## Files

- `kali-ai.sh` — the assistant.
- `~/.kali-ai/config` — your local API key & model (created on first configure;
  git-ignored, `chmod 600`).

---

*Part of the [Kali iOS](README.md) project.*
