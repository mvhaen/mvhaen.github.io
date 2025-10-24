#!/bin/bash

# Sync external content to Jekyll includes
echo "Syncing external content..."

# Clone the external repository temporarily
echo "Cloning external repository..."
git clone https://github.com/mvhaen/psychology-of-agility-papers.git _temp-external

# Copy content from external repo to includes (skip the title since it's in front matter)
echo "Copying content to _includes..."
tail -n +2 _temp-external/insensitivity-entrenchment-agility/insensitivity-entrenchment-agility.md > _includes/external-insensitivity-content.html

# Clean up temporary directory
echo "Cleaning up..."
rm -rf _temp-external

echo "Content synced successfully!"
echo "Don't forget to commit and push the changes."
