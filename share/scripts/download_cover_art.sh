#!/bin/bash
#
# Uses sacad from https://github.com/desbma/sacad

MPD_CONF=${HOME}/.config/mpd/mpd.conf

usage() {
  printf "\nUsage: download_cover_art.sh [-c cover_name] [-d music_directory] [-u]"
  printf "\nWhere:"
  printf "\n\t-c 'cover_name' specifies the filename to use for downloaded art"
  printf "\n\t\tDefault: 'cover'"
  printf "\n\nWithout the '-d music_directory' option, the 'music_directory'"
  printf "\nsetting in ${MPD_CONF} will be used\n\n"
  exit 1
}

mpd_music=
custom_dir=
cover_name="cover"
while getopts "c:d:u" flag; do
    case $flag in
        c)
            cover_name="$OPTARG"
            ext=$([[ "$cover_name" = *.* ]] && echo ".${cover_name##*.}" || echo '')
            [ "${ext}" ] && {
              echo "Cover filename provided with extension. Removing extension."
              cover_name="${cover_name%.*}"
              echo "Using ${cover_name} as template for downloaded art filename"
            }
            ;;
        d)
            mpd_music="$OPTARG"
            custom_dir=1
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

have_sacad=`type -p sacad_r`
[ "${have_sacad}" ] || {
  if pip list | grep sacad > /dev/null
  then
    python -m pip install --upgrade sacad
  else
    python -m pip install sacad
  fi
}

echo "Downloading album cover art for Artist/Albums in ${mpd_music}"
sacad_r "${mpd_music}" 600 ${cover_name}.jpg
