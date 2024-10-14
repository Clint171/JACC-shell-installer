#!/bin/bash

# Exit immediately if any command fails
set -e

# Function to display error message and exit
error_exit() {
    echo "Error: $1"
    exit 1
}

# Install the required packages
sudo apt update || error_exit "Failed to update package list."
sudo apt install snapd -y || error_exit "Failed to install snapd."
sudo snap install snapd || error_exit "Failed to install snapd from snap."
sudo snap install ant --classic || error_exit "Failed to install Ant."

# Clone the repository
git clone https://github.com/zipwith/jacc.git || error_exit "Failed to clone the repository."

# Build the project
cd jacc || error_exit "Failed to enter the project directory."
ant || error_exit "Failed to build the project with Ant."

# Create a shell script to run the project and store it in /usr/local/bin
echo "#!/bin/bash
java -jar $(pwd)/dist/jacc.jar \"\$@\"" | sudo tee /usr/local/bin/jacc > /dev/null || error_exit "Failed to create the run script."

# Also in usr/bin for redundancy
echo "#!/bin/bash
java -jar $(pwd)/dist/jacc.jar \"\$@\"" | sudo tee /usr/bin/jacc > /dev/null || error_exit "Failed to create the run script."

# Make the script executable
sudo chmod +x /usr/local/bin/jacc || error_exit "Failed to make the script executable."

# Provide feedback to the user
echo "The project has been built, and the run script 'jacc' has been created."
echo "You can run the project by typing 'jacc' in your terminal from anywhere."
echo "Made by Clint : clintsimiyu004@gmail.com"
