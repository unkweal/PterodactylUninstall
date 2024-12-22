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
loading "Removing users"
mysql -u root -p -e "DROP USER 'pterodactyl'@'127.0.0.1';" || { echo "Error removing user 'pterodactyl'@'127.0.0.1'."; exit 1; }
mysql -u root -p -e "DROP USER 'pterodactyl'@'localhost';" || { echo "Error removing user 'pterodactyl'@'localhost'."; exit 1; }

# Remove Pterodactyl database
header "Removing Pterodactyl Database"
loading "Removing database"
mysql -u root -p -e "DROP DATABASE IF EXISTS pterodactyl;" || { echo "Error removing database."; exit 1; }

# Remove Pterodactyl files
header "Removing Pterodactyl Files"
loading "Removing files"
rm -rf /var/www/pterodactyl || { echo "Error removing files."; exit 1; }

# Remove dependencies
header "Removing Pterodactyl Dependencies"
loading "Removing dependencies"
apt-get remove --purge -y <dependencies_packages> || { echo "Error removing dependencies."; exit 1; }

# Completion message
header "Pterodactyl has been successfully removed!"
