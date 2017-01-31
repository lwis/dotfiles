#!/bin/sh

if test "$(whence apt 2> /dev/null)"
then
    sudo apt update
    sudo apt install git bikeshed coreutils nano build-essential
fi

if test "$(whence pacman 2> /dev/null)"
then
    sudo pacman -Syu
    sudo pacman -S zsh tmux python3 python git nano
fi
