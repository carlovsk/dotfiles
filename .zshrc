export ZSH="/Users/carlos/.oh-my-zsh"
ZSH_THEME="dracula-pro"

plugins=(git history-sync)

source $ZSH/oh-my-zsh.sh

# aliases
alias h="echo $HOST"
alias cls="clear"
alias www="cd ~/www"
alias zs="cat ~/.zshrc"
alias zss="source ~/.zshrc"
alias zsc="code ~/.zshrc"
alias zsn="nano ~/.zshrc"
alias zsne="nano ~/.zshenv"

# docker
alias dcu="docker compose up"
alias dcd="docker compose down"
alias dcr="docker compose restart"

# aws
alias awsc="code ~/.aws/config"
alias awsl="aws sso login --sso-session rediredi --profile rediredi"

function awse() {
  local profile=${1:-rediredi}
  aws --profile "$profile" configure export-credentials --format env > ~/.aws/sso-env
  source ~/.aws/sso-env

  echo "Loaded credentials for $profile into env. Session token will expire after $AWS_CREDENTIAL_EXPIRATION."
}

function aws-load-sso() {
  local profile=${1:-rediredi}
  aws sso login --profile "$profile"
  aws --profile "$profile" configure export-credentials --format env > ~/.aws/sso-env
  source ~/.aws/sso-env
  echo "Loaded credentials for $profile into env."
}

# node
alias nrs="npm run start"
alias nrsl="npm run start:local"
alias prsl="pnpm run start:local"
alias nsil="npx serverless invoke local --function"
alias nrt="npx jest --bail --detectOpenHandles --forceExit --noStackTrace --runInBand"
alias nrtu="npm run test:unit -- --watch"
alias nrtw="npx jest --bail --forceExit --noStackTrace --watch"
alias nrtc="npx tsc --noEmit"
alias nvm="fnm"
alias npmi="npm i"
alias ni="npm i"
alias nid="npm i -D"
alias n="nvm use && npm i"
alias p="pnpm i"
alias pi="pnpm i"

# git
alias gl="git log"
alias glol="git log --oneline"
alias vai="git push"
alias vem="git pull"
alias gfo="git fetch origin"
alias gmc="git merge --continue"
alias gmom="git merge origin/main"
alias gch="git switch"
alias gchb="git switch -c"
alias gbl='git for-each-ref --sort=-committerdate --format="%(refname:short)" refs/heads/ | head -n'

# tmux
alias tn='tmux new -s'             # tn dev => new session named 'dev'
alias ta='tmux attach -t'          # ta dev => attach to 'dev'
alias tl='tmux ls'                 # tl => list sessions
alias tk='tmux kill-session -t'    # tk dev => kill session
alias td='tmux detach'             # td => detach
alias tx='tmux'                    # tx => raw tmux

function tgo() {
  local name="$1"
  if [ -z "$name" ]; then
    echo "Usage: tgo <session-name>"
    return 1
  fi
  # Strict check for session name
  if tmux list-sessions -F "#{session_name}" 2>/dev/null | grep -Fxq "$name"; then
    tmux attach -t "$name"
  else
    tmux new -s "$name"
  fi
}

# zinit
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

# exports
source ~/.zshenv # this is where credentials and envs are loaded

source ~/.profile

export PATH="/usr/local/share/npm/bin:/usr/local/bin:/usr/local/sbin:~/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/carlos/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# bun completions
[ -s "/Users/carlos/.bun/_bun" ] && source "/Users/carlos/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# fnm
FNM_PATH="/Users/carlos/Library/Application Support/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="/Users/carlos/Library/Application Support/fnm:$PATH"
  eval "`fnm env`"
fi

eval "$(fnm env --use-on-cd --shell zsh)"

# Created by `pipx` on 2025-05-11 16:41:57
export PATH="$PATH:/Users/carlos/.local/bin"

# opencode
export PATH=/Users/carlos/.opencode/bin:$PATH
