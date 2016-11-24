#!/bin/sh

ZSH_LOCATION=`which zsh`

if test ! $(grep "$ZSH_LOCATION" /etc/shells 2> /dev/null)
then
    sudo sh -c "echo $ZSH_LOCATION >> /etc/shells"
    chsh -u `whoami` -s $ZSH_LOCATION
fi
