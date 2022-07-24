#!/bin/bash
#
# mpcplay.sh - accepts arguments from the 'beet play' command
#     processes arguments and invokes mpc to play song arguments
#
# This script is meant to be invoked from Beets as the 'command'
# used by the Beets 'play' plugin. See ~/.config/beets/config.yaml
#
# Examples:
#    beet play velvet
#    beet play --args --shuffle blue
#    beet play --args "--debug --shuffle" green

debug=
shuffle=

mpc --quiet clear

for arg in "$@"
do
  if [ "${arg}" == "-shuffle" ] || [ "${arg}" == "--shuffle" ]
  then
    shuffle=1
  else
    if [ "${arg}" == "-debug" ] || [ "${arg}" == "--debug" ]
    then
      debug=1
    else
      mpc --quiet add "$arg"
    fi
  fi
done

[ "${debug}" ] && echo "mpcplay.sh $*"
[ "${shuffle}" ] && mpc --quiet shuffle

mpc --quiet play
