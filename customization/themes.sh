#! /bin/bash
## Installiert themes 

for folder in fonts icons themes
do 
    cp -r customization/$folder ~/.local/share/$folder
done