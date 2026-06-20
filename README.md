# dotfiles

My personal Linux configuration files.

## Contents

| App | Description |
|---|---|
| **Hyprland** | Window manager config (hyprland, hypridle, hyprlock, hyprpaper) + scripts |
| **Kitty** | Terminal emulator config |
| **Waybar** | Status bar config and styling |
| **Wofi** | Application launcher config and styling |
| **Neovim** | LazyVim-based editor config |

## Usage

Clone and symlink:

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
ln -sf ~/dotfiles/hypr   ~/.config/hypr
ln -sf ~/dotfiles/kitty  ~/.config/kitty
ln -sf ~/dotfiles/waybar ~/.config/waybar
ln -sf ~/dotfiles/wofi   ~/.config/wofi
ln -sf ~/dotfiles/nvim   ~/.config/nvim
```
