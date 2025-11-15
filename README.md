```
# 1. Clone your dotfiles
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles

# 2. Install AstroNvim template
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
rm -rf ~/.config/nvim/.git  # Remove git tracking from template

# 3. Stow your configs (this overlays your lua/ configs)
cd ~/dotfiles
stow nvim tmux

# 4. Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm

# 5. Open nvim - it will install plugins automatically
# 6. Open tmux and press prefix + I to install tmux plugins
```
