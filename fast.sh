# vimrc
cat .vimrc > ~/.vimrc

# tmux
cat .tmux.conf >> ~/.tmux.conf

# git config
git config --global user.name wierton
git config --global user.email 141242068@smail.nju.edu.cn

# peda
git clone https://github.com/longld/peda.git ~/peda
echo "source ~/peda/peda.py" >> ~/.gdbinit
