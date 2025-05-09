#!/bin/bash

# Exit on error
set -e

# Install yay (AUR Helper)
echo "Installing yay..."
if ! command -v yay &> /dev/null; then
  sudo pacman -S --needed --noconfirm git base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
  cd ..
  rm -rf yay
else
  echo "yay is already installed."
fi

# Fetch pkglist.txt if not present locally
if [ ! -f pkglist.txt ]; then
  echo "pkglist.txt not found. Fetching from URL..."
  curl -o pkglist.txt https://raw.githubusercontent.com/lohopupa/.dotfiles/refs/heads/main/pkglist.txt
else
  echo "pkglist.txt found locally."
fi

# Install packages from pkglist.txt
echo "Installing packages..."
if [ -f pkglist.txt ]; then
  xargs -a pkglist.txt -r yay -S --needed --noconfirm
else
  echo "No pkglist.txt found. Skipping package installation."
fi

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh is already installed."
fi

# INstalling zsh plugins 
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
PLUGINS_DIR="$ZSH_CUSTOM/plugins"
PLUGINS=(
    "zsh-users/zsh-syntax-highlighting"
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-completions"
)

mkdir -p "$PLUGINS_DIR"

for plugin in "${PLUGINS[@]}"; do
    PLUGIN_NAME=$(basename "$plugin")
    if [ ! -d "$PLUGINS_DIR/$PLUGIN_NAME" ]; then
        git clone "https://github.com/$plugin.git" "$PLUGINS_DIR/$PLUGIN_NAME"
    else
        echo "$PLUGIN_NAME already installed. Skipping."
    fi
done
t_classification
  echo "Dotfiles repository already exists. Pulling latest changes..."
  cd ~/.dotfiles && git pull && cd -
fi

# Apply dotfiles using stow
echo "Applying dotfiles..."
cd ~/.dotfiles
stow --override .

echo "Setup complete!"
