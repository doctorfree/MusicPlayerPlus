#!/bin/bash
#
# set_prev_cava.sh - merge previously configured cava user preferences
#                       with $HOME/.config/mppcava/config

USERCONF="${HOME}/.config"
CAV_USER_CONF="${USERCONF}/cava/config"
MPP_USER_CONF="${USERCONF}/mppcava/config"
SCPTDIR="/usr/share/musicplayerplus/scripts"

if [ -x "${SCPTDIR}/crudini.py" ]
then
  CRUDINI="${SCPTDIR}/crudini.py"
else
  have_crudini=`type -p crudini`
  if [ "${have_crudini}" ]
  then
    CRUDINI=crudini
  else
    CRUDINI=
  fi
fi

[ -f "${CAV_USER_CONF}" ] && [ -f "${MPP_USER_CONF}" ] && [ "${CRUDINI}" ] && {
  mth=`${CRUDINI} --get ${MPP_USER_CONF} input method`
  src=`${CRUDINI} --get ${MPP_USER_CONF} input source`
  ${CRUDINI} --merge ${MPP_USER_CONF} < ${CAV_USER_CONF}
  ${CRUDINI} --set ${MPP_USER_CONF} input method ${mth}
  ${CRUDINI} --set ${MPP_USER_CONF} input source ${src}
}

exit 0
