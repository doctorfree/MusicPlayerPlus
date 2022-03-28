#!/bin/bash

if [ -f ${HOME}/.config/mpcplus/config ]
then
  MPCDIR=".config/mpcplus"
else
  if [ -f ${HOME}/.mpcplus/config ]
  then
    MPCDIR=".mpcplus"
  else
    mpcinit
    MPCDIR=".config/mpcplus"
  fi
fi

COVER="${HOME}/${MPCDIR}/album_cover.png"
COVER_SIZE="400"

mpd_music=`grep ^music_directory /etc/mpd.conf`
if [ "${mpd_music}" ]
then
  MUSIC_DIR=`echo ${mpd_music} | awk ' { print $2 } ' | sed -e "s/\"//g"`
else
  mpd_music=`grep ^mpd_music_dir ${HOME}/${MPCDIR}/config`
  if [ "${mpd_music}" ]
  then
    MUSIC_DIR=`echo ${mpd_music} | awk ' { print $3 } '`
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

