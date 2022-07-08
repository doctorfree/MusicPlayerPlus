#!/bin/bash

status=0
# First try to open the display
have_xdpy=`type -p xdpyinfo`
if [ "${have_xdpy}" ]
then
  xdpyinfo -display "${DISPLAY}" > /dev/null 2>&1
  status=$?
else
  have_gnome=`type -p gnome-terminal`
  [ "${have_gnome}" ] && {
    gnome-terminal --quiet -- echo "" > /dev/null 2>&1
    status=$?
  }
fi

[ ${status} -eq 0 ] || exit ${status}

# Successfully opened display or apps were not found, check tty
have_tty=`type -p tty`
[ "${have_tty}" ] && {
  tty=$(tty)
  echo "${tty}" | grep /dev/tty > /dev/null && exit 1
  echo "${tty}" | grep /dev/con > /dev/null && exit 1
}

exit 0
