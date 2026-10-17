#!/bin/sh

remove_gcc() {
  sudo update-alternatives --remove-all gcc
  sudo update-alternatives --remove-all g++
}

alter_gcc() {
  sudo update-alternatives --alter /usr/bin/g++ g++ /usr/bin/g++-$1 $2
  sudo update-alternatives --alter /usr/bin/gcc gcc /usr/bin/gcc-$1 $2
}

alter() {
  alter_gcc 4.4 44
  alter_gcc 4.7 47
  alter_gcc 4.8 48
  alter_gcc 5 50
  alter_gcc 6 60
  alter_gcc 7 70
  alter_gcc 8 80
}

install() {
  sudo apt-get install gcc-$1 g++-$1
}

alter
# install 4.6 7.2
