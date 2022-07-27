#!/bin/bash

source "`ueberzug library`"

function add_cover {
  ImageLayer::add [identifier]="img" [x]="1" [y]="${YOFF}" [path]="${COVER}"
}

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

COVER=${HOME}/${MPCDIR}/album_cover.png
YOFF=2
[ "$1" == "-f" ] && YOFF=1

ImageLayer 0< <(
if [ ! -f "${COVER}" ]; then
  cp ${HOME}/${MPCDIR}/default_cover.png ${COVER}
fi
while inotifywait -q -q -e close_write "${COVER}"; do
  add_cover
done
)

