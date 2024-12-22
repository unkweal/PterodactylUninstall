#!/bin/bash

# Clear the screen
clear

# Function to display a header
function header {
    echo "$1"
}

# Function to confirm removal
function confirm_removal {
    echo "Are you sure you want to remove the Pterodactyl Panel and Wings? (y/n)"
}

# Function for loading animation
function loading {
    echo -n "$1"
    for i in {1..3}; do
        echo -n "."
        sleep 0.5
    done
    echo ""
}

# Display header
header "Pterodactyl Panel and Wings Uninstaller"

# Confirmation prompt
confirm_removal
read -p "Enter your response: " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Removal canceled. Exiting..."
    exit 0
fi

# Remove Pterodactyl panel files
header "Removing Pterodactyl Panel Files"
loading "Removing panel files"
sudo rm -rf /var/www/pterodactyl || { echo "Error removing Pterodactyl panel files."; exit 1; }

# Remove Pteroq queue worker
header "Removing Pteroq Queue Worker"
loading "Removing pteroq.service"
sudo rm /etc/systemd/system/pteroq.service || { echo "Error removing pteroq.service."; exit 1; }

# Unlink nginx configuration
header "Removing Nginx Configuration"
loading "Removing nginx config"
sudo unlink /etc/nginx/sites-enabled/pterodactyl.conf || { echo "Error removing nginx configuration."; exit 1; }

# Unlink apache configuration
header "Removing Apache Configuration"
loading "Removing apache config"
sudo unlink /etc/apache2/sites-enabled/pterodactyl.conf || { echo "Error removing apache configuration."; exit 1; }

# Stop Wings
header "Stopping Wings"
loading "Stopping wings"
sudo systemctl stop wings || { echo "Error stopping wings."; exit 1; }

# Remove Wings game server files and backups
header "Removing Wings Files and Backups"
loading "Removing game server files"
sudo rm -rf /var/lib/pterodactyl || { echo "Error removing game server files."; exit 1; }

# Remove Wings config
header "Removing Wings Configuration"
loading "Removing wings config"
sudo rm -rf /etc/pterodactyl || { echo "Error removing wings configuration."; exit 1; }

# Remove Wings binary
header "Removing Wings Binary"
loading "Removing wings binary"
sudo rm /usr/local/bin/wings || { echo "Error removing wings binary."; exit 1; }

# Remove Wings daemon file
header "Removing Wings Daemon File"
loading "Removing wings.service"
sudo rm /etc/systemd/system/wings.service || { echo "Error removing wings.service."; exit 1; }

# Completion message
header "Pterodactyl Panel and Wings have been successfully removed!"
