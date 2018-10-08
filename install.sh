#!/bin/bash
# set -v on

username=ics2018
homedir=/home/${username}
passwd=
script_dir=`pwd`

cd ${homedir}

# essential: git tmux(tmux.conf) vim(vimrc)

# some backups
# ============
# ${homedir}/.config/indicator-stickynotes
# ${homedir}/.config/shadowsocks-qt5/*
# ${homedir}/.ssh/*  (public key and private key)

prepare_dup_stdout() {
  exec 3<&2
  # echo Hello World >&3
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

install_extra_cli_source() {
  # sbt
  echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
}

install_extra_gui_source() {
  add-apt-repository -y ppa:umang/indicator-stickynotes &&
  echo '
  deb http://ppa.launchpad.net/hzwhuang/ss-qt5/ubuntu xenial main
  deb-src http://ppa.launchpad.net/hzwhuang/ss-qt5/ubuntu xenial main
  ' >> /etc/apt/sources.list # shadowsocks-qt5
}

install_sbt() {
  apt-get install -y sbt
}

install_verilator() {
  apt-get install -y verilator
}

install_boost_libraries() {
  apt-get install -y libboost-all-dev
}

install_llvm_library() {
  apt-get install -y libllvm6.0
}

install_clang_library() {
  apt-get install -y libclang-6.0
}

install_readline_library() {
  apt-get install -y libreadline-dev lib32readline-dev
}

install_parser_tools() {
 apt-get install -y flex bison
}

install_useful_tool() {
  apt-get install -y valgrind curl httpie cppman
}

install_gcc_8() {
  apt-get install -y gcc-8 g++-8
  update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 50
  update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 50
}

install_gcc_multilib() {
  apt-get install -y gcc-8-multilib g++-8-multilib
}

install_clang_6() {
  apt-get install -y clang-6.0
  update-alternatives --install /usr/bin/clang clang /usr/bin/clang-6.0 50
}

install_develop_essential() {
  apt-get install -y tmux git zsh vim unzip unrar
  apt-get install -y vim-gnome
}

install_git_configure() {
  sudo -S -u ${username} sh -c '
  git config --global user.name 141242068-ouxianfei
  git config --global user.email 141242068@smail.nju.edu.cn
  git config --global core.editor vim
  git config --global color.ui true
  git config --global push.default simple
  '
}

install_oh_my_zsh_option=--no-redirect
install_oh_my_zsh() {
  # oh-my-zsh
  sudo -S -u ${username} sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O - 2>/dev/null)"
  if ! sudo -S -u ${username} chsh -s $(which zsh); then
	exit -1;
  fi
  sed -i "s/ZSH_THEME/# \0/g" ${homedir}/.zshrc

  # environment
  insert_to_file "source ${homedir}/.wtrc" ${homedir}/.zshrc
  insert_to_file "source ${homedir}/.wtrc" ${homedir}/.bashrc

  # oh-my-zsh config
  sudo -S -u ${username} cp ${script_dir}/wierton.zsh-theme ${homedir}/.oh-my-zsh/themes
}

post_install_oh_my_zsh() {
  insert_to_file "unsetopt BG_NICE" ${homedir}/.zshrc
  insert_to_file "unsetopt BG_NICE" ${homedir}/.bashrc
}

install_autojump() {
  apt-get install -y autojump
  insert_to_file ". /usr/share/autojump/autojump.zsh" ${homedir}/.zshrc
  insert_to_file ". /usr/share/autojump/autojump.bash" ${homedir}/.bashrc
}

install_numlockx() {
  # numlock
  apt-get install -y numlockx
  insert_to_file "numlockx on" /etc/profile
}

install_vimrc() {
  # vimrc
  cp ${script_dir}/vimrc  ${homedir}/.vimrc
}

install_wtrc() {
  # wtrc
  cp ${script_dir}/wtrc ${homedir}/.wtrc
}

install_tmux_conf_and_plugin() {
  # tmux
  cp ${script_dir}/tmux.conf ${homedir}/.tmux.conf
  if [ ! -d ${homedir}/.tmux/tmux-resurrect ]; then
	sudo -S -u ${username} sh -c "(mkdir -p ${homedir}/.tmux &&
	  cd ${homedir}/.tmux &&
	  git clone https://github.com/tmux-plugins/tmux-resurrect.git)"
  fi
}

