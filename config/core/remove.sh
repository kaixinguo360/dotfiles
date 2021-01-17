#!/bin/bash

cd $(dirname $(realpath $0))

# Remove Soft Link
files='.bashrc .profile'
for file in ${files[@]}
do
    rm -f $HOME/$file
done

