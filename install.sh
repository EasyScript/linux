#!/bin/bash

# Function to install packages based on the distribution
install_packages() {
  distro=$1
  shift
  packages=("$@")

  case $distro in
    "ubuntu" | "debian")
      sudo apt-get update
      for package in "${packages[@]}"; do
        echo "Installing $package..."
        sudo apt-get install -y "$package"
      done
      ;;
    "fedora")
      for package in "${packages[@]}"; do
        echo "Installing $package..."
        sudo dnf install -y "$package"
      done
      ;;
    "arch")
      for package in "${packages[@]}"; do
        echo "Installing $package..."
        sudo pacman -S --noconfirm "$package"
      done
      ;;
    "opensuse")
      for package in "${packages[@]}"; do
	echo "Installing $package..."
	sudo zypper install -y
      done 
      ;;
    *)
      echo "Unsupported distribution: $distro"
      exit 1
      ;;
  esac
}

# Display ASCII text
cat << "EOF"
  _____           _        _ _       _   _                _____           _       _   
 |_   _|         | |      | | |     | | (_)              / ____|         (_)     | |  
   | |  _ __  ___| |_ __ _| | | __ _| |_ _  ___  _ __   | (___   ___ _ __ _ _ __ | |_ 
   | | | '_ \/ __| __/ _` | | |/ _` | __| |/ _ \| '_ \   \___ \ / __| '__| | '_ \| __|
  _| |_| | | \__ \ || (_| | | | (_| | |_| | (_) | | | |  ____) | (__| |  | | |_) | |_ 
 |_____|_| |_|___/\__\__,_|_|_|\__,_|\__|_|\___/|_| |_| |_____/ \___|_|  |_| .__/ \__|
                                                                           | |        
                                                                           |_|                                            
EOF

# Prompt to confirm running the script
read -p "Do you want to run the installation script? (y/n): " answer

# Check the user's response
if [[ $answer =~ ^[Yy]$ ]]; then
  # Attempt to determine the distribution
  if command -v lsb_release >/dev/null 2>&1; then
    distro=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
  elif [ -f "/etc/os-release" ]; then
    distro=$(awk -F= '/^ID=/{print tolower($2)}' /etc/os-release)
  else
    echo "Unable to determine the distribution."
    exit 1
  fi

  # Define the common packages
  common_packages=("firefox" "tldr" "neovim")

  # Install common packages
  install_packages "$distro" "${common_packages[@]}"                                                                         

  # Add more applications or customizations as needed
  # For example:
  # sudo apt-get install -y vim git
  # sudo dnf install -y htop

  echo "Installation complete."
else
  echo "Script execution aborted by user."
fi


