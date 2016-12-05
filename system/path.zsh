function add_to_path()
{
    if [[ -d $1 && ! $PATH =~ ":$1" ]]; then
        export PATH="$1:$PATH"
    fi
}

function add_to_manpath()
{
    if [[ -d $1 && ! $MANPATH =~ ":$1" ]]; then
        export PATH="$1:$MANPATH"
    fi
}

add_to_path /sbin
add_to_path /usr/sbin
add_to_path $HOME/.brew/sbin
add_to_path $HOME/.brew/bin
add_to_path /usr/local/sbin
add_to_path /usr/local/bin

export BREW_ROOT=`brew --prefix`

add_to_manpath /usr/local/git/man
add_to_manpath /usr/local/mysql/man
add_to_manpath /usr/local/man

export MANPATH="/usr/local/man:/usr/local/mysql/man:/usr/local/git/man:$MANPATH"

if [ -d $BREW_ROOT/opt/coreutils/libexec/gnubin ]
then
    export PATH="$BREW_ROOT/opt/coreutils/libexec/gnubin:$PATH"
fi

export PATH="./bin:$DOTFILES/bin:$PATH"
