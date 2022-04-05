#!/bin/bash
# macOSBootstrap
# Chris Morris
# Last Updated: April, 2022
# Last Tested: macOS 12.3.1

set -euo pipefail
IFS=$'\n\t'

# PRECONDITIONS
# 1. Make script executable. chmod +x macOSBootstrap.sh
# 2. Your password may be necessary for some packages
# 3. XCode Command Line Tools must be pre-installed. xcode-select --install
# 4. System settings allow the termianl full disk access. Avoid errors.

# `set -eu` causes an 'unbound variable' error in case SUDO_USER is not set
SUDO_USER=$(whoami)

# Check for Homebrew, install if not installed
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

brew update
brew upgrade

# Find the CLI Tools update
echo "find CLI tools update"
PROD=$(softwareupdate -l | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n') || true
# Install it
if [[ ! -z "$PROD" ]]; then
  softwareupdate -i "$PROD" --verbose
fi

PACKAGES=(
    git
    npm
    nvm
    node
    pkg-config
    python
    zsh-completions
    zsh-syntax-highlighting
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

CASKS=(
    dropbox
    firefox
    google-chrome
    iterm2
    keepassxc
    microsoft-office
    microsoft-teams
    minecraft
    rectangle
    postman
    slack
    spotify
    steam
    transmission
    visual-studio-code
    vlc
    zoom
)

echo "Installing cask apps..."
sudo -u $SUDO_USER brew install --cask ${CASKS[@]}

echo "Installing Python packages..."
sudo -u $SUDO_USER pip3 install --upgrade pip
sudo -u $SUDO_USER pip3 install --upgrade setuptools

PYTHON_PACKAGES=(
    beautifulsoup4
    Django
    virtualenv
)
sudo -u $SUDO_USER pip3 install ${PYTHON_PACKAGES[@]}

echo "Cleaning up"
brew cleanup
echo "Checkup"
brew doctor

echo "macOS Bootstrap Complete"
