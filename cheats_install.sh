#!/bin/bash

if [ `id -u` -eq 0 ]
then
        echo "Running as sudo user :)"
else
        echo "Please run with sudo!"
        exit 1
fi

## Installing GoLang
sudo apt install golang -y

## Adding Go Reqs to ~.zshrc
cat >> /root/.zshrc <<EOL
export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
EOL

## Reload .zshrc
source /root/.zshrc

## Installing cheat
wget https://github.com/cheat/cheat/releases/download/4.2.3/cheat-linux-amd64.gz

## Gunzipping cheat
gunzip cheat-linux-amd64.gz

## Setting execute perms for cheat
chmod +x cheat-linux-amd64

## Place cheat binary in PATH
mv cheat-linux-amd64 /usr/local/bin/cheat

## Initialize cheat config file
cheat --init > ~/.config/cheat/conf.yml

##Setting up cheat config and cheatsheets
mkdir -p /root/.config/cheat/cheatsheets
mkdir -p /root/.config/cheat/cheatsheets/personal
touch /root/.config/cheat/conf.yml
cat > /root/.config/cheat/conf.yml <<EOL
---
# The editor to use with 'cheat -e <sheet>'. Defaults to $EDITOR or $VISUAL.
editor: vim
# Should 'cheat' always colorize output?
colorize: true
# Which 'chroma' colorscheme should be applied to the output?
# Options are available here:
#   https://github.com/alecthomas/chroma/tree/master/styles
style: monokai
# Which 'chroma' "formatter" should be applied?
# One of: "terminal", "terminal256", "terminal16m"
formatter: terminal16m
# Through which pager should output be piped? (Unset this key for no pager.)
pager: less -FRX
# The paths at which cheatsheets are available. Tags associated with a cheatpath
# are automatically attached to all cheatsheets residing on that path.
#
# Whenever cheatsheets share the same title (like 'tar'), the most local
# cheatsheets (those which come later in this file) take precedent over the
# less local sheets. This allows you to create your own "overides" for
# "upstream" cheatsheets.
#
# But what if you want to view the "upstream" cheatsheets instead of your own?
# Cheatsheets may be filtered via 'cheat -t <tag>' in combination with other
# commands. So, if you want to view the 'tar' cheatsheet that is tagged as
# 'community' rather than your own, you can use: cheat tar -t community
cheatpaths:
  # Paths that come earlier are considered to be the most "global", and will
  # thus be overridden by more local cheatsheets. That being the case, you
  # should probably list community cheatsheets first.
  #
  # Note that the paths and tags listed below are placeholders. You may freely
  # change them to suit your needs.
  #
  # Community cheatsheets must be installed separately, though you may have
  # downloaded them automatically when installing 'cheat'. If not, you may
  # download them here:
  #
  # https://github.com/cheat/cheatsheets
  #
  # Once downloaded, ensure that 'path' below points to the location at which
  # you downloaded the community cheatsheets.
  # Obtained from https://github.com/cheat/cheatsheets
  - name: community
    path: /root/.config/cheat/cheatsheets/community
    tags: [ community ]
    readonly: true
  # Security cheatsheets obtained from https://github.com/andrewjkerr/security-cheatsheets
  - name: security-cheatsheets
    path: /root/.config/cheat/cheatsheets/security-cheatsheets
    tags: [ security ]
    readonly: true
  # If you have personalized cheatsheets, list them last. They will take
  # precedence over the more global cheatsheets.
  - name: personal
    path: /root/.config/cheat/cheatsheets/personal
    tags: [ personal ]
    readonly: false
  # While it requires no configuration here, it's also worth noting that
  # 'cheat' will automatically append directories named '.cheat' within the
  # current working directory to the 'cheatpath'. This can be very useful if
  # you'd like to closely associate cheatsheets with, for example, a directory
  # containing source code.
  #
  # Such "directory-scoped" cheatsheets will be treated as the most "local"
  # cheatsheets, and will override less "local" cheatsheets. Likewise,
  # directory-scoped cheatsheets will always be editable ('readonly: false').
EOL
    

## Create directory for cheatsheets script installation (used to manage cheatsheets)
mkdir -p /root/.local/bin

## Install cheatsheets
wget -O /root/.local/bin/cheatsheets https://raw.githubusercontent.com/cheat/cheat/master/scripts/git/cheatsheets

## Make cheatsheets executable
chmod +x /root/.local/bin/cheatsheets

## Make cheatsheet accessible to all users in PATH
cp /root/.local/bin/cheatsheets /usr/local/bin/cheatsheets

## Download community cheatsheet
git clone https://github.com/cheat/cheatsheets.git /root/.config/cheat/cheatsheets/community

## Download security-cheatsheet from repo
git clone https://github.com/andrewjkerr/security-cheatsheets.git /root/.config/cheat/cheatsheets/security-cheatsheets

## Pulling latest updates to all cheatsheets (community, personal, and security)
cheatsheets pull

## Run cheat for first time after setup
cheat
