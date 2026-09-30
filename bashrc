bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
export PATH="$PATH:$HOME/.local/bin"
HISTSIZE=999999
HISTFILESIZE=999999

# Enable bash-completion if installed
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Tab: show/cycle completion candidates
bind 'set show-all-if-ambiguous on'
bind 'set menu-complete-display-prefix on'
bind '"\t": menu-complete'
