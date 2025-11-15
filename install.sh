#!/bin/sh

set -e  # Exit on error

echo "🚀 Installing dotfiles..."

# Get the directory where this script lives
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check if stow is installed
if ! command -v stow >/dev/null 2>&1; then
    echo "❌ GNU Stow is not installed."
    echo "Install it with: apk add stow"
    exit 1
fi

# Install AstroNvim template if not already present
if [ ! -f "$HOME/.config/nvim/init.lua" ]; then
    echo "📦 Installing AstroNvim template..."
    git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
    rm -rf ~/.config/nvim/.git
    
    # Remove the template's lua directory - we'll use our own
    rm -rf ~/.config/nvim/lua
    
    echo "✓ AstroNvim template installed"
else
    echo "✓ AstroNvim template already exists"
fi

# Install TPM if not already present
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    echo "📦 Installing Tmux Plugin Manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    echo "✓ TPM installed"
else
    echo "✓ TPM already exists"
fi

# Stow dotfiles
echo "🔗 Stowing dotfiles..."
cd "$DOTFILES_DIR"

stow -v nvim
echo "✓ Neovim config stowed"

stow -v tmux
echo "✓ Tmux config stowed"

echo ""
echo "✨ Dotfiles installation complete!"
echo ""
echo "Next steps:"
echo "  1. Open nvim - plugins will install automatically"
echo "  2. Open tmux and press 'prefix + I' to install tmux plugins"
