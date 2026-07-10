#!/usr/bin/env bash
set -euo pipefail

# ──────────────────────────────────────────────
# Dotfiles Installer — Arch Linux + Hyprland
# ──────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC}  $*"; }
ok() { echo -e "${GREEN}[OK]${NC}    $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }

# ── System check ──────────────────────────────

check_system() {
  if [[ ! -f /etc/os-release ]] || ! grep -qi 'arch' /etc/os-release; then
    error "This installer is designed for Arch Linux only."
    exit 1
  fi
  if [[ $EUID -eq 0 ]]; then
    error "Do not run this script as root."
    exit 1
  fi
  ok "Arch Linux detected"
}

# ── Yay (AUR helper) ──────────────────────────

install_yay() {
  if command -v yay &>/dev/null; then
    info "yay already installed, skipping"
    return
  fi
  info "Installing yay (AUR helper)..."
  sudo pacman -S --needed --noconfirm base-devel git
  local tmpdir
  tmpdir="$(mktemp -d)"
  git clone --depth=1 https://aur.archlinux.org/yay.git "$tmpdir/yay"
  (cd "$tmpdir/yay" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
  ok "yay installed"
}

# ── Pacman packages ───────────────────────────

install_packages() {
  info "Installing official packages..."
  local pkgs=(
    # Hyprland ecosystem
    hyprland hypridle hyprlock hyprpaper

    # Desktop
    waybar kitty wofi neovim
    dolphin firefox

    # Shell
    zsh zoxide

    # Audio
    pipewire pipewire-pulse wireplumber pavucontrol

    # Utilities
    brightnessctl bluez bluez-utils
    libnotify wl-clipboard
    qt6ct

    # Fonts
    ttf-jetbrains-mono-nerd

    # Build
    git
  )

  sudo pacman -S --needed --noconfirm "${pkgs[@]}"
  ok "Official packages installed"
}

# ── AUR packages ──────────────────────────────

install_aur_packages() {
  info "Installing AUR packages..."
  local aur_pkgs=(
    hyprshot
    sway-notification-center
    bibata-cursor-theme
  )

  for pkg in "${aur_pkgs[@]}"; do
    if yay -Q "$pkg" &>/dev/null; then
      info "$pkg already installed"
    else
      yay -S --needed --noconfirm "$pkg"
      ok "$pkg installed"
    fi
  done
}

# ── Zsh ───────────────────────────────────────

install_zsh() {
  if command -v zsh &>/dev/null; then
    info "zsh already installed"
    return
  fi
  sudo pacman -S --needed --noconfirm zsh
  ok "zsh installed"
}

install_ohmyzsh() {
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    info "Oh My Zsh already installed"
    return
  fi
  info "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  ok "Oh My Zsh installed"
}

install_powerlevel10k() {
  local target="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [[ -d "$target" ]]; then
    info "Powerlevel10k already installed"
    return
  fi
  info "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$target"
  ok "Powerlevel10k installed"
}

# ── Backup ────────────────────────────────────

backup_existing_configs() {
  local items=(
    "$HOME/.zshrc"
    "$HOME/.p10k.zsh"
    "$HOME/.config/hypr"
    "$HOME/.config/kitty"
    "$HOME/.config/waybar"
    "$HOME/.config/wofi"
    "$HOME/.config/nvim"
  )

  local has_backup=false
  for item in "${items[@]}"; do
    if [[ -e "$item" ]] && [[ ! -L "$item" ]]; then
      mkdir -p "$BACKUP_DIR"
      mv "$item" "$BACKUP_DIR/"
      has_backup=true
      info "Backed up $item → $BACKUP_DIR"
    fi
  done

  if $has_backup; then
    ok "Existing configs backed up to $BACKUP_DIR"
  else
    info "No existing configs to back up"
  fi
}

# ── Symlinks ──────────────────────────────────

create_symlinks() {
  info "Creating symlinks..."

  # Config directories → ~/.config/
  local config_links=(
    "hypr"
    "kitty"
    "waybar"
    "wofi"
    "nvim"
  )

  mkdir -p "$HOME/.config"

  for dir in "${config_links[@]}"; do
    local target="$HOME/.config/$dir"
    local source="$SCRIPT_DIR/$dir"

    if [[ ! -d "$source" ]]; then
      warn "Source $source not found, skipping"
      continue
    fi

    if [[ -L "$target" ]]; then
      rm "$target"
      info "Removed old symlink: $target"
    fi

    ln -sf "$source" "$target"
    ok "Symlinked $dir → $target"
  done

  # Dotfiles in $HOME
  local home_links=(
    ".zshrc:zsh/.zshrc"
    ".p10k.zsh:zsh/p10k.zsh"
  )

  for entry in "${home_links[@]}"; do
    local name="${entry%%:*}"
    local relpath="${entry##*:}"
    local target="$HOME/$name"
    local source="$SCRIPT_DIR/$relpath"

    if [[ ! -f "$source" ]]; then
      warn "Source $source not found, skipping"
      continue
    fi

    if [[ -L "$target" ]]; then
      rm "$target"
      info "Removed old symlink: $target"
    fi

    ln -sf "$source" "$target"
    ok "Symlinked $name → $target"
  done
}

# ── Shell ─────────────────────────────────────

set_default_shell() {
  local zsh_path
  zsh_path="$(command -v zsh)"
  if [[ "$SHELL" != "$zsh_path" ]]; then
    info "Changing default shell to zsh..."
    chsh -s "$zsh_path"
    ok "Default shell set to zsh (log out and back in to apply)"
  else
    info "zsh is already the default shell"
  fi
}

# ── Main ──────────────────────────────────────

main() {
  echo ""
  echo -e "${BLUE}══════════════════════════════════════${NC}"
  echo -e "${BLUE}  Dotfiles Installer — Arch + Hyprland${NC}"
  echo -e "${BLUE}══════════════════════════════════════${NC}"
  echo ""

  check_system

  echo ""
  info "Step 1/7: Installing yay (AUR helper)..."
  install_yay

  echo ""
  info "Step 2/7: Installing official packages..."
  install_packages

  echo ""
  info "Step 3/7: Installing AUR packages..."
  install_aur_packages

  echo ""
  info "Step 4/7: Setting up Zsh..."
  install_zsh
  install_ohmyzsh
  install_powerlevel10k

  echo ""
  info "Step 5/7: Backing up existing configurations..."
  backup_existing_configs

  echo ""
  info "Step 6/7: Creating symlinks..."
  create_symlinks

  echo ""
  info "Step 7/7: Setting default shell..."
  set_default_shell

  echo ""
  echo -e "${GREEN}══════════════════════════════════════${NC}"
  echo -e "${GREEN}  Installation complete!${NC}"
  echo -e "${GREEN}══════════════════════════════════════${NC}"
  echo ""
  echo "  What to do next:"
  echo "    1. Log out and back in (or reboot)"
  echo "    2. Select Hyprland from your display manager"
  echo "    3. Run 'p10k configure' to customize the prompt"
  echo ""
  echo "  Backup saved to: $BACKUP_DIR"
  echo ""
}

main "$@"
