# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=1000000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Hypercube's fancy prompt
# + show user, hostname, pwd in ssh format
# + use color
# + use colors generated by hashing for user and hostname
# + use seperate command line
# + set short window title
# + show start time and duration
# + ring bell after long running command
# + show exit code
# + append newline when needed
# - show jobs
# - show history number
# - save and load history list
# - show items in working directory
# - show git status
case "$TERM" in
    *-color|*-256color) fancy_prompt=yes;;
esac
if [ "$fancy_prompt" = yes ]; then
    _hypercube_ps1_user_color=$((0x$(echo -n "user-${USER}" | sha256sum | head -c 6)))
    _hypercube_ps1_user_color=$((_hypercube_ps1_user_color/65536%128+32))';'$((_hypercube_ps1_user_color/256%128+32))';'$((_hypercube_ps1_user_color%128+32))
    _hypercube_ps1_hostname_color=$((0x$(echo -n "hostname-${HOSTNAME}" | sha256sum | head -c 6)))
    _hypercube_ps1_hostname_color=$((_hypercube_ps1_hostname_color/65536%128+32))';'$((_hypercube_ps1_hostname_color/256%128+32))';'$((_hypercube_ps1_hostname_color%128+32))
    function _hypercube_ps1_c {
        local retcode=$?
        if [ -v _hypercube_ps0_start ]; then
            local duration=$((SECONDS-_hypercube_ps0_start))
            local ds
            if ((duration<60)); then
                ds="${duration}s"
            elif ((duration<3600)); then
                ds="$((duration/60))m$((duration%60))s"
            elif ((duration<86400)); then
                ds="$((duration/3600))h$((duration%3600/60))m$((duration%60))s"
            else
                ds="$((duration/86400))d$((duration%86400/3600))h$((duration%3600/60))m$((duration%60))s"
            fi
            if ((duration>30)); then
                ds="$ds!\a"
            fi
            printf "\e[7m╳\e[m%*s\r\e[37m└─\e[m[\e[1;$((retcode?31:32))m$retcode\e[m]\e[37m──\e[m[\e[1;35m$ds\e[m]\e[37m──\e[m[\e[36m%(%Y-%m-%d %H:%M:%S)T\e[m]\n" $((COLUMNS-1))
        fi
        local dir=$PWD/
        dir=${dir#"$HOME/"}
        dir=${dir%/}
        printf "\e]0;%s:%s\a\e[37m┌─\e[m %s\e[1;48;2;%sm%s\e[m@\e[1;48;2;%sm%s\e[m:\e[1;34m%s\e[m\n" "$HOSTNAME" "$dir" "${debian_chroot:+($debian_chroot)}" "$_hypercube_ps1_user_color" "$USER" "$_hypercube_ps1_hostname_color" "$HOSTNAME" "$dir"
        unset _hypercube_ps0_start
        _hypercube_ps1_ran=1
    }
    PROMPT_COMMAND=_hypercube_ps1_c
    PS1='\[\e[1m\]\$\[\e[m\] '
    PS2='> '
    PS0='\e]0;$(_hypercube_ps0_history=$(history 1); printf "%s" "${HOSTNAME}: ${_hypercube_ps0_history#*[0-9]  }")\a\e[$((_hypercube_ps0_start=SECONDS,37))m├─\e[m[\e[36m\D{%Y-%m-%d %H:%M:%S}\e[m]\n'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset fancy_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

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
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
