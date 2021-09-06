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
    3. automake
    4. ansible
    5. boot2docker
    6. balenaetcher
    7. gettext
    8. git
    9. graphviz
    10. hub
    11. htop
    12. imagemagick
    13. jq
    14. libjpeg
    15. libmemcached 
    16. lynx
    17. markdown
    18. memcached
    19. npm
    20. pkg-config
    21. rename
    22. terminal-notifier
    23. tldr
    24. the_silver_searcher
    25. tmux
    26. tree
    27. vim
    28. socat # needed for ssh through proxy
    29. wget

### Installed applications:

    1. drawio
    2. enpass
    3. firefox
    4. flux
    5. google-drive
    6. iterm2
    7. macvim
    8. microsoft-office
    9. microsoft-teams
    10. snip
    11. vagrant
    12. virtualbox
    13. vlc
    14. visual-studio-code
    15. google-chrome
    16. nomad