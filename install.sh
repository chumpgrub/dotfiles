#!/bin/bash

set -e  # Exit on error

echo "🍎 Installing dotfiles (macOS)..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where this script lives
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This is the macOS branch. Use the main branch for other platforms."
    exit 1
fi

# Check if stow is available (will be installed via Homebrew if not)
if ! command -v stow &> /dev/null && ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}⚠️  Neither Stow nor Homebrew found. Homebrew will be installed first.${NC}"
fi

# ==========================================
# HOMEBREW INSTALLATION & PACKAGES
# ==========================================

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo -e "${BLUE}📦 Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for this session
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    echo -e "${GREEN}✓ Homebrew installed${NC}"
else
    echo -e "${GREEN}✓ Homebrew already installed${NC}"
fi

# Install packages from Brewfile
if [ -f "$DOTFILES_DIR/homebrew/Brewfile" ]; then
    echo -e "${BLUE}📦 Installing Homebrew packages...${NC}"
    brew bundle --file="$DOTFILES_DIR/homebrew/Brewfile"
    echo -e "${GREEN}✓ Homebrew packages installed${NC}"
else
    echo -e "${YELLOW}⚠️  No Brewfile found, skipping package installation${NC}"
fi

# ==========================================
# ASTRONVIM INSTALLATION
# ==========================================

# Install AstroNvim template if not already present
if [ ! -f "$HOME/.config/nvim/init.lua" ]; then
    echo -e "${BLUE}📦 Installing AstroNvim template...${NC}"
    git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
    rm -rf ~/.config/nvim/.git
    
    # Remove the template's lua directory - we'll use our own
    rm -rf ~/.config/nvim/lua
    
    echo -e "${GREEN}✓ AstroNvim template installed${NC}"
else
    echo -e "${GREEN}✓ AstroNvim template already exists${NC}"
fi

# ==========================================
# TMUX PLUGIN MANAGER
# ==========================================

# Install TPM if not already present
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    echo -e "${BLUE}📦 Installing Tmux Plugin Manager (TPM)...${NC}"
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
    echo -e "${GREEN}✓ TPM installed${NC}"
else
    echo -e "${GREEN}✓ TPM already exists${NC}"
fi

# ==========================================
# STOW DOTFILES
# ==========================================

echo -e "${BLUE}🔗 Stowing dotfiles...${NC}"
cd "$DOTFILES_DIR"

# Core packages (always stow these)
stow -v nvim
echo -e "${GREEN}✓ Neovim config stowed${NC}"

stow -v tmux
echo -e "${GREEN}✓ Tmux config stowed${NC}"

# macOS-specific packages (stow if they exist)
if [ -d "ghostty" ]; then
    stow -v ghostty
    echo -e "${GREEN}✓ Ghostty config stowed${NC}"
fi

if [ -d "karabiner" ]; then
    stow -v karabiner
    echo -e "${GREEN}✓ Karabiner config stowed${NC}"
fi

if [ -d "homebrew" ]; then
    stow -v homebrew
    echo -e "${GREEN}✓ Homebrew config stowed${NC}"
fi

if [ -d "git" ]; then
    stow -v git
    echo -e "${GREEN}✓ Git config stowed${NC}"
fi

if [ -d "zsh" ]; then
    stow -v zsh
    echo -e "${GREEN}✓ Zsh config stowed${NC}"
fi

# ==========================================
# MACOS SYSTEM DEFAULTS
# ==========================================

# Apply macOS system defaults
if [ -f "$DOTFILES_DIR/macos/.macos" ]; then
    echo -e "${BLUE}⚙️ Applying macOS system defaults...${NC}"
    bash "$DOTFILES_DIR/macos/.macos"
    echo -e "${GREEN}✓ macOS defaults applied${NC}"
else
    echo -e "${YELLOW}⚠️  No macOS defaults file found, skipping${NC}"
fi

# ==========================================
# POST-INSTALLATION SETUP
# ==========================================

echo ""
echo -e "${GREEN}✨ macOS dotfiles installation complete!${NC}"
echo ""
echo "📋 Next steps:"
echo "  1. Restart your terminal to load new shell configs"
echo "  2. Open Neovim - plugins will install automatically"
echo "  3. Open tmux and press 'Ctrl-a + I' to install tmux plugins"
echo "  4. Configure Ghostty font: JetBrainsMono Nerd Font"
echo ""
echo "🔧 Optional manual steps:"
echo "  • Configure system preferences that require manual setup"
echo "  • Sign into applications (1Password, GitHub, etc.)"
echo "  • Set up SSH keys and GPG if needed"
echo ""
echo -e "${BLUE}💡 Tip: Run './install.sh' again anytime to update configs${NC}"
