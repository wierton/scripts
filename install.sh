#!/bin/bash
# set -v on

username=$(logname)
homedir=$(eval echo "~$username")
passwd=123456
script_dir=$(cd `dirname $0` && pwd)

cd ${homedir}

# essential: git tmux(tmux.conf) vim(vimrc)

# some backups
# ============
# ${homedir}/.config/indicator-stickynotes
# ${homedir}/.config/shadowsocks-qt5/*
# ${homedir}/.ssh/*  (public key and private key)

check_basic_config() {
  read -e -p "Enter your name: " -i ${username} username
  read -e -s -p "Enter your password: " passwd  && echo
  read -e -p "Enter your home directory: " -i ${homedir} homedir
  read -e -p "Check the script directory: " -i ${script_dir} script_dir
}

insert_to_file() {
  # 1: string, 2: file
  if ! grep -F "$1" "$2"; then
	echo "$1" >> "$2";
  fi
}

use_tsinghua_source() {
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
}

install_texlive() {
  # install tex
  # ===========
  # install synaptic
  # search for `texlive-full` `texlive` and `lyx` and then install all suggested packages
  # texmaker IDE in ubuntu
  sudo apt-get install -y texlive-full texlive texstudio
}

install_ubuntu_unity_desktop() {
  sudo apt-get install -y ubuntu-unity-desktop
  dpkg-reconfigure lightdm
}

install_indicator_stickynotes() {
  sudo apt-get install -y indicator-stickynotes
}

install_media_codecs() {
  sudo apt-get install -y ubuntu-restricted-extras
}

quick_env() {
  # git configure
  sudo -S -u ${username} sh -c '
  git config --global user.name ouxianfei
  git config --global user.email ouxianfei@smail.nju.edu.cn
  git config --global core.editor vim
  git config --global color.ui true
  git config --global push.default simple
  '

  # zsh-vim-mode
  # sudo -S -u ${username} cp ${script_dir}/zsh-vim-mode.plugin.zsh ${homedir}/.zsh-vim-mode.plugin.zsh
  # insert_to_file "source ${homedir}/.zsh-vim-mode.plugin.zsh" ${homedir}/.zshrc

  # wtrc
  cp ${script_dir}/wtrc ${homedir}/.wtrc

  # oh-my-zsh
  sudo -S -u ${username} sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - 2>/dev/null)"
  if sudo -S -u ${username} chsh -s $(which zsh); then
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="wierton"/g' ${homedir}/.zshrc

    # environment
    insert_to_file "source ${homedir}/.wtrc" ${homedir}/.zshrc
    insert_to_file "source ${homedir}/.wtrc" ${homedir}/.bashrc

    # oh-my-zsh config
    sudo -S -u ${username} cp ${script_dir}/wierton.zsh-theme ${homedir}/.oh-my-zsh/themes
  fi

  insert_to_file "unsetopt BG_NICE" ${homedir}/.zshrc
  insert_to_file "unsetopt BG_NICE" ${homedir}/.bashrc

  # autojump for zsh
  sudo apt-get install -y autojump
  insert_to_file ". /usr/share/autojump/autojump.zsh" ${homedir}/.zshrc
  insert_to_file ". /usr/share/autojump/autojump.bash" ${homedir}/.bashrc

  cp ${script_dir}/clang-format ${homedir}/.clang-format

  # numlock
  sudo apt-get install -y numlockx
  insert_to_file "numlockx on" /etc/profile

  # vimrc
  cp ${script_dir}/vimrc  ${homedir}/.vimrc
  mkdir -p ${homedir}/.vim && cp -r ${script_dir}/_vim/* ${homedir}/.vim
  # in vim: vim %.vba.gz : so % :q

  # tmux-recover
  cp ${script_dir}/tmux.conf ${homedir}/.tmux.conf
  if [ ! -d ${homedir}/.tmux/tmux-resurrect ]; then
	sudo -S -u ${username} sh -c "(mkdir -p ${homedir}/.tmux &&
	  cd ${homedir}/.tmux &&
	  git clone https://github.com/tmux-plugins/tmux-resurrect.git)"
  fi

  # proxychains4
  sudo apt-get install -y proxychains4
  sed -i 's/socks4  127.0.0.1 9050/socks5  127.0.0.1 1080/g' /etc/proxychains4.conf
  # sudo proxychains4 wget www.google.com
}

install_cli() {
  # sbt source
  echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823

  sudo apt-get update
  
  sudo apt-get install -y verilator libboost-all-dev \
    libllvm6.0 libclang-6.0-dev libreadline-dev \
    libllvm10 libclang-10-dev \
    flex bison valgrind curl httpie cppman \
    tmux git zsh vim unzip unrar moreutils cmake \
    scala python3-pip qemu sbt

  sudo apt-get install -y binutils-mips-linux-gnu \
    cpp-mips-linux-gnu g++-mips-linux-gnu \
    gcc-mips-linux-gnu

  sudo apt-get install -y libsdl1.2-dev libsdl2-dev \
    libgtk2.0-dev libgtk-3-dev

  sudo pip3 install numpy scipy tensorflow

  # conflict with cross toolchain
  # sudo apt-get install -y gcc-8-multilib g++-8-multilib

  quick_env
}

install_gui() {
  install_cli

  sudo apt-get install docker.io docker-compose \
    texlive-full texlive texstudio \
    ubuntu-unity-desktop indicator-stickynotes \
    proxychains4 mplayer ubuntu-restricted-extras \
    xsel

  deb='google-chrome-stable_current_amd64.deb'
  wget 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb' -O $deb
  dpkg -i $deb
}

check_basic_config
# install_cli
install_gui
# quick_env
