#! /bin/bash
## Installiert themes 

for folder in fonts icons themes
do 
    dir=~/.local/share/$folder
    if [ ! -d $dir ]; then
        mkdir $dir
    fi
    cp -r customization/$folder/* $dir
done