#!/bin/bash
. $(dirname $(realpath $0))/lib.sh

# Check Dependencies
[ -d "$HOME/.vim/bundle/Vundle.vim" ] && [ "$1" != "-f" ] && echo 'vundle installed' && exit 0
need git vim

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
if [ -n "$TERMUX" ];then
    need python vim-python clang $DEPENDENCIES ||exit
else
    need python3 python3-dev gcc $DEPENDENCIES ||exit
fi
python3 YouCompleteMe/install.py $YCM_PARAMS

# Create .ycm_extra_conf.py
cat > $HOME/.ycm_extra_conf.py << HERE
def Settings( **kwargs ):
  return {
    'flags': [ '-Wall', '-Wextra', '-Werror' ],
  }
HERE
