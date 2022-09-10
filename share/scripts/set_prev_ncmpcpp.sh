#!/bin/bash
#
# set_prev_ncmpcpp.sh - merge previously configured ncmpcpp user preferences
#                       with $HOME/.config/mpcplus/config

USERCONF="${HOME}/.config"
NCM_USER_CONF="${USERCONF}/ncmpcpp/config"
MPC_USER_CONF="${USERCONF}/mpcplus/config"
UEB_USER_CONF="${USERCONF}/mpcplus/ueberzug/config"

# Syncing previous user configured ncmpcpp key bindings not yet implemented
NCM_USER_BIND="${USERCONF}/ncmpcpp/bindings"
MPC_USER_BIND="${USERCONF}/mpcplus/bindings"

# Ignore any previous ncmpcpp setting for these options
excluded_ncm_opts=("mpd_music_dir" "visualizer_in_stereo" \
                   "visualizer_type" "message_delay_time" \
                   "visualizer_look" "execute_on_song_change" \
                   "startup_screen" "startup_slave_screen" \
                   "startup_slave_screen_focus" "locked_screen_width_part")
# Prepend this comment to any appended previous ncmpcpp settings
previous_comments="## Previously configured ncmpcpp user preferences"

[ -f "${NCM_USER_CONF}" ] && [ -f "${MPC_USER_CONF}" ] && {
  # Only allowed to be run once if changes to mpcplus/config were made
  grep "${previous_comments}" "${MPC_USER_CONF}" > /dev/null && exit 0
  grep -v ^# "${NCM_USER_CONF}" | while read ncmconf
  do
    option=`echo "${ncmconf}" | awk -F '=' ' { print $1 } '`
    option=`echo ${option} | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
    [[ " ${excluded_ncm_opts[*]} " =~ " ${option} " ]] && continue
    [ "${option}" ] && {
      oval=`echo "${ncmconf}" | awk -F '=' ' { print $2 } '`
      oval=`echo ${oval} | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
      [ "${oval}" ] && {
        mval=`grep "^${option} " "${MPC_USER_CONF}" | \
                awk -F '=' ' { print $2 } '`
        mval=`echo ${mval} | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
        [ "${mval}" == "${oval}" ] || {
          # Use the previously configured value for this option
          for userconf in ${MPC_USER_CONF} ${UEB_USER_CONF}
          do
            [ -f "${userconf}" ] && {
              cat "${userconf}" | \
                sed -e "s/^${option} /#${option} /" > /tmp/ncm$$
              grep "${previous_comments}" /tmp/ncm$$ > /dev/null || {
                echo "${previous_comments}" >> /tmp/ncm$$
              }
              echo "${ncmconf}" >> /tmp/ncm$$
              cp /tmp/ncm$$ "${userconf}"
              rm -f /tmp/ncm$$
            }
          done
        }
      }
    }
  done
}

[ -f "${NCM_USER_BIND}" ] && {
  numb=`grep -v ^# "${NCM_USER_BIND}" | grep -v -e '^[[:space:]]*$' | wc -l`
  [ ${numb} -gt 0 ] && {
    if [ -f "${MPC_USER_BIND}" ]
    then
      printf "\n\nIntegration of previously configured ncmpcpp bindings is not"
      printf " yet implemented.\nManually merge the configured key bindings in:"
      printf "\n\n\t${NCM_USER_BIND}\ninto\n\t${MPC_USER_BIND}\n"
    else
      [ -d "${USERCONF}/mpcplus" ] || mkdir -p "${USERCONF}/mpcplus"
      cp "${NCM_USER_BIND}" "${MPC_USER_BIND}"
    fi
  }
}

exit 0
