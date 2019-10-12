#!/bin/bash

# Static Params
DEPENDENCIES="build-essential cmake"
YCM_PARAMS="--clang-completer"

# Create directory
DIR="$HOME/.vim/bundle"
mkdir -p $DIR
cd $DIR

# Install Vundle Plugins
GIT_PARAMS="--branch master --depth 1"
git clone $GIT_PARAMS https://github.com/VundleVim/Vundle.vim.git $DIR/Vundle.vim
git clone $GIT_PARAMS https://github.com/ycm-core/YouCompleteMe $DIR/YouCompleteMe
(cd $DIR/YouCompleteMe;git submodule update --init --recursive)
vim +PluginUpdate +qall||exit

# Compile YouCompleteMe
if [ -z "$PREFIX" ];then # Termux
    sudo apt install -y python3 python3-dev gcc $DEPENDENCIES ||exit
else
    apt install -y python vim-python clang $DEPENDENCIES ||exit
fi
python3 YouCompleteMe/install.py $YCM_PARAMS

# Create .ycm_extra_conf.py
cat > $HOME/.ycm_extra_conf.py << HERE
def Settings( **kwargs ):
  return {
    'flags': [ '-Wall', '-Wextra', '-Werror' ],
  }
HERE
