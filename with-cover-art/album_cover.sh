#!/bin/bash

source "`ueberzug library`"

function add_cover {
  ImageLayer::add [identifier]="img" [x]="1" [y]="2" [path]="${COVER}"
}

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

COVER=${HOME}/${MPCDIR}/album_cover.png

ImageLayer 0< <(
if [ ! -f "${COVER}" ]; then
  cp ${HOME}/${MPCDIR}/default_cover.png ${COVER}
fi
while inotifywait -q -q -e close_write "${COVER}"; do
  add_cover
done
)

