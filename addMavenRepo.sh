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
        # Use a temporary file to avoid overwriting issues
        tempFile=$(mktemp)

        # Copy existing content to temp file and append the new repository block
        while IFS= read -r line; do
            echo "$line" >> "$tempFile"
            # Debug: print the line being read
            echo "Read line: $line"
            # Append the new maven repo after the repositories block
            if [[ "$line" == "repositories {" ]]; then
                echo "$mavenRepo" >> "$tempFile"
                echo "Inserted new Maven repo block."
            fi
        done < "$settingsGradlePath"

        # Debug: print the temporary file content before replacing the original file
        echo "Temporary file content:"
        cat "$tempFile"

        # Replace the original file with the updated temp file
        mv "$tempFile" "$settingsGradlePath"

        echo "New Maven repository added successfully."
    fi
else
    echo "settings.gradle.kts file not found."
fi
