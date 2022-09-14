#!/bin/bash

for pcminfo in /proc/asound/*/pcm*/info
do
    [ "${pcminfo}" == "/proc/asound/*/pcm*/info" ] && continue
    grep stream: "${pcminfo}" | grep -i playback > /dev/null || continue
    cardnum=`grep ^card: "${pcminfo}" | awk -F ':' ' { print $2 } '`
    cardnum=`echo ${cardnum} | \
      sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
    devinum=`grep ^device: "${pcminfo}" | awk -F ':' ' { print $2 } '`
    devinum=`echo ${devinum} | \
      sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'`
    [ "${cardnum}" ] && [ "${devinum}" ] && {
      hw_address="hw:${cardnum},${devinum}"
      break
    }
done

echo "${hw_address}"
