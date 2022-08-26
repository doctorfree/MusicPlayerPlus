#!/bin/bash
#
# viz_data_src.sh - modify the spectrum visualizer data source
#
#    MPD and Mopidy provide different sources for audio data read
#    by the mpcplus and mppcava spectrum visualizers. This script
#    can be used to automate the mpcplus and mppcava configuration
#    files to use the appropriate visualizer data source.
#
# Written 2022-08-26 by Ronald Joe Record <ronaldrecord@gmail.com>

MPC_CONF="${HOME}/.config/mpcplus/config"
ART_CONF="${HOME}/.config/mpcplus/config-art"
CAV_CONF="${HOME}/.config/mppcava/config"
CAV_TMUX="${HOME}/.config/mppcava/config-tmux"

if [ "$1" == "mopidy" ]
then
  # Modify mpcplus config with Mopidy visualizer_data_source
  for mpcconf in ${MPC_CONF} ${ART_CONF}
  do
    [ -f "${mpcconf}" ] && {
      cat "${mpcconf}" | \
        sed -e "s%^visualizer_data_source =%#visualizer_data_source =%" \
            -e "s%^#visualizer_data_source = localhost:5555%visualizer_data_source = localhost:5555%" > /tmp/viz$$
      cp /tmp/viz$$ "${mpcconf}"
      rm -f /tmp/viz$$
    }
  done
  # Modify mppcava config with Mopidy visualizer method and source
  for mppconf in ${CAV_CONF} ${CAV_TMUX}
  do
    [ -f "${mppconf}" ] && {
      cat "${mppconf}" | \
        sed -e "s%^method =%; method =%" \
            -e "s%^; method = pulse%method = pulse%" \
            -e "s%^source =%; source =%" \
            -e "s%^; source = auto # pulse%source = auto # pulse%" > /tmp/viz$$
      cp /tmp/viz$$ "${mppconf}"
      rm -f /tmp/viz$$
    }
  done
else
  if [ "$1" == "mpd" ]
  then
    # Modify mpcplus config with MPD visualizer_data_source
    [ -f "${MPC_CONF}" ] && {
      cat "${MPC_CONF}" | sed -e "s%^visualizer_data_source = localhost:5555%#visualizer_data_source = localhost:5555%" > /tmp/viz$$
      cp /tmp/viz$$ "${MPC_CONF}"
      rm -f /tmp/viz$$
    }
    # Modify mpcplus config with MPD visualizer_data_source
    for mpcconf in ${MPC_CONF} ${ART_CONF}
    do
      [ -f "${mpcconf}" ] && {
        cat "${mpcconf}" | \
          # Comment all entries out and use the default, a fifo
          sed -e "s%^visualizer_data_source =%#visualizer_data_source =%" > /tmp/viz$$
        cp /tmp/viz$$ "${mpcconf}"
        rm -f /tmp/viz$$
      }
    done
    # Modify mppcava config with MPD visualizer method and source
    for mppconf in ${CAV_CONF} ${CAV_TMUX}
    do
      [ -f "${mppconf}" ] && {
        cat "${mppconf}" | \
          sed -e "s%^method =%; method =%" \
              -e "s%^; method = fifo%method = fifo%" \
              -e "s%^source =%; source =%" > /tmp/viz$$
        cp /tmp/viz$$ "${mppconf}"
        rm -f /tmp/viz$$
        sed -i -E "s%; source =(.+)mpd.fifo%source =\1mpd.fifo%" ${mppconf}
      }
    done
  else
    exit 1
  fi
fi

exit 0
