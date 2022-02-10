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

# Install xcode
## //TODO CHeck if xcode is already installed
if ! command -v xcode-select -p &> /dev/null
    then xcode-select --install
    exit
else echo "xcode-select is already installed"
fi

## For WorkMacbook you have to run this shell script in order to get proper access for Homebrew
have_sudo_access() {
  HAVE_SUDO_ACCESS="0"
  if [[ -z "${HOMEBREW_ON_LINUX-}" ]] && [[ "${HAVE_SUDO_ACCESS}" -ne 0 ]]
  then
    abort "Need sudo access on macOS (e.g. the user ${USER} needs to be an Administrator)!"
  fi
 
  return "${HAVE_SUDO_ACCESS}"
}

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
if ! command -v brew install coreutils &> /dev/null
    then brew install coreutils
    exit
else echo "coreutils is already installed"
fi


# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
if ! command -v brew install findutils &> /dev/null
    then brew install findutils
    exit
else echo "findutils is already installed"
fi

# Install Bash 4
if ! command -v brew install bash &> /dev/null
    then brew install bash
    exit
else echo "bash is already installed"
fi

PACKAGES=(
    ack
    autoconf
    archey #https://obihann.github.io/archey-osx/
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
    thefuck
    the_silver_searcher
    tmux
    tree
    vim
    socat # needed for ssh through proxy
    wget
    wifi-password #will get the wifi password of the network you are on after a Keychain authentication
)

echo "Installing packages..."
if ! command -v brew install ${PACKAGES[@]} &> /dev/null
    then  brew install ${PACKAGES[@]}
else  brew upgrade
fi

echo "Installing cask..."
brew Tap homebrew/cask 

CASKS=(
    adobe-acrobat-reader
    caffeine
    drawio
    enpass
    firefox
    flux
    google-drive
    iterm2
    insomnia
    jiggler
    microsoft-office
    microsoft-teams
    microsoft-remote-desktop
    snip
    vagrant
    virtualbox
    vlc
    visual-studio-code
    google-chrome
    nomad
)

echo "Installing cask apps... Mind you, you can be requested for a password."
if ! command -v brew install --cask  ${CASKS[@]} &> /dev/null
    then  --cask  ${CASKS[@]}
else  brew upgrade
fi


echo "Configuring OSX..."

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2 # normal minimum is 2 (30 ms)
# The changes aren't applied until you log out and back in. KeyRepeat can't be set between 2 (30 ms) and 1 (15 ms) though.



# Require password as soon as screensaver or sleep mode starts
# defaults write com.apple.screensaver askForPassword -int 1
# defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool false

# Enable tap-to-click
# defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
# defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable "natural" scroll
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true


# set hostname to whatever I want it to be
sudo scutil --set HostName MarcoWork-Mac
#sudo scutil --set HostName APM3LC02C85D2MD6T-9866562

echo "creating bash profile"
file_location=~/.profile
if [ -f $file_location ]; then
  echo "check if the .profile file already exists" 
  echo "$file_location already exists!"
else
  wget -P ~/ https://raw.githubusercontent.com/marcowork/profile/main/.profile
  source ~/.profile
fi


echo "fixing display settings every time"
# In order to get the displays to be set via the command line we need to download displayplacer
# https://github.com/jakehilborn/displayplacer 

echo "downloading displayplacer from github"
brew tap jakehilborn/jakehilborn && brew install displayplacer

echo "grabbing your current settings"
displayplacer list

echo "setting your screens as to your settings"
displayplacer "id:AB151011-F65C-61EE-4DE5-98BB08D38AA3 res:1792x1120 hz:59 color_depth:4 scaling:on origin:(0,0) degree:0" "id:419AE185-DFFB-79EC-3782-97473883A7BB res:1920x1080 hz:60 color_depth:8 scaling:off origin:(826,-1080) degree:0" "id:6BFF9EC0-E99A-6A36-9A60-778B98FECFF5 res:1920x1080 hz:60 color_depth:8 scaling:off origin:(-1094,-1080) degree:0"

echo "grabbing your new settings"
displayplacer list

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

echo "Bootstrapping complete"