install_cmake() {
  apt-get install -y cmake
}

install_gnu_mips_tool_chain() {
  # cross chain
  apt-get install -y binutils-mips-linux-gnu
  apt-get install -y cpp-mips-linux-gnu
  apt-get install -y g++-mips-linux-gnu
  apt-get install -y gcc-mips-linux-gnu
  # apt-get install -y gcc-mips-linux-gnu-base
}

install_scala() {
  apt-get install -y scala
}

install_rust() {
  if ! curl -sSf https://static.rust-lang.org/rustup.sh | sh; then
	exit -1;
  fi
  mkdir -p ${homedir}/.vim/{ftdetect,indent,syntax} &&
	for d in ftdetect indent syntax ; do
	  wget -O ${homedir}/.vim/$d/scala.vim https://raw.githubusercontent.com/derekwyatt/vim-scala/master/$d/scala.vim;
	done
}

install_cli_python() {
  # python libraries
  apt-get install -y python-pip python3-pip python-virtualenv
  update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 10
  update-alternatives --install /usr/bin/pip pip /usr/bin/pip2 20
  pip2 install yd
}

install_qemu() {
  # qemu emulator
  apt-get install -y qemu
}

install_sdl_library() {
  apt-get install -y libsdl1.2-dev libsdl2-dev
  apt-get install -y libgtk2.0-dev
  apt-get install -y libgtk-3-dev

  apt-get install -y libsdl1.2-dev:i386
  apt-get install -y libsdl2-dev:i386
}

install_python_libraries() {
  pip2 install numpy && pip3 install numpy
  pip2 install scipy && pip3 install scipy
  pip2 install tensorflow && pip3 install tensorflow
}

install_python_mysql() {
  apt-get -y install mysql-server
  apt-get -y install python-dev
  apt-get -y install python-mysqldb
}

install_docker() {
  apt-get install -y docker.io
  apt-get install -y docker-compose
}

install_texlive() {
  # install tex
  # ===========
  # install synaptic
  # search for `texlive-full` `texlive` and `lyx` and then install all suggested packages
  # texmaker IDE in ubuntu
  apt-get install -y texlive-full texlive texstudio
}

install_ubuntu_unity_desktop_option=--no-redirect
install_ubuntu_unity_desktop() {
  apt-get install -y ubuntu-unity-desktop
  dpkg-reconfigure lightdm
}

install_indicator_stickynotes() {
  apt-get install -y indicator-stickynotes
}

install_shadowsocks() {
  apt-get install -y shadowsocks-qt5
}

install_media_codecs() {
  apt-get install -y ubuntu-restricted-extras
}

run_install_instance() {(
  eval option=$(echo \${install_${i}_option})
  if [ "$option"s == "--no-redirect"s ]; then
	install_${i}
  else
	install_${i} &>> install.log
  fi
)}

install() {
  for i in $*; do
	printf "\e[34mINSTALLING ${i} ...\e[0m"
	if run_install_instance ${i}; then
	  echo -e "\e[32mSUCCESSFULLY!\e[0m"
	else
	  echo -e "\e[31mFAILED!\e[0m"
	fi
  done | tee -a install.log
}

install_cli() {
  use_tsinghua_source
  install_extra_cli_source

  apt-get update && apt-get upgrade

  install verilator boost_libraries llvm_library \
	clang_library readline_library parser_tools useful_tool \
	gcc_8 gcc_multilib clang_6 develop_essential \
	numlockx vimrc wtrc cli_python qemu \
	tmux_conf_and_plugin cmake gnu_mips_tool_chain \
	git_configure oh_my_zsh autojump scala rust sbt
}

install_gui() {
  install_extra_gui_source
  apt-get update && apt-get upgrade

  install sdl_library python_libraries python_mysql docker \
	texlive ubuntu_unity_desktop indicator_stickynotes \
	shadowsocks media_codecs
}

install_ics() {
  username=ics$(date +%Y)
  homedir=/home/$username
  
  install vimrc wtrc qemu tmux_conf_and_plugin \
	git_configure oh_my_zsh autojump
}

install_cli
# install_gui
# install_ics

# post_install_oh_my_zsh

# autoremove
apt-get autoremove
