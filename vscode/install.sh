#!/bin/sh

if test "$(which code)"; then
  if [ "$(uname -s)" = "Darwin" ]; then
    VSCODE_HOME="$HOME/Library/Application Support/Code"
  else
    VSCODE_HOME="$HOME/.config/Code"
  fi

  ln -sf "$DOTFILES/vscode/settings.json" "$VSCODE_HOME/User/settings.json"
  ln -sf "$DOTFILES/vscode/keybindings.json" "$VSCODE_HOME/User/keybindings.json"

  modules="
    aaron-bond.better-comments
    bungcip.better-toml
    carolynvs.dep
    eamodio.gitlens
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