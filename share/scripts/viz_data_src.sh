#!/bin/bash

MPC_CONF="${HOME}/.config/mpcplus/config"

[ -f "${MPC_CONF}" ] || exit 1

if [ "$1" == "mopidy" ]
then
  cat "${MPC_CONF}" | sed -e "s%^#visualizer_data_source = localhost:5555%visualizer_data_source = localhost:5555%" > /tmp/viz$$
  cp /tmp/viz$$ "${MPC_CONF}"
  rm -f /tmp/viz$$
else
  if [ "$1" == "mpd" ]
  then
    cat "${MPC_CONF}" | sed -e "s%^visualizer_data_source = localhost:5555%#visualizer_data_source = localhost:5555%" > /tmp/viz$$
    cp /tmp/viz$$ "${MPC_CONF}"
    rm -f /tmp/viz$$
  else
    exit 1
  fi
fi

exit 0
