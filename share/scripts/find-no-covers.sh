#!/bin/bash

MPD_CONF="${HOME}/.config/mpd/mpd.conf"

mpd_music=`grep ^music_directory ${MPD_CONF}`
mpd_music=`echo ${mpd_music} | awk ' { print $2 } ' | sed -e "s/\"//g"`
[ "${mpd_music}" ] || mpd_music="${HOME}/Music"
# Need to expand the tilda to $HOME
mpd_music="${mpd_music/#\~/$HOME}"

find ${mpd_music} -mindepth 2 -maxdepth 2 -type d '!' -exec sh -c 'ls -1 "{}" \
  | egrep -i -q "^cover\.(jpg|png)$"' ';' -print

exit 0
