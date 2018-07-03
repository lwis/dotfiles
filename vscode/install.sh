#!/bin/sh

if test "$(which code)"; then
  if [ "$(uname -s)" = "Darwin" ]; then
    VSCODE_HOME="$HOME/Library/Application Support/Code"
  else
    VSCODE_HOME="$HOME/.config/Code"
  fi

  modules="
    aaron-bond.better-comments
    bungcip.better-toml
    carolynvs.dep
    eg2.tslint
    HookyQR.beautify
    ms-python.python
    ms-vscode.cpptools
    ms-vscode.Go
    PeterJausovec.vscode-docker
    PKief.material-icon-theme
    redhat.java
    rokoroku.vscode-theme-darcula
    sidneys1.gitconfig
  "
  for module in $modules; do
    code --install-extension "$module" || true
  done
fi