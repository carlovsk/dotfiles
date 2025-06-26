#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  setup_dev_env_mac.sh
# -----------------------------------------------------------------------------
#  Automated bootstrap script for a fresh Apple‑Silicon MacBook (M1–M4)
#  Installs and configures:
#    • Xcode Command‑Line Tools (prerequisite)
#    • Homebrew
#    • Homebrew apps
#    • fnm (Fast Node Manager) + latest LTS Node.js
#    • pnpm via Corepack
#    • Python 3 (brew)
#    • Oh My Zsh (unattended)
# -----------------------------------------------------------------------------
#  Usage
#    curl -fsSL https://example.com/setup_dev_env_mac.sh | bash
#  or
#    chmod +x setup_dev_env_mac.sh && ./setup_dev_env_mac.sh
# -----------------------------------------------------------------------------

set -euo pipefail

# Colors for pretty output
GREEN="\033[0;32m"; YELLOW="\033[1;33m"; RED="\033[0;31m"; NC="\033[0m"

log()  { printf "${GREEN}[✔] %s${NC}\n" "$1"; }
warn() { printf "${YELLOW}[!] %s${NC}\n" "$1"; }
fail() { printf "${RED}[✖] %s${NC}\n" "$1"; exit 1; }

# -----------------------------------------------------------------------------
# 1. Xcode Command‑Line Tools ---------------------------------------------------
# -----------------------------------------------------------------------------
if ! xcode-select -p >/dev/null 2>&1; then
  warn "Installing Xcode Command‑Line Tools … (this may pop up a GUI prompt)"
  xcode-select --install || true
  echo "After the installation finishes, re‑run this script."
  exit 0
else
  log "Xcode Command‑Line Tools already installed"
fi

# -----------------------------------------------------------------------------
# 2. Homebrew ------------------------------------------------------------------
# -----------------------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  warn "Installing Homebrew …"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  log "Homebrew installed"
else
  log "Homebrew already installed"
fi

# Update & upgrade
brew update && brew upgrade

# -----------------------------------------------------------------------------
# 3. Core packages --------------------------------------------------------------
# -----------------------------------------------------------------------------
PACKAGE_LIST=(git wget curl python@3.12 fnm corepack)
for pkg in "${PACKAGE_LIST[@]}"; do
  if brew list "$pkg" >/dev/null 2>&1; then
    log "$pkg already installed"
  else
    brew install "$pkg"
  fi
done

# -----------------------------------------------------------------------------
# 4. Homebrew Apps -------------------------------------------------------------
# -----------------------------------------------------------------------------
if ! brew list --cask docker >/dev/null 2>&1; then
  warn "Installing Docker Desktop (cask) …"
  brew install --cask docker
  log "Docker Desktop installed – launch it once to finish setup"
else
  log "Docker Desktop already installed"
fi

if ! brew list --cask raycast >/dev/null 2>&1; then
  warn "Installing Raycast …"
  brew install --cask raycast
  log "Raycast installed – open it once to grant accessibility permissions"
else
  log "Raycast already installed"
fi

if ! brew list --cask alt-tab >/dev/null 2>&1; then
  warn "Installing AltTab …"
  brew install --cask alt-tab
  log "AltTab installed – open it once to grant accessibility permissions"
else
  log "AltTab already installed"
fi


# -----------------------------------------------------------------------------
# 5. FNM & Node.js --------------------------------------------------------------
# -----------------------------------------------------------------------------
if ! grep -q "fnm env" "$HOME/.zshrc" 2>/dev/null; then
  echo '# >>> fnm setup >>>' >> "$HOME/.zshrc"
  echo 'eval "$(fnm env --use-on-cd)"' >> "$HOME/.zshrc"
  echo '# <<< fnm setup <<<' >> "$HOME/.zshrc"
  log "Added fnm init to ~/.zshrc"
fi
# Ensure current shell knows fnm
export PATH="$HOME/Library/Application Support/fnm:$PATH"
eval "$(fnm env)"

# Install latest LTS Node
LATEST_LTS=$(fnm ls-remote --latest)
if fnm list | grep -q "$LATEST_LTS"; then
  log "Node $LATEST_LTS already installed via fnm"
else
  warn "Installing Node $LATEST_LTS with fnm …"
  fnm install "$LATEST_LTS"
fi
fnm default "$LATEST_LTS"

# -----------------------------------------------------------------------------
# 6. pnpm via Corepack ----------------------------------------------------------
# -----------------------------------------------------------------------------
corepack enable
auth_pnpm_version=$(corepack ls | grep pnpm | awk '{print $2}') || true
if [[ -z "$auth_pnpm_version" ]]; then
  warn "Preparing latest pnpm with Corepack …"
  corepack prepare pnpm@latest --activate
  log "pnpm ready (Corepack)"
else
  log "pnpm ${auth_pnpm_version} already active via Corepack"
fi

# -----------------------------------------------------------------------------
# 7. Python 3 symlink -----------------------------------------------------------
# -----------------------------------------------------------------------------
if ! command -v python3 >/dev/null 2>&1; then
  brew link --overwrite python@3.12
fi
log "Python $(python3 --version) available"

# -----------------------------------------------------------------------------
# 8. Oh My Zsh -----------------------------------------------------------------
# -----------------------------------------------------------------------------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  warn "Installing Oh My Zsh …"
  RUNZSH=no KEEP_ZSHRC=yes CHSH=no /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  log "Oh My Zsh installed"
else
  log "Oh My Zsh already installed"
fi

# -----------------------------------------------------------------------------
# 9. Finishing up ---------------------------------------------------------------
# -----------------------------------------------------------------------------
log "Developer environment ready!  🚀"
log "➡  Open a new terminal session or run 'source ~/.zshrc' to load the updates."

