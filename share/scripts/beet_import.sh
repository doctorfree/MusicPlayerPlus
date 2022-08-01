#!/bin/bash
#

MPD_CONF=${HOME}/.config/mpd/mpd.conf
BEETSLOGDIR="${HOME}/.config/beets/logs"
LOGTEMP="${BEETSLOGDIR}/import.log"
LOGFILE="${BEETSLOGDIR}/import.log"
LOGTIME="${BEETSLOGDIR}/import_time.log"
SINGLE_LOG="${BEETSLOGDIR}/import_singletons.log"

usage() {
  printf "\nUsage: beet_import.sh [-a] -[w|W] [-d music_directory] [-u]"
  printf "\nWhere:"
  printf "\n\t-a indicates use auto-tagger during import (slower)"
  printf "\n\t-w indicates write metadata during import"
  printf "\n\t-W indicates do not write metadata during import"
  printf "\n\tWithout a -w or -W flag, writing of metadata is determined by the"
  printf "\n\tBeets configuration file $HOME/.config/beets/config.yaml"
  printf "\n\nWithout the '-d music_directory' option, the 'music_directory'"
  printf "\nsetting in ${MPD_CONF} will be used\n\n"
  exit 1
}

mpd_music=
custom_dir=
autotag=
tagging="ON"
writeflag=
while getopts "Aad:wWu" flag; do
    case $flag in
        A)
            autotag="-A"
            tagging="OFF"
            ;;
        a)
            autotag=
            tagging="ON"
            ;;
        d)
            mpd_music="$OPTARG"
            custom_dir=1
            ;;
        w)
            writeflag="-w"
            ;;
        W)
            writeflag="-W"
            ;;
        u)
            usage
            ;;
    esac
done

impflags="${autotag} ${writeflag}"

[ "${custom_dir}" ] || {
  [ -f ${MPD_CONF} ] || {
    if [ -f /etc/mpd.conf ]
    then
      MPD_CONF=/etc/mpd.conf
    else
      echo "Could not locate ${MPD_CONF}"
      echo "Music directory can be specified using the '-d directory' option"
      echo "Exiting"
      usage
    fi
  }
}

[ "${mpd_music}" ] || {
  mpd_music=`grep ^music_directory ${MPD_CONF}`
  [ "${mpd_music}" ] || mpd_music=`grep \#music_directory ${MPD_CONF}`
  mpd_music=`echo ${mpd_music} | awk ' { print $2 } ' | sed -e "s/\"//g"`
  # Need to expand the tilda to $HOME
  mpd_music="${mpd_music/#\~/$HOME}"
  [ "${mpd_music}" ] || {
    echo "Could not detect any music_directory setting in ${MPD_CONF}."
    echo "Set the music_directory setting in ${MPD_CONF} and rerun this command."
    echo "Exiting."
    exit 1
  }
}

[ -d "${mpd_music}" ] || {
  if [ "${custom_dir}" ]
  then
    echo "Specified music directory:"
  else
    echo "music_directory setting in ${MPD_CONF}:"
  fi
  echo "    ${mpd_music}"
  echo "Does not exist or is not a directory."
  echo ""
  if [ "${custom_dir}" ]
  then
    echo "Rerun this command with the '-d music_directory' option providing"
    echo "a valid path to a music directory or without the -d option"
    echo "to use the music_directory setting in ${MPD_CONF}"
  else
    echo "Set the music_directory setting in ${MPD_CONF} and rerun this command."
  fi
  echo "Exiting."
  exit 1
}

have_beet=`type -p beet`
if [ "${have_beet}" ]
then
  BEET=beet
else
  if [ -x ${HOME}/.local/bin/beet ]
  then
    BEET="${HOME}/.local/bin/beet"
  else
    echo "WARNING: Cannot locate 'beet' executable"
    echo "Music library ${mpd_music} not imported to beets media organizer"
    exit 1
  fi
fi

[ -d "${BEETSLOGDIR}" ] || mkdir -p "${BEETSLOGDIR}"
[ -f "${LOGFILE}" ] && mv "${LOGFILE}" "${LOGTEMP}"
echo "# Importing artists from ${mpd_music}, auto-tag ${tagging}" >> "${LOGTIME}"
START_SECONDS=$(date +%s)
for artist in "${mpd_music}"/*
do
  [ "${artist}" == "${mpd_music}/*" ] && continue
  if [ -d "${artist}" ]
  then
    for album in "${artist}"/*
    do
      [ "${album}" == "${artist}/*" ] && continue
      if [ -d "${album}" ]
      then
        echo "# Importing ${album}" >> "${LOGTIME}"
        ${BEET} import -q ${impflags} -l "${LOGFILE}" "${album}"
      else
        echo "# Importing singleton ${album}" >> "${LOGTIME}"
        ${BEET} import -q ${impflags} -s -l "${SINGLE_LOG}" "${album}" >> "${SINGLE_LOG}" 2>&1
      fi
    done
  else
    echo "# Importing singleton ${artist}" >> "${LOGTIME}"
    ${BEET} import -q ${impflags} -s -l "${SINGLE_LOG}" "${artist}" >> "${SINGLE_LOG}" 2>&1
  fi
done

# Add skipped folders as singletons
grep '^skip\|^duplicate-skip' "${LOGFILE}" > /tmp/skip$$
sed 's/[^ ]* //' /tmp/skip$$ > /tmp/add$$
rm -f /tmp/skip$$
while read skipped
do
  echo "# Importing singletons ${skipped}" >> "${LOGTIME}"
  ${BEET} import -q ${impflags} -s -l "${SINGLE_LOG}" "${skipped}" >> "${SINGLE_LOG}" 2>&1
done < /tmp/add$$
rm -f /tmp/add$$
[ -f "${LOGTEMP}" ] && {
  [ -f "${LOGFILE}" ] && {
    mv "${LOGFILE}" /tmp/log$$
  }
  mv "${LOGTEMP}" "${LOGFILE}"
  [ -f /tmp/log$$ ] && {
    cat /tmp/log$$ >> "${LOGFILE}"
    rm -f /tmp/log$$
  }
}

FINISH_SECONDS=$(date +%s)
ELAPSECS=$(( FINISH_SECONDS - START_SECONDS ))
ELAPSED=`eval "echo total elapsed time: $(date -ud "@$ELAPSECS" +'$((%s/3600/24)) days %H hr %M min %S sec')"`
printf "\n# Import ${ELAPSED}\n" >> ${LOGTIME}

# First remove cover art in folders with no music
find "${mpd_music}" -type d -exec bash -O dotglob -c '
    for dirpath do
        ok=true
        seen_files=false
        set -- "$dirpath"/*
        for name do
            [ -d "$name" ] && continue  # skip dirs
            seen_files=true
            case "${name##*/}" in
                *.jpg|*.png) ;; # do nothing
                *) ok=false; break
            esac
        done

        "$seen_files" && "$ok" && printf "%s\n" "$dirpath"
    done' bash {} + | while read folder
do
    rm -f "${folder}"/*.jpg "${folder}"/*.png
done

# Append/Move mpdignore files that extrafiles could not move for us
# find "${mpd_music}" -type f -name mpdignore | while read mpd
# do
#   b=`dirname "$mpd"`
#   if [ -f "$b/.mpdignore" ]
#   then
#     cat "$mpd" >> "$b/.mpdignore"
#     rm -f "$mpd"
#   else
#     mv "$mpd" "$b/.mpdignore"
#   fi
# done

# Then remove empty folders
find "${mpd_music}" -depth -type d -empty -delete

exit 0
