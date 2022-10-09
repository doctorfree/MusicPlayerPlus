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
NCM_CONF="${HOME}/.config/ncmpcpp/config"
ART_CONF="${HOME}/.config/mpcplus/config-art"
UEB_CONF="${HOME}/.config/mpcplus/ueberzug/config"
CAV_CONF="${HOME}/.config/mppcava/config"
CAV_TMUX="${HOME}/.config/mppcava/config-tmux"

have_ncmpcpp=`type -p ncmpcpp`
if [ "${have_ncmpcpp}" ]
then
  ncmpcpp --version | grep visualizer > /dev/null || NCM_CONF=
else
  NCM_CONF=
fi

if [ "$1" == "mopidy" ]
then
  # Modify mpcplus config with Mopidy visualizer_data_source
  for mpcconf in ${MPC_CONF} ${ART_CONF} ${UEB_CONF} ${NCM_CONF}
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
    for mpcconf in ${MPC_CONF} ${ART_CONF} ${UEB_CONF} ${NCM_CONF}
    do
      [ -f "${mpcconf}" ] && {
        cat "${mpcconf}" | \
          sed -e "s%^visualizer_data_source =%#visualizer_data_source =%" \
              -e "s%^#visualizer_data_source = ~/.config/mpd/mpd.fifo%visualizer_data_source = ~/.config/mpd/mpd.fifo%" > /tmp/viz$$
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
