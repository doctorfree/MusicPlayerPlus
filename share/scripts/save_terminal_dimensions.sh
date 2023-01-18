#!/bin/bash
#
# Save the terminal dimensions in a file
# This is used by the album cover art script

have_td=`type -p terminal_dimensions`
[ "${have_td}" ] || {
  echo "The terminal_dimensions binary is not installed or not in PATH"
  echo "Exiting without saving terminal dimensions"
  exit 1
}

SAVE="/tmp/__terminal_dimensions__"
[ "$1" ] && SAVE="$1"

terminal_dimensions > "${SAVE}"

printf "\nTerminal dimensions saved in ${SAVE} as: "
dims=$(cat ${SAVE})
printf "${dims}\n"
