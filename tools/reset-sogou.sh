#!/bin/bash

cd ~/.config
find . -name "sogou*" -or -name "Sogou*" | xargs rm -rf
sogou-diag
# nohup sogou-qimpanel /dev/null &>/dev/null &
fcitx -r
