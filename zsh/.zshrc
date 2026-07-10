export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  sudo
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf
  archlinux
  systemd
  copyfile
  copypath
)

source "$ZSH/oh-my-zsh.sh"

[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

eval "$(zoxide init zsh)"

source <(fzf --zsh)

alias ls='eza --icons'
alias ll='eza -l --icons'
alias cat='bat'
