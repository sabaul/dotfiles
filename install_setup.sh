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

# Step 2: Install Zed
echo "Installing Zed..."
curl -f https://zed.dev/install.sh | sh

# Step 3: Install required packages
echo "Installing packages: kitty, tmux, alacritty, i3-wm, i3lock, i3status, i3blocks, xbacklight, git, htop, vim, jq..."
apt update
apt install -y kitty tmux alacritty i3-wm i3lock i3status i3blocks xbacklight git htop vim jq

# Step 4: Get i3 config from GitHub
echo "Getting i3 config from GitHub..."
mkdir -p ~/.config/i3
curl -fsSL https://github.com/sabaul/dotfiles/raw/main/i3/config -o ~/.config/i3/config

# Step 5: Get i3status config from GitHub
echo "Getting i3status config from GitHub..."
mkdir -p ~/.config/i3status
curl -fsSL https://github.com/sabaul/dotfiles/raw/main/i3status/config -o ~/.config/i3status/config

# Step 6: Get kitty config from GitHub
echo "Getting kitty config from GitHub..."
mkdir -p ~/.config/kitty
curl -fsSL https://github.com/sabaul/dotfiles/raw/main/kitty/kitty.conf -o ~/.config/kitty/kitty.conf

# Step 7: Download the latest Nerd Fonts (UbuntuMono and JetBrainsMono)
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


# Step 8: Create the xorg.conf file for Intel graphics
echo "Creating xorg.conf for Intel graphics..."
cat <<EOL > /usr/share/X11/xorg.conf.d/20-intel.conf
Section "Device"
    Identifier  "card0"
    Driver      "intel"
    Option      "Backlight"  "intel_backlight"
    BusID       "PCI:0:2:0"
EndSection
EOL

# Step 9: Create touchpad configuration
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

# Step 10: Download vimrc configuration from GitHub
echo "Getting vimrc configuration from GitHub..."
curl -fsSL https://github.com/sabaul/dotfiles/raw/main/vim/vimrc -o ~/.vimrc
