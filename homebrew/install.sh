#!/bin/sh

if test "$(uname)" = "Darwin"
then
  if test ! $(which brew 2> /dev/null)
  then
    mkdir $HOME/.brew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $HOME/.brew
  fi

  echo "› brew bundle"
  brew update
  brew bundle --file=$DOTFILES/homebrew/Brewfile
  brew bundle check --file=$DOTFILES/homebrew/Brewfile
fi
