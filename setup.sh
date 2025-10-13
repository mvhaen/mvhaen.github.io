#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Setting up Rooster's Blog for local development...${NC}\n"

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo -e "${RED}Error: Homebrew is not installed.${NC}"
    echo "Please install Homebrew first: https://brew.sh"
    exit 1
fi

# Check if rbenv is installed
if ! command -v rbenv &> /dev/null; then
    echo -e "${YELLOW}Installing rbenv and ruby-build...${NC}"
    brew install rbenv ruby-build
else
    echo -e "${GREEN}✓ rbenv is already installed${NC}"
fi

# Initialize rbenv
echo -e "${YELLOW}Initializing rbenv...${NC}"
eval "$(rbenv init - zsh)"

# Check if rbenv init is in shell config
if ! grep -q 'rbenv init' ~/.zshrc; then
    echo -e "${YELLOW}Adding rbenv to ~/.zshrc...${NC}"
    echo '' >> ~/.zshrc
    echo '# rbenv initialization' >> ~/.zshrc
    echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
    echo -e "${GREEN}✓ Added rbenv initialization to ~/.zshrc${NC}"
fi

# Install Ruby 3.2.0 if not already installed
RUBY_VERSION="3.2.0"
if ! rbenv versions | grep -q "$RUBY_VERSION"; then
    echo -e "${YELLOW}Installing Ruby ${RUBY_VERSION}...${NC}"
    rbenv install $RUBY_VERSION
else
    echo -e "${GREEN}✓ Ruby ${RUBY_VERSION} is already installed${NC}"
fi

# Set local Ruby version
echo -e "${YELLOW}Setting Ruby version for this project...${NC}"
rbenv local $RUBY_VERSION

# Verify Ruby version
echo -e "\n${GREEN}Current Ruby version:${NC}"
ruby -v

# Install Bundler
echo -e "\n${YELLOW}Installing Bundler...${NC}"
gem install bundler

# Configure bundler to use local path
echo -e "${YELLOW}Configuring Bundler to use local gem path...${NC}"
bundle config set --local path 'vendor/bundle'

# Remove old Gemfile.lock if it exists
if [ -f Gemfile.lock ]; then
    echo -e "${YELLOW}Removing old Gemfile.lock...${NC}"
    rm Gemfile.lock
fi

# Install gems
echo -e "${YELLOW}Installing gems...${NC}"
bundle install

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}Setup complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\nTo start the development server, run:"
echo -e "${YELLOW}bundle exec jekyll serve${NC}"
echo -e "\nOr for live reload:"
echo -e "${YELLOW}bundle exec jekyll serve --livereload${NC}"
echo -e "\nThen open your browser to: ${YELLOW}http://localhost:4000${NC}"
echo -e "\n${YELLOW}Note: You may need to restart your terminal or run 'source ~/.zshrc' for rbenv to work properly.${NC}\n"

