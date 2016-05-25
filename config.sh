#!/bin/bash

apt-get install git vim tmux
cat vimrc >> /etc/vim/vimrc

git config user.name=141242068-ouxianfei
git config user.email=141242068@smail.nju.edu.cn
git config core.editor=vim
git config color.ui=true
git config push.default=simple
