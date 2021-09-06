# macbootstrap

![example workflow](https://github.com/marcowork/macbootstrap/actions/workflows/github-action.yml/badge.svg)

## Bootstrapping my mac

### HomeBrew
This bootstrap shell script will make sure Homebrew is installed. 

This installer works also behind a corporate proxy. In order to make this work, you 
need to setup a reverse proxy using CNTLM or Preproxy. Unfortunately there is no
brew package for preproxy

### Git behind proxy
To make git work behind a corporate proxy over ssh you need to set a create a config file in `~/.ssh/config containing` the following:
```
host github.com
    user git
    hostname ssh.github.com
    port 443
    proxycommand socat - PROXY:localhost:%h:%p,proxyport=3128

``` 
This script will make sure your config file is created accordingly



### Installed packages 

The folowing packages are installed to make it easier for me to controle my macbook

    1. ack
    2. autoconf
    3. archey #https://obihann.github.io/archey-osx/
    4. automake
    5. ansible
    6. boot2docker
    7. balenaetcher
    8. gettext
    9. git
    10. graphviz
    11. hub
    12. htop
    13. imagemagick
    14. jq
    15. libjpeg
    16. libmemcached 
    17. lynx
    18. markdown
    19. mackup
    20. memcached
    21. npm
    22. pkg-config
    23. rename
    24. terminal-notifier
    25. tldr
    26. the_silver_searcher
    27. tmux
    28. tree
    29. vim
    30. socat # needed for ssh through proxy
    31. wget
    32. wifi-password #will get the wifi password of the network you are on after a Keychain authentication

### Installed applications:

    1. adobe-acrobat-reader
    2. drawio
    3. enpass
    4. firefox
    5. flux
    6. google-drive
    7. iterm2
    8. microsoft-office
    9. microsoft-teams
    10. snip
    11. vagrant
    12. virtualbox
    13. vlc
    14. visual-studio-code
    15. google-chrome
    16. nomad