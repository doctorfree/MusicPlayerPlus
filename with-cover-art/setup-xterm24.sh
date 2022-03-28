#!/bin/bash
#
# See https://pisquare.osisoft.com/s/Blog-Detail/a8r1I000000GvXBQA0/console-things-getting-24bit-color-working-in-terminals
#
# If xterm-24bit terminal type has been set,
# configure tmux for 24 bit color support by
# adding these two lines to your tmux.conf
# or by invoking tmux with these as command args:
#
# set -g default-terminal "xterm-24bit"
# set -g terminal-overrides ',xterm-24bit:Tc'

tic -x -o ~/.terminfo xterm-24bit.src

export TERM=xterm-24bit

showcolors24
