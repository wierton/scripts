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
	if [ "$args" == "video" ];then
		apt-get install libsdl1.2-dev
	fi
done
