if test "$(uname)" = "Darwin"
then
  # Install homebrew
  if test ! $(which brew)
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  # Upgrade homebrew
  echo "› brew update"
  brew update

  # Run Homebrew through the Brewfile
  echo "› brew bundle"
  brew bundle check --file=$ZSH/Brewfile
  brew bundle --file=$ZSH/Brewfile
elif test "$(uname)" = "Linux"
then
  if test ! $(which brew)
  then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/linuxbrew/go/install)"
  fi

  #put brew on the path... in path.zsh?
fi
