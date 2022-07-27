#!/bin/bash

MPDCONF=~/.config/mpd/mpd.conf

if [ -f ${HOME}/.config/mpcplus/config ]
then
  MPCDIR=".config/mpcplus"
else
  if [ -f ${HOME}/.mpcplus/config ]
  then
    MPCDIR=".mpcplus"
  else
    mppinit
    MPCDIR=".config/mpcplus"
  fi
fi

COVER="${HOME}/${MPCDIR}/album_cover.png"
COVER_SIZE="400"

[ -f ${MPDCONF} ] || {
  [ -f /etc/mpd.conf ] && MPDCONF=/etc/mpd.conf
}
mpd_music=`grep ^music_directory ${MPDCONF}`
if [ "${mpd_music}" ]
then
  MUSIC_DIR=`echo ${mpd_music} | awk ' { print $2 } ' | sed -e "s/\"//g"`
  # Need to expand the tilda to $HOME
  MUSIC_DIR="${MUSIC_DIR/#\~/$HOME}"
else
  mpd_music=`grep ^mpd_music_dir ${HOME}/${MPCDIR}/config`
  if [ "${mpd_music}" ]
  then
    MUSIC_DIR=`echo ${mpd_music} | awk ' { print $3 } '`
    # Need to expand the tilda to $HOME
    MUSIC_DIR="${MUSIC_DIR/#\~/$HOME}"
  else
    MUSIC_DIR=${HOME}/Music
  fi
fi

file="${MUSIC_DIR}/$(mpc --format %file% current)"
album="${file%/*}"
art=$(find "${album}"  -maxdepth 1 | grep -m 1 ".*\.\(jpg\|png\|gif\|bmp\)")
if [ "${art}" = "" ]; then
  art="${HOME}/${MPCDIR}/default_cover.png"
fi
ffmpeg -loglevel 0 -y -i "${art}" -vf "scale=${COVER_SIZE}:-1" "${COVER}"

