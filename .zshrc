export ZSH="/Users/carlos/.oh-my-zsh"
ZSH_THEME="dracula-pro"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# aliases
alias cls="clear"
alias www="cd ~/www"
alias zs="cat ~/.zshrc"
alias zss="source ~/.zshrc"
alias zsc="code ~/.zshrc"
alias zsn="nano ~/.zshrc"
alias ytdl="youtube-dl"
alias nrsl="npm run start:local"
alias nsil="npx serverless invoke local --function"
alias nrtu="npm run test:unit -- --watch"
alias awsc="code ~/.aws/config"
alias awsl="aws sso login"
alias awse="aws-sso-creds export"

alias gl="git log"
alias vai="git push"
alias vem="git pull"
alias gfo="git fetch origin"
alias gmc="git merge --continue"
alias gmom="git merge origin/main"

function cd {
    builtin cd "$@"
    RET=$?
    ls -la
    return $RET
}

# spaceship config
SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  node          # Node.js section
  hg            # Mercurial section (hg_branch  + hg_status)
  exec_time     # Execution time
  line_sep      # Line break
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_FORMAT=%*

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

# zinit light-mode for \
#     zinit-zsh/z-a-rust \
#     zinit-zsh/z-a-as-monitor \
#     zinit-zsh/z-a-patch-dl \
#     zinit-zsh/z-a-bin-gem-node

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

# exports
export EDITOR=nano
export AWS_REGION=us-east-1

source ~/.profile

export PATH="/usr/local/share/npm/bin:/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
source /Users/carlos/.config/op/plugins.sh

# pnpm
export PNPM_HOME="/Users/carlos/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# bun completions
[ -s "/Users/carlos/.bun/_bun" ] && source "/Users/carlos/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
