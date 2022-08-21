#!/bin/bash

MPD_CONF="${HOME}/.config/mpd/mpd.conf"

mpd_music=`grep ^music_directory ${MPD_CONF}`
mpd_music=`echo ${mpd_music} | awk ' { print $2 } ' | sed -e "s/\"//g"`
[ "${mpd_music}" ] || mpd_music="${HOME}/Music"
# Need to expand the tilda to $HOME
mpd_music="${mpd_music/#\~/$HOME}"

for playlist in "$@"
do
  [ -f "${playlist}" ] || {
    echo "Could not locate: ${playlist}"
    echo "Skipping conversion to relative paths for this playlist."
    continue
  }
  echo "Converting to relative pathnames: ${playlist}"
  cat "${playlist}" | sed -e "s%${mpd_music}/%%" > /tmp/playlist$$
  cp /tmp/playlist$$ "${playlist}"
  rm -f /tmp/playlist$$
done

exit 0
