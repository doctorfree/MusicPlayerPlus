#!/usr/bin/env bash
# fixed and persistent naming for multiple (identical or not) usb soundcards, 
# based on which port-hub-usbbus they connect to
# gmaruzz (at) celliax.org 
#
## This is to be executed by udev with the following rules:
#KERNEL=="controlC[0-9]*", DRIVERS=="usb", PROGRAM="/usr/bin/alsa_name.pl %k", NAME="snd/%c{1}"
#KERNEL=="hwC[D0-9]*", DRIVERS=="usb", PROGRAM="/usr/bin/alsa_name.pl %k", NAME="snd/%c{1}"
#KERNEL=="midiC[D0-9]*", DRIVERS=="usb", PROGRAM="/usr/bin/alsa_name.pl %k", NAME="snd/%c{1}"
#KERNEL=="pcmC[D0-9cp]*", DRIVERS=="usb", PROGRAM="/usr/bin/alsa_name.pl %k", NAME="snd/%c{1}"
#
## udev sets the following environment variables
#ACTION=add
#SUBSYSTEM=sound
#DEVPATH=/devices/pci0000:00/0000:00:1d.0/usb3/3-1/3-1.5/3-1.5:1.1/sound/card0/pcmC0D0p
#MINOR=2
#MAJOR=116
#DEVNAME=/dev/snd/pcmC0D0p

DEBUG=True

alsanum=0
alsaname="$1"

if [[ ${DEBUG} ]]; then
     printf 1>&2 "udev script \`%s' called\n" "$0"
     printf 1>&2 "with arg \`%s'\nand env:\n" "$1"
     while read -r line; do
	 IFS="=" read -r param value <<< "${line}"
	 case "${param}" in
	     ACTION|SUBSYSTEM|DEVPATH|MINOR|MAJOR|DEVNAME)
		 printf 1>&2 "param: \`%s' with value \`%s'\n"\
			     "${param}" "${value}"
		 ;;
	 esac
     done< <(printenv)
fi

## you can find the udev DEVPATH of a device with
## "udevadm info -a -p $(udevadm info -q path -n /dev/snd/pcmC0D0p)"
pci_re="pci([0-9:]+)/([^/]+)"
##      ^1:pci_bus   ^2:pci_device
usb_re="(usb[2-3])/([^/]+)/[^:]+:([^/]+)"
##      ^3:usb_class
##                 ^4:usb_bus    ^5:usb_dev
card_re="card([0-9]+)"
##           ^6:card_num
pcm_re="pcmC([0-9])D([0-9]+)(.*)"
##           ^7:pcm_c__num
##                  ^8:pcm_d_num
##                          ^9:pcm_type
devpath_re="^/devices/${pci_re}/${usb_re}/sound/${card_re}/${pcm_re}$"

if [[ "${DEVPATH}" =~ ${devpath_re} ]]; then
    pci_bus="${BASH_REMATCH[1]}"
    pci_dev="${BASH_REMATCH[2]}"
    usb_class="${BASH_REMATCH[3]}"
    usb_bus="${BASH_REMATCH[4]}"
    usb_dev="${BASH_REMATCH[5]}"
    card_num="${BASH_REMATCH[6]}"
    pcm_c_num="${BASH_REMATCH[7]}"
    pcm_d_num="${BASH_REMATCH[8]}"
    ## type: p=playback, c=capture
    pcm_type="${BASH_REMATCH[9]}"
    if [[ ${DEBUG} ]]; then
	counter=0
	for var in pci_bus pci_dev usb_class usb_bus card_num pcm_c_num pcm_d_num pcm_type; do
	    ((counter++))
	    printf 1>&2 "match: %s=%s\n" \
			"${var}" "${BASH_REMATCH[${counter}]}"
	done
    fi
    # start numbering from 10 (easier for debugging),
    # "0" is for motherboard soundcard,
    # max is "31"
    case "${usb_bus}" in
	"1-5.2")
	    alsanum=11 ;;
	"1-5.3")
	    alsanum=12 ;;
	"1-5.4")
	    alsanum=13 ;;
	"3-1")
	    alsanum=14 ;;
	"3-2")
	    alsanum=15 ;;
	*)
	    printf 1>&2 "unhandled bus position (usb_bus) \`%s' found\n" \
			"${usb_bus}"
	    ;;
    esac
else
    printf 1>&2 "error: could not match \`%s' using re \`%s'\n" \
		"${DEVPATH}" "${devpath_re}"
fi

# you can find this value with:
# journalctl -b | grep -Ei "usb.*(audio|pcm)"

if (( alsanum > 0 )); then
    # s/(.*)C([0-9]+)(.*)
    alsaname="pcmC${alsanum}D${pcm_d_num}${pcm_type}"
fi
## return the name
printf "%s" "${alsaname}"
