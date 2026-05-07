# setup_dev_env_mac.sh

Automated bootstrap script for a fresh Apple Silicon MacBook (M1–M4).

## Usage

```bash
# Remote (one-liner)
curl -fsSL https://raw.githubusercontent.com/carlovsk/dotfiles/refs/heads/master/tools/setup_dev_env_mac.sh | bash

# Local
chmod +x setup_dev_env_mac.sh && ./setup_dev_env_mac.sh
```

## What gets installed

### 1. Xcode Command-Line Tools

Installs automatically if missing. If triggered, the script exits and must be re-run after the installation finishes.

### 2. Homebrew

Installs Homebrew for Apple Silicon (`/opt/homebrew`). Optionally updates and upgrades existing packages (interactive prompt).

### 3. CLI Packages (Homebrew formulae)

| Package | Description |
|---|---|
| `git` | Version control |
| `gh` | GitHub CLI |
| `git-standup` | Recall what you did on the last working day |
| `wget` | File downloader |
| `curl` | Data transfer tool |
| `telnet` | Network debugging |
| `gpg` | GNU Privacy Guard |
| `python@3.12` | Python 3.12 |
| `uv` | Fast Python package manager |
| `go` | Go programming language |
| `fnm` | Fast Node Manager |
| `corepack` | Node.js package manager manager |
| `yt-dlp` | Video downloader |
| `ffmpeg` | Media processing |
| `micro` | Terminal text editor |
| `tmux` | Terminal multiplexer |
| `act` | Run GitHub Actions locally |
| `k6` | Load testing tool |
| `hey` | HTTP load generator |
| `redis` | In-memory data store |
| `minikube` | Local Kubernetes |
| `aws-sso-cli` | AWS SSO CLI helper |
| `awscli` | AWS CLI |
| `aws-sso-creds` | AWS SSO credentials helper |
| `aws-es-proxy` | AWS Elasticsearch proxy |
| `neofetch` | System info display |
| `gemini-cli` | Gemini AI CLI |
| `opencode` | SST OpenCode (`sst/tap/opencode`) |
| `terraform` | Infrastructure as code (`hashicorp/tap/terraform`) |

### 4. GUI Apps (Homebrew casks)

#### Dev tools

| App | Description |
|---|---|
| `arc` | Arc browser |
| `bruno` | API client |
| `chatgpt` | ChatGPT desktop app |
| `claude` | Claude desktop app |
| `docker-desktop` | Docker Desktop |
| `ghostty` | Ghostty terminal |
| `insomnia` | API client |
| `keepingyouawake` | Prevent sleep |
| `nordvpn` | VPN client |
| `notion` | Notes & docs |
| `obsidian` | Knowledge base |
| `postman` | API platform |
| `raycast` | Launcher & productivity |
| `setapp` | App subscription service |
| `slack` | Team messaging |
| `tailscale` | Mesh VPN |
| `visual-studio-code` | Code editor |
| `warp` | Warp terminal |

#### Personal / optional (also installed by default)

| App | Description |
|---|---|
| `claude-island` | Claude Island app |
| `discord` | Discord |
| `hyprnote` | Note-taking |
| `spotify` | Music streaming |
| `whatsapp` | Messaging |

### 5. Dotfiles

- Clones this repository to `~/www/dotfiles` if not already present.
- Installs **Oh My Zsh** (unattended, keeps existing `.zshrc`).
- Sources dotfiles (`.zshrc`, `.gitconfig`, `.profile`, `.npmrc`) from the repo into `~/<dotfile>`.

### 6. Node.js (via fnm)

- Adds `fnm env --use-on-cd` to `~/.zshrc`.
- Installs the latest LTS version of Node.js.
- Sets it as the default.

### 7. pnpm (via Corepack)

- Enables Corepack and activates the latest version of pnpm.

### 8. Python 3

- Symlinks/links `python@3.12` from Homebrew if `python3` is not available.

### 9. SSH Key & Git Platform Auth

- Generates an `ed25519` SSH key if none exists at `~/.ssh/id_ed25519`.
- Prompts for GitHub username, email, and name to configure `git config --global`.
- Tests SSH authentication against **GitHub** and **GitLab**, guiding the user to add the public key if needed.

### 10. Claude Code

- Installs [Claude Code](https://claude.ai) CLI if not already present.

---

## What is NOT installed

| Tool | Reason |
|---|---|
| `openai-whisper` | Commented out. Heavy dependency (installs ML frameworks). Uncomment in the script to opt in. |
| Any Ruby / rbenv setup | Not included |
| Any Java / JDK | Not included |
| Any database (Postgres, MySQL, MongoDB) | Not included (only Redis is installed) |
| Any container orchestration beyond minikube | Not included (no kind, k3s, etc.) |
| Rust / cargo | Not included |
| Fonts | Not included (no Nerd Fonts, etc.) |
| macOS system preferences / defaults | Not configured by this script |
| Zsh plugins beyond Oh My Zsh defaults | Not installed by this script (may be configured in `.zshrc`) |
