#!/bin/bash

# Prompt for Maven repository URL, username, and password
read -p "Enter Maven repository URL: " mavenUrl
read -p "Enter Maven repository username: " mavenUsername
read -p "Enter Maven repository password: " mavenPassword

# Define the new Maven repository block
mavenRepo=$(cat <<EOF
    maven {
        url = uri("$mavenUrl")
        credentials {
            username = "$mavenUsername"
            password = "$mavenPassword"
        }
    }
EOF
)

# Path to the settings.gradle.kts file
settingsGradlePath="settings.gradle.kts"

if [ -f "$settingsGradlePath" ]; then
    # Check if the repository is already present
    if grep -q "$mavenUrl" "$settingsGradlePath"; then
        echo "Maven repository already exists."
    else
        # Insert the new maven block in the repositories section
        # Make sure it inserts right before the closing brace of the repositories block
        sed -i.bak "/repositories {/a $mavenRepo" "$settingsGradlePath"

        echo "New Maven repository added successfully."
    fi
else
    echo "settings.gradle.kts file not found."
fi
