#!/bin/bash
NO_TEX=0

while [ $# -gt 0 ]; do
    case $1 in 
        -nc|--no-code)
            echo "No code";;
        --no-tex)
            NO_TEX=1
    esac
    shift
done

if [ $NO_TEX -eq 1 ]
then
    echo "no tex"
else 
    echo "tex"
fi