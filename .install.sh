mv ~/.config/hypr ~/.config/hypr.bak
rm -r ~/.config/kitty
rm -r ~/.config/waybar
rm -r ~/.config/wofi
rm -r ~/.config/nvim

ln -s ~Code/Projects/dotfiles/waybar ~/.config/
ln -s ~Code/Projects/dotfiles/hypr ~/.config/
ln -s ~Code/Projects/dotfiles/wofi ~/.config/
ln -s ~Code/Projects/dotfiles/nvim ~/.config/
ln -s ~Code/Projects/dotfiles/kitty ~/.config/

