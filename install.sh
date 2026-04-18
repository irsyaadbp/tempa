#!/usr/bin/env bash
set -e

echo "=================================================="
echo "🚀 Welcome to Tempa — VPS Bootstrapper"
echo "=================================================="

TEMPA_DIR="$HOME/.tempa"
REPO_URL="https://github.com/irsyaadbp/tempa.git"

# 1. Clone or Update
if [ -d "$TEMPA_DIR" ]; then
    echo "📦 Tempa is already installed. Pulling latest updates..."
    cd "$TEMPA_DIR"
    git pull origin main --quiet
else
    echo "📦 Cloning Tempa to $TEMPA_DIR..."
    git clone "$REPO_URL" "$TEMPA_DIR" --quiet
    cd "$TEMPA_DIR"
fi

# 2. Install Ansible Dependencies
echo "⚙️  Installing Ansible (this might take a minute or prompt for sudo password)..."
./scripts/install-ansible.sh

# 3. Add to PATH automatically
RC_FILE=""
if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    RC_FILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ] || [ -f "$HOME/.bashrc" ]; then
    RC_FILE="$HOME/.bashrc"
fi

if [ -n "$RC_FILE" ]; then
    if ! grep -qc "$TEMPA_DIR" "$RC_FILE"; then
        echo "" >> "$RC_FILE"
        echo "# Tempa CLI" >> "$RC_FILE"
        echo "export PATH=\"$TEMPA_DIR:\$PATH\"" >> "$RC_FILE"
    fi
    
    echo "=================================================="
    echo "✅ Tempa installed successfully!"
    echo "=================================================="
    echo "To start using it right now, run:"
    echo ""
    echo "    source $RC_FILE"
    echo ""
    echo "Then you can run 'tempa deploy' inside any project folder!"
else
    echo "✅ Tempa installed to $TEMPA_DIR"
    echo "⚠️  Could not detect ~/.bashrc or ~/.zshrc."
    echo "Please manually add $TEMPA_DIR to your PATH to use 'tempa' globally."
fi
