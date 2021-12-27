# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

export PATH=$HOME/.local/bin:$PATH
export EDITOR=vim
export LANG=en_US.UTF-8
export LANGUAGE=en_US:en:C:zh_CN:zh
export LC_ADDRESS=zh_CN.UTF-8
export LC_COLLATE=zh_CN.UTF-8
export LC_CTYPE=zh_CN.UTF-8
export LC_IDENTIFICATION=zh_CN.UTF-8
export LC_MONETARY=zh_CN.UTF-8
export LC_MESSAGES=en_US.UTF-8
export LC_MEASUREMENT=zh_CN.UTF-8
export LC_NAME=zh_CN.UTF-8
export LC_NUMERIC=zh_CN.UTF-8
export LC_PAPER=zh_CN.UTF-8
export LC_TELEPHONE=zh_CN.UTF-8
export LC_TIME=en_DK.UTF-8
export TZ=Asia/Shanghai
