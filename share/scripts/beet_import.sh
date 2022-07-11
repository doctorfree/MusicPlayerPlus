#!/bin/bash

exp_music="$1"
importlog="${HOME}/.config/beets/import_log.txt"

have_beet=`type -p beet`
if [ "${have_beet}" ]
then
  beet import -qWl ${importlog} ${exp_music} > /dev/null 2>&1
  beet import -qWpsl ${importlog} ${exp_music} > /dev/null 2>&1
else
  if [ -x ${HOME}/.local/bin/beet ]
  then
    ${HOME}/.local/bin/beet import -qWl ${importlog} ${exp_music} > /dev/null 2>&1
    ${HOME}/.local/bin/beet import -qWpsl ${importlog} ${exp_music} > /dev/null 2>&1
  else
    echo "WARNING: Cannot locate 'beet' executable"
    echo "Music library ${exp_music} not imported to beets media organizer"
    exit 1
  fi
fi

exit 0
