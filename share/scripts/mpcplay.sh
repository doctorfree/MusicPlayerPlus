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
#    beet play playlist:1970s
#    beet play --args --shuffle playlist:1990s
#    beet play --args "--debug --shuffle" green

MPD_CONF="${HOME}/.config/mpd/mpd.conf"

debug=
shuffle=

# Get the MPD playlist directory
# playlist_dir=`grep ^playlist_directory ${MPD_CONF}`
# playlist_dir=`echo ${playlist_dir} | awk ' { print $2 } ' | sed -e "s/\"//g"`
# [ "${playlist_dir}" ] || playlist_dir="${HOME}/Music/Playlists"
# Need to expand the tilda to $HOME
# playlist_dir="${playlist_dir/#\~/$HOME}"

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
      # if [ -f "${playlist_dir}/${arg}.m3u" ]
      # then
      #   mpc --quiet load "$arg"
      # else
      #   if [ -f "${playlist_dir}/${arg}" ]
      #   then
      #     name="${arg%.*}"
      #     mpc --quiet load "$name"
      #   else
      #     mpc --quiet add "$arg"
      #   fi
      # fi
      mpc --quiet add "$arg"
    fi
  fi
done

[ "${debug}" ] && echo "mpcplay.sh $*"
[ "${shuffle}" ] && mpc --quiet shuffle

mpc --quiet play
