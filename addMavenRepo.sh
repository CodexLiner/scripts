#!/bin/bash

# Prompt for Maven repository URL, username, and password
read -p "Enter Maven repository URL: " mavenUrl
read -p "Enter Maven repository username: " mavenUsername
read -p "Enter Maven repository password: " mavenPassword

# Define the new maven repository block
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
    # Read the current content of settings.gradle.kts
    currentContent=$(cat "$settingsGradlePath")

    # Check if the repository is already present
    if [[ "$currentContent" == *"$mavenUrl"* ]]; then
        echo "Maven repository already exists."
    else
        # Insert the new maven block in the repositories section
        updatedContent=$(echo "$currentContent" | sed "s/repositories {/repositories {\n$mavenRepo/")

        # Write the updated content back to the settings.gradle.kts file
        echo "$updatedContent" > "$settingsGradlePath"

        echo "New Maven repository added successfully."
    fi
else
    echo "settings.gradle.kts file not found."
fi
