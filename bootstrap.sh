#!/usr/bin/env bash
# 
# Bootstrap script for setting up a new OSX machine
# 
# This should be idempotent so it can be run multiple times.
#
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
#
# Reading:
#
# - http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac
# - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
# - https://news.ycombinator.com/item?id=8402079
# - http://notes.jerzygangi.com/the-best-pgp-tutorial-for-mac-os-x-ever/
#
# This installer works also behind a corporate proxy. In order to make this work, you 
# need to setup a reverse proxy using CNTLM or Preproxy. Unfortunately there is no
# brew package for preproxy

echo "Starting bootstrapping"

# create a config file to make sure git push works behind a preproxy
echo "creating ssh config file"
file_location=~/.ssh/config
if [ -f $file_location ]; then
  echo "check if the config file already exists" 
  echo "File $file_location already exists!"
else
  cat > $file_location <<EOF
host github.com
    user git
    hostname ssh.github.com
    port 443
    proxycommand socat - PROXY:localhost:%h:%p,proxyport=3128
EOF
fi

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash

PACKAGES=(
    ack
    autoconf
    automake
    ansible
    boot2docker
    balenaetcher
    gettext
    git
    graphviz
    hub
    htop
    imagemagick
    jq
    libjpeg
    libmemcached 
    lynx
    markdown
    mackup
    memcached
    npm
    pkg-config
    rename
    terminal-notifier
    tldr
    the_silver_searcher
    tmux
    tree
    vim
    socat # needed for ssh through proxy
    wget
)

echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Installing cask..."
brew Tap homebrew/cask 

CASKS=(
    drawio
    enpass
    firefox
    flux
    google-drive
    iterm2
    microsoft-office
    microsoft-teams
    snip
    vagrant
    virtualbox
    vlc
    visual-studio-code
    google-chrome
    nomad
)

echo "Installing cask apps... Mind you, you can be requested for a password."
brew install --cask  ${CASKS[@]}
brew upgrade 

echo "Configuring OSX..."

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Require password as soon as screensaver or sleep mode starts
# defaults write com.apple.screensaver askForPassword -int 1
# defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable "natural" scroll
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true



echo "creating bash profile"
file_location=~/.profile
if [ -f $file_location ]; then
  echo "check if the .profile file already exists" 
  echo "$file_location already exists!"
else
  wget -P ~/ https://raw.githubusercontent.com/marcowork/profile/main/.profile
  source ~/.profile
fi



echo "Bootstrapping complete"