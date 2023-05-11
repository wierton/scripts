#!/usr/bin/env zsh

export PATH=$PATH:$HOME/.local/bin

# .oh-my-zsh/themes/wierton.zsh-theme
# local ret_status="%(?:%{$fg_bold[green]%}->:%{$fg_bold[red]%}->)"
# PROMPT='${ret_status} %{$fg[cyan]%}%c%{$fg[red]%} $%{$reset_color%} '

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(git)

# Theme
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="wierton"
source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

AUTOJUMP_ZSH=/usr/share/autojump/autojump.zsh
if [ -f $AUTOJUMP_ZSH ]; then
  . $AUTOJUMP_ZSH
fi

unsetopt BG_NICE # don't nice background jobs
unset LD_PRELOAD # forbid preload settings

# adjust the zsh history limit
# export HISTFILE="$HOME/.history"
export HISTSIZE=99999999
export SAVEHIST=$HISTSIZE # won't work without this env var

alias cls='clear && echo -en "\e[3J"'

function clear_proxy() {
  unset all_proxy ftp_proxy http_proxy https_proxy no_proxy
  unset ALL_PROXY FTP_PROXY HTTP_PROXY HTTPS_PROXY NO_PROXY
}

function sedr() {
  sed -i "s/$1/$2/g" `grep -rl -- "$1"`
}

function renamer() {
  find . -name "*$1*" -print0 | rename -0 "s/$1/$2/g"
}

function banio() {
  nohup $* </dev/null 1>/dev/null 2>&1 &
}

# eval $(thefuck --alias)

# psmouse
alias sudo-perm="sudo sh -c exit"
alias open-psmouse="sudo-perm && sudo modprobe -i psmouse"
alias close-psmouse="sudo-perm && sudo modprobe -r psmouse"

if [ -f .envrc ]; then
  source .envrc;
fi
