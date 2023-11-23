#!/bin/bash
function set_extension_settings {
    for EXT in extensions/*.sh 
    do 
        ./$EXT
    done
}

set_extension_settings
exit 0
set_extension_settings