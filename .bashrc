# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=2000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
export CLICOLOR=1
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls --color=auto --block-size=\'1"
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Prompt
if [[ "$debian_chroot" ]]; then
  PS1="$debian_chroot:"
else
  PS1=""
fi

if ! type -t tac &>/dev/null; then
  tac() {
    tail -r
  }
fi

PS1="$PS1\$(dirs -p | tac | tr '\n' ' ' | sed 's/ $//')"

case "$TERM" in
linux|xterm*|screen)
  PS1="$PS1\[\e[1;32m\]\$\[\e[0m\] "

   if [[ "$TERM" = xterm || "$TERM" = screen ]]; then
    PS1="\[\e]0;\h:\w\a\]$PS1"
  fi
  ;;
*)
  PS1="$PS1\$ "
  ;;
esac

export PS1

alias jobs='jobs -l'

# time(shell) a command 5 times and arrange the results horizontally.
#
# Example output:
# $ xtime sleep 1
#
# real 0m1.002s 0m1.002s 0m1.002s 0m1.002s 0m1.002s
# user 0m0.000s 0m0.000s 0m0.000s 0m0.000s 0m0.000s
# sys 0m0.000s 0m0.000s 0m0.000s 0m0.000s 0m0.000s
#
# Bug:
#   Doesn't handle shell builtins in $@.
xtime() {
    local joined new

    echo -e "\nreal\nuser\nsys\n" >time.joined

    for TRIAL in $(seq 1 5); do
        local trial_time

        # From http://mywiki.wooledge.org/BashFAQ/032
        exec 3>&1 4>&2
        { time "$@" 1>&3 2>&4; } 2>&1 | join -j 1 time.joined - >time.new
        exec 3>&- 4>&-

        mv time.new time.joined
    done

    cat time.joined
    rm -f time.joined
}

alias gbd='for k in `git branch -a|perl -pe s/^..//`;do echo -e `git show --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k|head -n 1`\\t$k;done|sort -r'
alias gs='git status'
alias grh='git reset --hard HEAD'
alias q='quilt'

export LESS="-IRSM"
export PAGER="less -XFRS"
export ACK_PAGER="$PAGER"

# git uses /usr/bin/editor by default, which in Ubuntu points to nano by
# default.
export EDITOR="vim"

export PATH="$PATH:$HOME/bin"

# Install working copies using:
# $ python setup.py develop --user
export PYTHONPATH="$HOME/src/w3lib:$HOME/src/queuelib"
[ -d $HOME/src/go ] && {
  export PATH="$HOME/bin:$PATH:$GOROOT/bin"
  export GOPATH="$HOME/src/gopath"
}

export SSHFS='-o auto_cache,intr,umask=0077,sshfs_debug'

[ -s $HOME/.bashrc_local ] && . $HOME/.bashrc_local

false && [ -d /usr/local/plan9 ] && {
  export PLAN9=/usr/local/plan9
  export PATH=$PATH:$PLAN9/bin
}
