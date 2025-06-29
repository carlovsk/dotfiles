#!/usr/bin/env bash
# ------------------------------------------------------------------------------
#  setup_dev_env_mac.sh
# ------------------------------------------------------------------------------
#  Automated bootstrap script for a fresh Apple‑Silicon MacBook (M1–M4)
#  Installs and configures:
#    • Xcode Command‑Line Tools (prerequisite)
#    • Homebrew
#    • Homebrew apps
#    • Oh My Zsh (unattended)
#    • Dotfiles setup (from this very repository)
#    • fnm (Fast Node Manager) + latest LTS Node.js
#    • pnpm via Corepack
#    • Python 3 (brew)
# ------------------------------------------------------------------------------
#  Usage
#    curl -fsSL https://raw.githubusercontent.com/carlovsk/dotfiles/refs/heads/master/tools/setup_dev_env_mac.sh | bash
#  or
#    chmod +x setup_dev_env_mac.sh && ./setup_dev_env_mac.sh
# ------------------------------------------------------------------------------

# Colors for pretty output
GREEN="\033[0;32m"; YELLOW="\033[1;33m"; RED="\033[0;31m"; NC="\033[0m"

log()  { printf "${GREEN}[✔] %s${NC}\n" "$1"; }
warn() { printf "${YELLOW}[!] %s${NC}\n" "$1"; }
fail() { printf "${RED}[✖] %s${NC}\n" "$1"; exit 1; }
info() { printf "${YELLOW}[i] %s${NC}\n" "$1"; }

# ------------------------------------------------------------------------------
# 1. Xcode Command‑Line Tools --------------------------------------------------
# ------------------------------------------------------------------------------
if ! xcode-select -p >/dev/null 2>&1; then
  warn "Installing Xcode Command‑Line Tools … (this may pop up a GUI prompt)"
  xcode-select --install || true
  echo "After the installation finishes, re‑run this script."
  exit 0
else
  log "Xcode Command‑Line Tools already installed"
fi

# ------------------------------------------------------------------------------
# 2. Homebrew ------------------------------------------------------------------
# ------------------------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  warn "Installing Homebrew …"
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo "eval "$(/opt/homebrew/bin/brew shellenv)"" >> "$HOME/.zprofile"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  log "Homebrew installed"
else
  log "Homebrew already installed"
fi

# Update & upgrade
ask_brew_update() {
  while true; do
    printf "${YELLOW}[?] Do you want to update and upgrade Homebrew packages? (y/n): ${NC}"
    read -r response
    case "$response" in
      [Yy])
        log "Updating and upgrading Homebrew packages..."
        brew update && brew upgrade
        break
        ;;
      [Nn])
        info "Skipping Homebrew update and upgrade"
        break
        ;;
      *)
        warn "Please enter 'y' for yes or 'n' for no"
        ;;
    esac
  done
}

ask_brew_update

# ------------------------------------------------------------------------------
# 3. HomeBrew Core packages ----------------------------------------------------
# ------------------------------------------------------------------------------
BREW_PACKAGE_LIST=(
  git
  wget
  gpg
  curl
  python@3.12
  fnm
  corepack
  yt-dlp
  ffmpeg
  git-standup
  aws-sso-cli
  awscli
  neofetch
  # openai-whisper # This is optional, a CLI tool to transcribe audio files. It can be heavy and will install a bunch of stuff along with it.
  )
for pkg in "${BREW_PACKAGE_LIST[@]}"; do
  if brew list "$pkg" >/dev/null 2>&1; then
    log "$pkg already installed"
  else
    brew install "$pkg"
  fi
done

# ------------------------------------------------------------------------------
# 4. Homebrew Cask Apps --------------------------------------------------------
# ------------------------------------------------------------------------------
BREW_CASK_PACKAGE_LIST=(
  docker
  raycast
  alt-tab
  keepingyouawake
  bruno
  postman
  # insomnia
  # visual-studio-code
  # warp
  # chatgpt
  # setapp
  # slack
  # gather # This is optional. Gather is a virtual office platform for meetings and collaboration.
  # microsoft-teams
  arc
  # thebrowsercompany-dia
  # tailscale
  # nordvpn
)

for pkg in "${BREW_CASK_PACKAGE_LIST[@]}"; do
  if brew list "$pkg" >/dev/null 2>&1; then
    log "$pkg already installed"
  else
    warn "Installing $pkg (cask)…"
    brew install --cask "$pkg"
    log "$pkg installed - launch it once to finish setup"
  fi
done

# ------------------------------------------------------------------------------
# 5. Dotfiles -------------------------------------------------------------------
# ------------------------------------------------------------------------------
if [[ ! -d "$HOME/www/dotfiles" ]]; then
  warn "Cloning dotfiles repository …"

  if [[ ! -d "$HOME/www" ]]; then
    mkdir -p "$HOME/www"
  fi

  git clone https://github.com/carlovsk/dotfiles.git "$HOME/www/dotfiles" || {
    fail "Failed to clone dotfiles repository. Please check your Git setup."
  }

  log "Dotfiles repository cloned to $HOME/www/dotfiles"

  else
  log "Dotfiles repository already cloned at $HOME/www/dotfiles"
