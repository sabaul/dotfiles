#!/bin/bash

# Make sure to run this script as sudo user
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script with sudo privileges."
    exit 1
fi

echo "Starting installation..."

# Step 1: Install Brave browser
echo "Installing Brave browser..."
curl -fsS https://dl.brave.com/install.sh | sh

# Step 2: Ensure Flatpak and Flathub are available
echo "Checking for Flatpak..."

if ! command -v flatpak &> /dev/null; then
    echo "Flatpak not found. Installing Flatpak..."
    apt install -y flatpak
else
    echo "Flatpak is already installed."
fi

# Add Flathub repository if not already present
echo "Ensuring Flathub repository is added..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Step 3: Install VSCodium via Flatpak
echo "Installing VSCodium..."
flatpak install -y flathub com.vscodium.codium

# Create alias in .bashrc
echo "Creating alias for VSCodium..."
echo "alias codium='flatpak run com.vscodium.codium'" >> ~/.bashrc


# Step 4: Install required packages
echo "Installing packages: kitty, tmux, alacritty, i3-wm, i3lock, i3status, i3blocks, xbacklight, git, htop, vim, jq..."
apt update
apt install -y kitty tmux alacritty i3-wm i3lock i3status i3blocks xbacklight git htop vim jq

# Step 5: Get i3 config from GitHub
echo "Getting i3 config from GitHub..."
mkdir -p ~/.config/i3
curl -fsSL https://github.com/sabaul/dotfiles/raw/main/i3/config -o ~/.config/i3/config

# Step 6: Get i3status config from GitHub
echo "Getting i3status config from GitHub..."
mkdir -p ~/.config/i3status
curl -fsSL https://github.com/sabaul/dotfiles/raw/main/i3status/config -o ~/.config/i3status/config

# Step 7: Get kitty config from GitHub
echo "Getting kitty config from GitHub..."
mkdir -p ~/.config/kitty
curl -fsSL https://github.com/sabaul/dotfiles/raw/main/kitty/kitty.conf -o ~/.config/kitty/kitty.conf

# Step 8: Download the latest Nerd Fonts (UbuntuMono and JetBrainsMono)
echo "Downloading the latest Nerd Fonts..."
mkdir -p ~/.config/.fonts

# Get the latest release tag from GitHub API
latest_release=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | jq -r .tag_name)

# Download the latest release zip files
curl -L "https://github.com/ryanoasis/nerd-fonts/releases/download/${latest_release}/UbuntuMono.zip" -o ~/UbuntuMono.zip
curl -L "https://github.com/ryanoasis/nerd-fonts/releases/download/${latest_release}/JetBrainsMono.zip" -o ~/JetBrainsMono.zip

# Extract the fonts
echo "Extracting fonts..."
unzip ~/UbuntuMono.zip -d ~/.config/.fonts/
unzip ~/JetBrainsMono.zip -d ~/.config/.fonts/

# Clean up zip files
rm ~/UbuntuMono.zip
rm ~/JetBrainsMono.zip


# Step 9: Create the xorg.conf file for Intel graphics
echo "Creating xorg.conf for Intel graphics..."
cat <<EOL > /usr/share/X11/xorg.conf.d/20-intel.conf
Section "Device"
    Identifier  "card0"
    Driver      "intel"
    Option      "Backlight"  "intel_backlight"
    BusID       "PCI:0:2:0"
EndSection
EOL

# Step 10: Create touchpad configuration
echo "Creating touchpad configuration..."
cat <<EOL > /etc/X11/xorg.conf.d/90-touchpad.conf
Section "InputClass"
    Identifier "touchpad"
    MatchIsTouchpad "on"
    Driver "libinput"
    Option "Tapping" "on"
    Option "TappingButtonMap" "lrm"
    Option "NaturalScrolling" "on"
    Option "ScrollMethod" "twofinger"
EndSection
EOL

echo "Installation completed successfully!"

# Step 11: Download vimrc configuration from GitHub
echo "Getting vimrc configuration from GitHub..."
curl -fsSL https://github.com/sabaul/dotfiles/raw/main/vim/vimrc -o ~/.vimrc


# Step 12: Reload bashrc to apply aliases and environment changes
echo "Sourcing .bashrc to apply changes..."
source ~/.bashrc

echo "Installation completed successfully!"

# Prompt for restart
read -p "Do you want to restart the system now? [Y/n]: " restart
restart=${restart:-Y}

if [[ "$restart" =~ ^[Yy]$ ]]; then
    echo "Restarting system..."
    reboot
else
    echo "Skipping restart. You may need to reboot manually later."
fi
