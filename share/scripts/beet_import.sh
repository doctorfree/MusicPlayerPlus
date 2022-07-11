#!/bin/bash
#

MPD_CONF=${HOME}/.config/mpd/mpd.conf
LOGFILE="${HOME}/.config/beets/import_log.txt"

usage() {
  printf "\nUsage: beet_import.sh -[w|W] [-d music_directory] [-u]"
  printf "\nWhere:"
  printf "\n\t-w indicates write tags during import"
  printf "\n\t-W indicates do not write tags during import"
  printf "\n\tWithout a -w or -W flag, writing of tags is determined by the"
  printf "\n\tBeets configuration file $HOME/.config/beets/config.yaml"
  printf "\n\nWithout the '-d music_directory' option, the 'music_directory'"
  printf "\nsetting in ${MPD_CONF} will be used\n\n"
  exit 1
}

mpd_music=
custom_dir=
tagflag=
while getopts "d:wWu" flag; do
    case $flag in
        d)
            mpd_music="$OPTARG"
            custom_dir=1
            ;;
        w)
            tagflag="-w"
            ;;
        W)
            tagflag="-W"
            ;;
        u)
            usage
            ;;
    esac
done

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
  beet import -q ${tagflag} -l ${LOGFILE} ${mpd_music}
  beet import -q ${tagflag} -p -s -l ${LOGFILE} ${mpd_music}
else
  if [ -x ${HOME}/.local/bin/beet ]
  then
    ${HOME}/.local/bin/beet import -q ${tagflag} -l ${LOGFILE} ${mpd_music}
    ${HOME}/.local/bin/beet import -q ${tagflag} -p -s -l ${LOGFILE} ${mpd_music}
  else
    echo "WARNING: Cannot locate 'beet' executable"
    echo "Music library ${mpd_music} not imported to beets media organizer"
    exit 1
  fi
fi

exit 0
