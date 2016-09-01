source $ZPLUG_HOME/init.zsh

# #Load the theme.
zplug "lwis/zsh-theme", use:"theme.plugin.zsh"
#zplug "$PROJECTS/zsh-theme", from:local

#Load completions last.
zplug "zsh-users/zsh-autosuggestions", use:"zsh-autosuggestions.plugin.zsh", nice:10
zplug "zsh-users/zsh-syntax-highlighting", use:"zsh-syntax-highlighting.plugin.zsh", nice:10
# zplug "zsh-users/zsh-completions", use:"zsh-completions.zsh", nice:10

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
