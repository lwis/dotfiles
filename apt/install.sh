#!/bin/sh

if test "$(whence apt 2> /dev/null)"
then
    sudo apt install git bikeshed coreutils nano
fi