fi

# Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  warn "Installing Oh My Zsh …"
  RUNZSH=no KEEP_ZSHRC=yes CHSH=no /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  log "Oh My Zsh installed"
else
  log "Oh My Zsh already installed"
fi

# Dotfiles
DOTFILES_LIST=(.zshrc .gitconfig .profile .npmrc)

for dotfile in "${DOTFILES_LIST[@]}"; do
  if [[ ! "$HOME/$dotfile" ]]; then
    echo "# >>> dotfiles setup >>>" >> "$HOME/$dotfile"
    echo "source $HOME/www/dotfiles/$dotfile" >> "$HOME/$dotfile"
    echo "# <<< dotfiles setup <<<" >> "$HOME/$dotfile"
    log "Added dotfiles init to ~/$dotfile"
  else
    log "Dotfiles already sourced in ~/$dotfile"
  fi
done

# ------------------------------------------------------------------------------
# 6. FNM & Node.js -------------------------------------------------------------
# ------------------------------------------------------------------------------
if ! grep -q "fnm env" "$HOME/.zshrc" 2>/dev/null; then
  echo "# >>> fnm setup >>>" >> "$HOME/.zshrc"
  echo "eval "$(fnm env --use-on-cd)"" >> "$HOME/.zshrc"
  echo "# <<< fnm setup <<<" >> "$HOME/.zshrc"
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

# ------------------------------------------------------------------------------
# 7. pnpm via Corepack ---------------------------------------------------------
# ------------------------------------------------------------------------------
corepack enable
# Check if pnpm is available and working
if command -v pnpm >/dev/null 2>&1 && pnpm --version >/dev/null 2>&1; then
  pnpm_version=$(pnpm --version 2>/dev/null)
  log "pnpm ${pnpm_version} already available via Corepack"
else
  warn "Preparing latest pnpm with Corepack …"
  corepack prepare pnpm@latest --activate
  log "pnpm ready (Corepack)"
fi

# ------------------------------------------------------------------------------
# 8. Python 3 symlink ----------------------------------------------------------
# ------------------------------------------------------------------------------
if ! command -v python3 >/dev/null 2>&1; then
  brew link --overwrite python@3.12
fi
log "Python $(python3 --version) available"

# ------------------------------------------------------------------------------
# 9. Git Platforms SSH Authentication -----------------------------------------
# ------------------------------------------------------------------------------
if [[ ! -f ~/.ssh/id_ed25519 ]]; then
  warn "SSH key not found, generating a new one …"
  
  info "Please enter your GitHub username:"
  read -r github_username
  
  info "Please enter your GitHub email:"
  read -r github_email

  info "Please enter your name:"
  read -r github_name

  if [[ -n "$github_username" && -n "$github_email" && -n "$github_name" ]]; then
    git config --global user.name "$github_name"
    git config --global user.email "$github_email"
    git config --global github.user "$github_username"

    # Generate SSH key
    ssh-keygen -t ed25519 -C "$github_email" -f ~/.ssh/id_ed25519 -N ""
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519
  fi
else
  log "SSH key already exists at ~/.ssh/id_ed25519"
fi

setup_ssh_auth() {
  local platform="$1"
  local ssh_host="$2"
  local settings_url="$3"
  local success_msg="$4"
  
  # Test authentication
  if ssh -T "$ssh_host" 2>&1 | grep -qi "$success_msg"; then
    log "$platform SSH authentication working correctly"
    return 0
  else
    warn "SSH key exists but $platform authentication failed"
    info "Adding SSH key to agent and copying public key to clipboard..."
    info "Your public key has been copied to your clipboard:"
    
    echo ""
    cat ~/.ssh/id_ed25519.pub
    echo ""
    
    info "Please add this key to your $platform account: $settings_url"
    warn "Press Enter after adding the key to $platform to test the connection..."
    read -r

    if ssh -T "$ssh_host" 2>&1 | grep -qi "$success_msg"; then
      log "$platform SSH authentication working correctly"
      return 0
    else
      warn "SSH connection test failed - please verify the key was added correctly to $platform"
      return 1
    fi
  fi
}

# Setup authentication for GitHub and GitLab
if [[ -f ~/.ssh/id_ed25519 ]]; then
  setup_ssh_auth "GitHub" "git@github.com" "https://github.com/settings/ssh/new" "successfully authenticated"
  setup_ssh_auth "GitLab" "git@gitlab.com" "https://gitlab.com/-/user_settings/ssh_keys" "Welcome to GitLab, "
fi

# ------------------------------------------------------------------------------
# 10. Finishing up ------------------------------------------------------------
# ------------------------------------------------------------------------------

log "Developer environment ready!  🚀"
log "➡  Open a new terminal session or run "source ~/.zshrc" to load the updates."

