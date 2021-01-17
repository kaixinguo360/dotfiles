#!/bin/bash

dir=$(dirname $(realpath $0))
cd $dir

# Create Soft Link
files='.bashrc .profile'
for file in ${files[@]}
do
    rm -f $HOME/$file
    ln -s $(realpath $dir/$file) $HOME
done

