#!/bin/bash
set -v on

username=wierton
homedir=/home/${username}

cd ${homedir}

# essential: git tmux(tmux.conf) vim(vimrc)

# some backups
# ============
# ${homedir}/.config/indicator-stickynotes
# ${homedir}/.config/shadowsocks-qt5/*
# ${homedir}/.ssh/*  (public key and private key)

(cd /etc/apt/; cp sources.list sources.list.bak;
echo '# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-security main restricted universe multiverse

# 预发布软件源，不建议启用
# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ bionic-proposed main restricted universe multiverse
' > sources.list
)


# sbt
echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
apt-get update upgrade

# sbt
apt-get install -y sbt

# verilator
apt-get install -y verilator

# boost
apt-get install -y libboost-all-dev

# llvm and clang
apt-get install -y libllvm6.0
apt-get install -y libclang-6.0

# readline flex bison
apt-get install -y libreadline-dev flex bison

# debugging tools
apt-get install -y valgrind

# curl and httpie
apt-get install -y curl httpie

# gcc-8
apt-get install -y gcc-8 g++-8
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 50
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 50

# multilib
apt-get install -y gcc-8-multilib
apt-get install -y g++-8-multilib

# clang-6.0
apt-get install -y clang-6.0
update-alternatives --install /usr/bin/clang clang /usr/bin/clang-6.0 50

# zsh vim vim-gnome unzip git
apt-get install -y tmux git zsh vim vim-gnome unzip unrar

# git configure
sudo -S -u ${username} sh -c '
git config --global user.name 141242068-ouxianfei
git config --global user.email 141242068@smail.nju.edu.cn
git config --global core.editor vim
git config --global color.ui true
git config --global push.default simple
'

# oh-my-zsh
sudo -S -u ${username} sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
sudo -S -u ${username} chsh -s $(which zsh)
sed -i "s/ZSH_THEME/# \0/g" ${homedir}/.zshrc

# environment
echo "source ${homedir}/.wtrc" >> ${homedir}/.zshrc
echo "source ${homedir}/.wtrc" >> ${homedir}/.bashrc

# oh-my-zsh config
sudo -S -u ${username} cp wierton.zsh-theme ${homedir}/.oh-my-zsh/themes

# autojump
apt-get install -y autojump
echo ". /usr/share/autojump/autojump.zsh" >> ${homedir}/.zshrc
echo ". /usr/share/autojump/autojump.bash" >> ${homedir}/.bashrc

# numlock
apt-get install -y numlockx
if ! grep "numlockx on" /etc/profile; then
	echo "numlockx on" >> /etc/profile
fi

# cppman
apt-get install -y cppman

# vimrc
cp ./vimrc  ${homedir}/.vimrc

# tmux
cp ./tmux.conf ${homedir}/.tmux.conf
sudo -S -u ${username} sh -c '(mkdir ${homedir}/.tmux &&
	cd ${homedir}/.tmux &&
	git clone https://github.com/tmux-plugins/tmux-resurrect.git)'


# libsdl
apt-get install -y libsdl1.2-dev libsdl2-dev
apt-get install -y libgtk2.0-dev
apt-get install -y libgtk-3-dev

apt-get install -y lib32readline-dev
apt-get install -y libsdl-1.2debian:i386

# cmake-3.10
apt-get install -y cmake

# cross chain
apt-get install -y binutils-mips-linux-gnu
apt-get install -y cpp-mips-linux-gnu
apt-get install -y g++-mips-linux-gnu
apt-get install -y gcc-mips-linux-gnu
# apt-get install -y gcc-mips-linux-gnu-base

# scala rust
apt-get install -y scala
curl -sSf https://static.rust-lang.org/rustup.sh | sh
mkdir -p ${homedir}/.vim/{ftdetect,indent,syntax} &&
	for d in ftdetect indent syntax ; do
		wget -O ${homedir}/.vim/$d/scala.vim https://raw.githubusercontent.com/derekwyatt/vim-scala/master/$d/scala.vim;
	done

# python libraries
apt-get install -y python-pip python3-pip python-virtualenv
update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10
update-alternatives --install /usr/bin/pip pip /usr/bin/pip2 20
pip2 install yd

# qemu emulator
apt-get install -y qemu

# autoremove
apt-get autoremove
