#!/bin/bash
#
# blissify.sh - set MPD_HOST and MPD_PORT then exec the blissify binary

MPD_CONF="${HOME}/.config/mpd/mpd.conf"

[ "${MPD_HOST}" ] || {
  mpd_host=`grep ^bind_to_address ${MPD_CONF}`
  mpd_host=`echo ${mpd_host} | awk ' { print $2 } ' | sed -e "s/\"//g"`
  [ "${mpd_host}" ] || mpd_host="localhost"
  MPD_HOST="${mpd_host}"
}
[ "${MPD_PORT}" ] || {
  mpd_port=`grep ^port ${MPD_CONF}`
  mpd_port=`echo ${mpd_port} | awk ' { print $2 } ' | sed -e "s/\"//g"`
  [ "${mpd_port}" ] || mpd_port="6600"
  MPD_PORT="${mpd_port}"
}
export MPD_HOST MPD_PORT

blissify $@
