#!/usr/bin/env bash
set -e

echo "🚀 Installing Ansible on control machine..."

OS="$(uname -s)"
case "${OS}" in
    Linux*)
        if [ -f /etc/debian_version ]; then
            echo "Detected Debian/Ubuntu."
            sudo apt update
            sudo apt install -y software-properties-common curl sshpass
            sudo apt-add-repository --yes --update ppa:ansible/ansible
            sudo apt install -y ansible
        else
            echo "Unsupported Linux distribution for this script. Please install Ansible manually."
            exit 1
        fi
        ;;
    Darwin*)
        echo "Detected macOS."
        if ! command -v brew &> /dev/null; then
            echo "Homebrew not found. Please install Homebrew first: https://brew.sh/"
            exit 1
        fi
        brew install ansible
        
        # Install hudochenkov/sshpass since standard brew core removed sshpass
        if ! command -v sshpass &> /dev/null; then
            brew install hudochenkov/sshpass/sshpass
        fi
        ;;
    *)
        echo "Unsupported OS: ${OS}"
        exit 1
        ;;
esac

echo "✅ Ansible installed successfully!"
ansible --version
