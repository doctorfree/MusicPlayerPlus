#!/usr/bin/env bash
## sample script for advanced usage of alsa-capabilities.  this script
## returns the monitor file for the interface specified in $1. if
## empty uses `hw:0,0`.

HWADDRESS="${1:-hw:0,0}"

## store the monitorfile 
declare -a ALSA_AIF_MONITORFILES=()

if [[ -f alsa-capabilities ]]; then
    source alsa-capabilities
elif [[ -f ../alsa-capabilities ]]; then 
    source ../alsa-capabilities
elif [[ -f $(pwd)/alsa-capabilities ]]; then 
    source $(pwd)/alsa-capabilities    
else
    printf "could not find \`alsa-capabilities'.\n"
    exit 1
fi

## call return_alsa_interface from alsa-capabilities with the `-a`
## option set to $HWADDRESS
return_alsa_interface -a "${HWADDRESS}" -q

printf "the audio card with alsa hardware address %s can be monitored with:\n" "${HWADDRESS}" 1>&2;
## print the resulting path to the monitoring file to std_out
printf "%s\n" "${ALSA_AIF_MONITORFILES[@]}"
