#!/bin/bash

cd ~/.config
find . -name "sogou*" -or -name "Sogou*" | xargs rm -rf
