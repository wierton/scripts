#!/bin/bash

# git config --global credential.helper cache

if [ $# == 1 ];then
	apt-get install git vim tmux
	cat vimrc > /etc/vim/vimrc

	git config --global user.name 141242068-ouxianfei
	git config --global user.email 141242068@smail.nju.edu.cn
	git config --global core.editor vim
	git config --global color.ui true
	git config --global push.default simple
fi

for args in $*;do
	case "$args" in
		"video")
			apt-get install libsdl1.2-dev
			;;
		"tmux")
			cat ./.tmux.conf >> ~/.tmux.conf
			mkdir ~/.tmux
			cd ~/.tmux
			git clone https://github.com/tmux-plugins/tmux-resurrect.git
			#<C-b> <C-s>, <C-b> <C-r>
	esac
done
