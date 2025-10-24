#!/bin/bash

# Sync external content to Jekyll includes
echo "Syncing external content..."

# Update submodule first
echo "Updating submodule..."
git submodule update --remote

# Copy content from submodule to includes (skip the title since it's in front matter)
echo "Copying content to _includes..."
tail -n +2 _external-content/insensitivity-entrenchment-agility/insensitivity-entrenchment-agility.md > _includes/external-insensitivity-content.html

echo "Content synced successfully!"
echo "Don't forget to commit and push the changes."
