#!/bin/bash
#

MPD_CONF="${HOME}/.config/mpd/mpd.conf"
SCRIPTS="/usr/share/musicplayerplus/scripts"
ANY2ANY="${SCRIPTS}/any2any.sh"

usage() {
  printf "\nUsage: wav2mp3.sh [-d music_directory] [-u]"
  printf "\nWhere:"
  printf "\n\nWithout the '-d music_directory' option, the 'music_directory'"
  printf "\nsetting in ${MPD_CONF} will be used\n\n"
  exit 1
}

mpd_music=
custom_dir=
while getopts "d:u" flag; do
    case $flag in
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

[ -x ${ANY2ANY} ] || {
  if [ -x /usr/local/bin/any2any ]
  then
    ANY2ANY="/usr/local/bin/any2any"
  else
    echo "Cannot locate ${ANY2ANY}"
    echo "or it is not executable. Check MusicPlayer installation."
    echo "Exiting."
    exit 1
  fi
}

echo "Finding WAV format media in ${mpd_music} and converting to MP3 format"
wavfiles=()
while IFS=  read -r -d $'\0'
do
  wavfiles+=("$REPLY")
done < <(find "${mpd_music}" -type f -name \*\.wav -print0)

folders=()
for wav in "${wavfiles[@]}"
do
  folder=`dirname "${wav}"`
  base=`basename "${folder}"`
  [ "${base}" == "WAV" ] && continue
  haveit=
  for item in "${folders[@]}"
  do
    [[ "${folder}" == "${item}" ]] && {
      haveit=1
      break
    }
  done
  [ "${haveit}" ] || folders+=("${folder}")
done

HERE=`pwd`
for folder in "${folders[@]}"
do
  [ -d "${folder}/WAV" ] || mkdir -p "${folder}/WAV"
  [ -d "${folder}/MP3" ] || mkdir -p "${folder}/MP3"
  cd "${folder}"
  mv *.wav WAV
  echo "Converting WAV to MP3 in ${folder}"
  ${ANY2ANY} -i wav -o mp3 WAV/*.wav > /dev/null 2>&1
  mv MP3/*.mp3 .
  rmdir MP3
  cd "${HERE}"
done

echo "Done"

exit 0
