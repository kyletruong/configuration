#!/usr/bin/env bash

# =============================================================================
# This script creates symlinks from home directory to desired dotfiles
# Also runs brew.sh which installs packages and MacOS apps
# =============================================================================

if [ "$#" -ne 1 ]; then
    echo "Missing homedir argument -- ./install.sh <home_directory>"
    exit 1
fi

homedir=$1

# Dotfiles directory
dotfiledir=${homedir}/dotfiles

# List of files/folders to symlink in ${homedir}
files="zprofile zshrc tmux.conf vimrc gitignore_global"

# Change to the dotfiles directory
echo "Changing to the ${dotfiledir} directory"
cd ${dotfiledir}
echo "...done"

# Create symlinks (will overwrite old dotfiles)
for file in ${files}; do
    echo "Creating symlink to $file in home directory."
    ln -sfn ${dotfiledir}/.${file} ${homedir}/.${file}
done

# Run the homebrew script
./brew.sh

# Make gitconfig recognize global gitignore
git config --global core.excludesfile ~/.gitignore_global

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Import fonts
mv ${dotfiledir}/SF-Mono-Powerline/*.otf ${homedir}/Library/Fonts/
