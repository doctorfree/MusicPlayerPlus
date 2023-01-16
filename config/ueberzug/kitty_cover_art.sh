#!/usr/bin/env bash

#-------------------------------#
# Display current cover         #
#-------------------------------#

COVER="/tmp/cover.png"
X_PADDING=27
Y_PADDING=0

function add_cover() {
    kitty +kitten icat --transfer-mode=stream --silent --align=left --z-index=-1 --place="300x300@$((COLUMNS - X_PADDING))x${Y_PADDING}" "$COVER"
}

function remove_cover() {
    kitty +kitten icat --transfer-mode=stream --silent --clear
}

function you_wait() {
    while inotifywait -q -q -e close_write "$COVER"; do
        remove_cover
        add_cover
    done
}

while :
do
    add_cover
    you_wait
done
