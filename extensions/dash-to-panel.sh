#!/bin/bash
path=/org/gnome/shell/extensions/dash-to-panel

dconf write $path/animate-appicon-hover true
dconf write $path/animate-appicon-hover-animation-extent "{'RIPPLE': 4, 'PLANK': 4, 'SIMPLE': 1}"
dconf write $path/appicon-margin 0
dconf write $path/appicon-padding 4
dconf write $path/dot-position "'LEFT'"
dconf write $path/dot-style-focused "'DASHES'"
dconf write $path/dot-style-unfocused "'DOTS'"
dconf write $path/hotkeys-overlay-combo "'TEMPORARILY'"
dconf write $path/intellihide true
dconf write $path/intellihide-behaviour "'ALL_WINDOWS'"
dconf write $path/intellihide-hide-from-windows true
dconf write $path/intellihide-only-secondary false
dconf write $path/intellihide-show-in-fullscreen false
dconf write $path/intellihide-use-pressure true
dconf write $path/leftbox-padding -1
dconf write $path/panel-anchors "'{"0":"MIDDLE"}'"

echo "dash-to-panel configured"