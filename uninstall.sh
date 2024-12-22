#!/bin/bash

# Clear the screen
clear

# Function to display a header
function header {
    echo "========================================="
    echo "$1"
    echo "========================================="
}

# Function to confirm removal
function confirm_removal {
    echo "Are you sure you want to remove the Pterodactyl Panel? (y/n)"
}

# Display header
header "Pterodactyl Panel Uninstaller"

# Confirmation prompt
confirm_removal
read -p "Enter your response: " confirm

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Removal canceled. Exiting..."
    exit 0
fi

# Remove Pterodactyl users
header "Removing Pterodactyl Users"
mysql -u root -p -e "DROP USER 'pterodactyl'@'127.0.0.1';" || { echo "Error removing user 'pterodactyl'@'127.0.0.1'."; exit 1; }
mysql -u root -p -e "DROP USER 'pterodactyl'@'localhost';" || { echo "Error removing user 'pterodactyl'@'localhost'."; exit 1; }

# Remove Pterodactyl database
header "Removing Pterodactyl Database"
mysql -u root -p -e "DROP DATABASE IF EXISTS pterodactyl;" || { echo "Error removing database."; exit 1; }

# Remove Pterodactyl files
header "Removing Pterodactyl Files"
rm -rf /var/www/pterodactyl || { echo "Error removing files."; exit 1; }

# Remove dependencies
header "Removing Pterodactyl Dependencies"
apt-get remove --purge -y <dependencies_packages> || { echo "Error removing dependencies."; exit 1; }

# Completion message
header "Pterodactyl has been successfully removed!"
