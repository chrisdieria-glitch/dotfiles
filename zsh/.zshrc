export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zoxide
  sudo
  archlinux
  systemd
  copyfile
  copypath
)

source "$ZSH/oh-my-zsh.sh"

[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

eval "$(zoxide init zsh)"
