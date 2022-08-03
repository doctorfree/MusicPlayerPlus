#!/bin/bash
#
# ab_albums.sh - call acousticbrainz plugin for each album in the library

MPD_CONF="${HOME}/.config/mpd/mpd.conf"

mpd_music=`grep ^music_directory ${MPD_CONF}`
mpd_music=`echo ${mpd_music} | awk ' { print $2 } ' | sed -e "s/\"//g"`
[ "${mpd_music}" ] || mpd_music="${HOME}/Music"
# Need to expand the tilda to $HOME
mpd_music="${mpd_music/#\~/$HOME}"

XLOG="$1"

# AcousticBrainz enforces an API rate limit of 10 per 10 seconds
# We exceed this and the plugin does not yet examine the return header
# to throttle itself. Sleeping for a second isn't going to avoid all
# rejections due to exceeding the rate limit. Hopefully fixed in 1.6.1

for album in "${mpd_music}"/*/*
do
  [ "${album}" == "${mpd_music}/*/*" ] && continue
  echo "Retrieving acoustic info for path:${album}" >> "${XLOG}"
  beet -v acousticbrainz "path:${album}" >> "${XLOG}" 2>&1
  sleep 10
done
