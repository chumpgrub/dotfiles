#!/bin/bash

set -e  # Exit on error

echo "🚀 Installing dotfiles..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script lives
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "❌ GNU Stow is not installed."
    echo "Install it with: brew install stow"
    exit 1
fi

# Install AstroNvim template if not already present
if [ ! -d "$HOME/.config/nvim/init.lua" ]; then
    echo -e "${BLUE}📦 Installing AstroNvim template...${NC}"
    git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
    rm -rf ~/.config/nvim/.git
    echo -e "${GREEN}✓ AstroNvim template installed${NC}"
else
    echo -e "${GREEN}✓ AstroNvim template already exists${NC}"
fi

# Install TPM if not already present
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    echo -e "${BLUE}📦 Installing Tmux Plugin Manager (TPM)...${NC}"
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    echo -e "${GREEN}✓ TPM installed${NC}"
else
    echo -e "${GREEN}✓ TPM already exists${NC}"
fi

# Stow dotfiles
echo -e "${BLUE}🔗 Stowing dotfiles...${NC}"
cd "$DOTFILES_DIR"

stow -v nvim
echo -e "${GREEN}✓ Neovim config stowed${NC}"

stow -v tmux
echo -e "${GREEN}✓ Tmux config stowed${NC}"

# Optional: Add more stow packages here as you add them
# stow -v git
# stow -v zsh

echo ""
echo -e "${GREEN}✨ Dotfiles installation complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Open nvim - plugins will install automatically"
echo "  2. Open tmux and press 'prefix + I' to install tmux plugins"
echo "     (prefix is usually Ctrl-b)"
