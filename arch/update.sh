#!/bin/sh
pacman -Qqet | grep -v "$(pacman -Qqg base)" | grep -v "$(pacman -Qqm)" > package_list.txt # community
pacman -Qqm > aur_package_list.txt # aur


# dconf dump /org/gnome/terminal/legacy/profiles:/
# dconf dump /org/gnome/terminal/legacy/profiles:/:<UUID> > gnome-terminal-profile.dconf
#
# dconf load /org/gnome/terminal/legacy/profiles:/:xx-xx-xx-xx/ < gnome-terminal-profile.dconf
