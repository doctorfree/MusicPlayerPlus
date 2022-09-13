#!/usr/bin/env bash

## sample helper script demoing usage of `alsa-capabilities` from within a
## python script, in this case `get-interfaces.py` in the current directory.
## 
## to see it in action start it by using:
## python get-interfaces.py

LANG=C

function fetch_alsa_hwaddresses() {
    ## use alsa-capabilities script to get alsa output interfaces; if
    ## one interface is found, use that, otherwise display all of them
    ## and ask the user which to use.
    ##
    ## stores the hardware address and label in global variables
    ## ALSA_AIF_HWADDRESS and ALSA_AIF_DEVLABEL.

    [[ ! -z "${DEBUG}" ]] && debug "entering \`${FUNCNAME}' with arguments \`$@'"

    ## prompt when multiple alsa interfaces are found
    msg_multiple_alsahw="Multiple interfaces found."

    ## when more than one matching output device is found and
    ## USER_PROMPTS is not set, prompt the user to select one,
    ## defaults to the first device found.

    ## put the result of alsa-capabilities in the appropriate arrays
    return_alsa_interface -q

    for key in "${!ALSA_AIF_HWADDRESSES[@]}"; do
	## echo each interface
	printf "Interface %s on %s (%s)\n"  \
	       "${ALSA_AIF_LABELS[${key}]}" \
	       "${ALSA_AIF_DEVLABELS[${key}]}" \
	       "${ALSA_AIF_HWADDRESSES[$key]}"
    done
}

### program start

ALSA_CAPABILITIES_SCRIPT="/usr/bin/alsa-capabilities"

[[ -f "${ALSA_CAPABILITIES_SCRIPT}" ]] && \
    source "${ALSA_CAPABILITIES_SCRIPT}" || \
    die "required script \`${ALSA_CAPABILITIES_SCRIPT}' not found"

## global indexed arrays that will be filled from `alsacapabilities.sh'
## the ones used in this example are uncommented
declare -a ALSA_AIF_HWADDRESSES=()
#declare -a ALSA_AIF_DISPLAYTITLES=()
#declare -a ALSA_AIF_MONITORFILES=()
declare -a ALSA_AIF_DEVLABELS=()
declare -a ALSA_AIF_LABELS=()
#declare -a ALSA_AIF_UACCLASSES=()
#declare -a ALSA_AIF_FORMATS=()
#declare -a ALSA_AIF_CHARDEVS=()

## pass limits to the alsa-capabilities script
LIMIT_INTERFACE_TYPE="${LIMIT_INTERFACE_TYPE:-}"
if [[ ! -z ${LIMIT_INTERFACE_TYPE} ]]; then
    case ${LIMIT_INTERFACE_TYPE} in
	"analog")
	    OPT_LIMIT_AO="True" ;;
	"digital")
	    OPT_LIMIT_DO="True" ;;
	"usb"|"uac")
	    OPT_LIMIT_UO="True" ;;
    esac
fi
LIMIT_INTERFACE_FILTER="${LIMIT_INTERFACE_FILTER:-}"
[[ ! -z ${LIMIT_INTERFACE_FILTER} ]] && OPT_FILTER="${LIMIT_INTERFACE_FILTER}"

## return a string with interfaces 
fetch_alsa_hwaddresses

