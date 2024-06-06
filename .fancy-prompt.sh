# Hypercube's fancy prompt
# https://github.com/SmartHypercube/fancy-prompt

case "$TERM" in
    *-color|*-256color) fancy_prompt=yes;;
esac

if [ "$fancy_prompt" = yes ]; then

    # in some cases, $USER and $HOSTNAME are not set, so we use "whoami" and "hostname" instead
    USER=${USER:-$(whoami)}
    HOSTNAME=${HOSTNAME:-$(hostname)}

    # calculate user's color with sha256
    _hypercube_ps1_user_color=$((0x$(echo -n "user-${USER}" | sha256sum | head -c 6)))
    # format: "%d;%d;%d"
    _hypercube_ps1_user_color=$((_hypercube_ps1_user_color/65536%128+32))';'$((_hypercube_ps1_user_color/256%128+32))';'$((_hypercube_ps1_user_color%128+32))

    # calculate hostname's color with sha256
    _hypercube_ps1_hostname_color=$((0x$(echo -n "hostname-${HOSTNAME}" | sha256sum | head -c 6)))
    # format: "%d;%d;%d"
    _hypercube_ps1_hostname_color=$((_hypercube_ps1_hostname_color/65536%128+32))';'$((_hypercube_ps1_hostname_color/256%128+32))';'$((_hypercube_ps1_hostname_color%128+32))

    # ┌─ hypercube@debian:                <- printed by $PROMPT_COMMAND. it also updates window title.
    # $ echo \                            <- $PS1
    # > -n \                              <- $PS2
    # > foo                               <- $PS2
    # ├─[2024-06-06 12:34:56]             <- $PS0. it also updates window title and sets $_hypercube_ps0_start.
    # foo╳                                <- the mark is printed by $PROMPT_COMMAND.
    # └─[0]──[0s]──[2024-06-06 12:34:56]  <- printed by $PROMPT_COMMAND. it also reads $_hypercube_ps0_start and unsets it.

    # this function will be set as PROMPT_COMMAND and be called before printing PS1
    function _hypercube_ps1_c {
        # use $? to get exit code, must be the first line in this function
        local retcode=$?
        # if a command just finished, print the last line
        if [ -v _hypercube_ps0_start ]; then
            # use $SECONDS (current time) and $_hypercube_ps0_start (command start time) to get duration
            local duration=$((SECONDS-_hypercube_ps0_start))
            # formats: "%ds" / "%dm%ds" / "%dh%dm%ds" / "%dd%dh%dm%ds"
            local ds
            if ((duration<60)); then
                # format: "%ds"
                ds="${duration}s"
            elif ((duration<3600)); then
                ds="$((duration/60))m$((duration%60))s"
            elif ((duration<86400)); then
                ds="$((duration/3600))h$((duration%3600/60))m$((duration%60))s"
            else
                ds="$((duration/86400))d$((duration%86400/3600))h$((duration%3600/60))m$((duration%60))s"
            fi
            # if duration is longer than 30 seconds, add an exclamation mark and ring the bell by printing "\a"
            if ((duration>30)); then
                ds="$ds!\a"
            fi
            # "\e[7m╳\e[m": a mark with inverted color
            # "%*s\r": print $COLUMNS - 1 spaces, then set the cursor back to first column.
            #          if output doesn't end at first column, cursor will be at first column of next line.
            #          if output ends at first column, cursor will be at the mark. the mark will be overwritten later.
            # "\e[37m└─\e[m": darker white foreground color
            # "[\e[1;$((retcode?31:32))m$retcode\e[m]": return code, bold, red or green, in brackets
            # "\e[37m──\e[m": darker white foreground color
            # "[\e[1;35m$ds\e[m]": duration, bold, magenta, in brackets
            # "\e[37m──\e[m": darker white foreground color
            # "[\e[36m%(%Y-%m-%d %H:%M:%S)T\e[m]": command end time, cyan, in brackets
            printf "\e[7m╳\e[m%*s\r\e[37m└─\e[m[\e[1;$((retcode?31:32))m$retcode\e[m]\e[37m──\e[m[\e[1;35m$ds\e[m]\e[37m──\e[m[\e[36m%(%Y-%m-%d %H:%M:%S)T\e[m]\n" $((COLUMNS-1))
        fi

        # print the first line
        # format $PWD in SSH style (remove the $HOME part and trailing slash)
        local dir=$PWD/
        dir=${dir#"$HOME/"}
        dir=${dir%/}
        # "\e]0;%s:%s\a": set "$HOSTNAME:$dir" as window title
        # "\e[37m┌─\e[m": darker white foreground color
        # " "
        # "%s": print $debian_chroot in parentheses if it's set
        # "\e[1;48;2;%sm%s\e[m": user name, bold, with $_hypercube_ps1_user_color (r;g;b) background
        # "@"
        # "\e[1;48;2;%sm%s\e[m": hostname, bold, with $_hypercube_ps1_hostname_color (r;g;b) background
        # ":"
        # "\e[1;34m%s\e[m": current directory, bold, blue
        printf "\e]0;%s:%s\a\e[37m┌─\e[m %s\e[1;48;2;%sm%s\e[m@\e[1;48;2;%sm%s\e[m:\e[1;34m%s\e[m\n" "$HOSTNAME" "$dir" "${debian_chroot:+($debian_chroot)}" "$_hypercube_ps1_user_color" "$USER" "$_hypercube_ps1_hostname_color" "$HOSTNAME" "$dir"

        # if $_hypercube_ps0_start is set, it means a command is running or just finished
        unset _hypercube_ps0_start
    }

    # will be called before printing PS1
    PROMPT_COMMAND=_hypercube_ps1_c
    # primary prompt string, only a dollar sign in bold
    # non-printing characters in PS1 and PS2 must be surrounded by "\[" and "\]" for line wrapping to work correctly
    PS1='\[\e[1m\]\$\[\e[m\] '
    # secondary prompt string
    PS2='> '

    # print the middle line
    # "\e]0;$(_hypercube_ps0_history=$(history 1); printf "%s" "${HOSTNAME}: ${_hypercube_ps0_history#*[0-9]  }")\a":
    #     drop number from output of "history 1" and set it as window title
    # "\e[$((_hypercube_ps0_start=SECONDS,37))m├─\e[m":
    #     darker white foreground color
    #     also set $_hypercube_ps0_start to $SECONDS (current time)
    # "[\e[36m\D{%Y-%m-%d %H:%M:%S}\e[m]": command start time, cyan, in brackets
    PS0='\e]0;$(_hypercube_ps0_history=$(history 1); printf "%s" "${HOSTNAME}: ${_hypercube_ps0_history#*[0-9]  }")\a\e[$((_hypercube_ps0_start=SECONDS,37))m├─\e[m[\e[36m\D{%Y-%m-%d %H:%M:%S}\e[m]\n'

else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset fancy_prompt
