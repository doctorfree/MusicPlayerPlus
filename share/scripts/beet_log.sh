#!/bin/bash
#
# beet_log.sh - log beet import times, calculate elapsed time
#
# Written 12/Jul/2022 by Ronald Joe Record <ronaldrecord@gmail.com>
#
# This script is intended to be called from the Beets hook plugin
# It is called when a beet import begins and again when the import ends
# The calculated elapsed time between calls provides the user with
# the length of time the import took. Large music libraries can take
# many hours to import. The length of import time can vary depending
# upon which plugins are enabled and the settings for those plugins.
#
# See ~/.config/beets/config.yaml for the hook plugin configuration

LOG="${HOME}/.config/beets/import_time.log"
DATE=$(date "+%Y/%m/%d at %H:%M:%S")
SECONDS=$(date +%s)

[ -f ${LOG} ] || touch ${LOG}

if tail -1 ${LOG} | grep 'Import end' > /dev/null
then
  printf "${SECONDS} on ${DATE} $*\n" >> ${LOG}
else
  if tail -1 ${LOG} | grep '^# Import' > /dev/null
  then
    printf "${SECONDS} on ${DATE} $*\n" >> ${LOG}
  else
    PREVSECS=$(tail -1 ${LOG} | awk ' { print $1 } ')
    if [ "${PREVSECS}" ]
    then
      ELAPSECS=$(( SECONDS - PREVSECS ))
      ELAPSED=`eval "echo elapsed time: $(date -ud "@$ELAPSECS" +'$((%s/3600/24)) days %H hr %M min %S sec')"`
      printf "${SECONDS} on ${DATE} $* , ${ELAPSED}\n" >> ${LOG}
    else
      printf "${SECONDS} on ${DATE} $*\n" >> ${LOG}
    fi
  fi
fi
