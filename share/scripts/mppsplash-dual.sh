#!/bin/bash
#
# mppsplash-tmux - display ASCIImatics splash screens in a tmux session
MUSEDIR=/usr/share/musicplayerplus/music
SONG="${MUSEDIR}/Epic_Dramatic-Yuriy_Bespalov.wav"
PLASMA_SONG="${MUSEDIR}/Chronos.mp3"
ALTSONG="${MUSEDIR}/Kevin_MacLeod_-_Also_Sprach_Zarathustra.ogg"
SESSION=mppsplash
MPDCONF=~/.config/mpd/mpd.conf

usage() {
  printf "\nUsage: mppsplash-tmux [-a] [-b] [-c num] [-d] [-l script] "
  printf "[-r script] [-R] [-s song] [-t] [-u]"
  printf "\nWhere:"
  printf "\n\t-a indicates play audio during ASCIImatics display"
  printf "\n\t-b indicates use backup song during ASCIImatics display"
  printf "\n\t-c num specifies number of cycles ASCIImatics effects should run"
  printf "\n\t-d indicates dual window panes, run two scripts"
  printf "\n\t-l script specifies a python script to run in the left visualizer pane"
  printf "\n\t-r script specifies a python script to run in the right visualizer pane"
  printf "\n\t-R indicates record tmux session with asciinema"
  printf "\n\t-s song specifies audio file to use as accompaniment"
  printf "\n\t\t'song' can be the full pathname to an audio file or a relative"
  printf "\n\t\tpathname to an audio file in the MPD music library"
  printf "\n\t\tor $HOME/Music/"
  printf "\n\t-t indicates use original plasma effect comments"
  printf "\n\t-u displays this usage message and exits\n"
  printf "\nDefaults: single pane, left pane plasma, right pane julia, recording disabled"
  printf "\nThis run:"
  printf "\n\tPrimary pane = ${PYLEFT}"
  [ "${DUAL}" ] && printf "\n\tSecondary pane = ${PYRIGHT}"
  if [ "${RECORD}" ]
  then
    printf "\n\trecording enabled"
  else
    printf "\n\trecording disabled"
  fi
  printf "\nType 'man mppsplash-tmux' for detailed usage info on mppsplash-tmux"
  printf "\nType 'man mppsplash' for detailed usage info on mppsplash\n"
  exit 1
}

[ -f ${HOME}/.venv/bin/activate ] && source ${HOME}/.venv/bin/activate

custom_audio=
AUDIO=
CYCLE=
DUAL=
DUDE=
KILLME=
RECORD=
PYLEFT=plasma
PYRIGHT=julia
USAGE=
while getopts "abc:dl:r:Rs:tu" flag; do
    case $flag in
        a)
          AUDIO=1
          ;;
        b)
          AUDIO=1
          TMPSONG=${SONG}
          SONG=${ALTSONG}
          ALTSONG=${TMPSONG}
          ;;
        c)
          CYCLE="-c ${OPTARG}"
          ;;
        d)
          DUAL=1
          ;;
        l)
          PYLEFT=${OPTARG}
          ;;
        r)
          PYRIGHT=${OPTARG}
          ;;
        R)
          have_nema=`type -p asciinema`
          [ "${have_nema}" ] && RECORD=1
          ;;
        s)
          custom_audio=1
          if [ -f "${OPTARG}" ]
          then
            SONG="${OPTARG}"
          else
            if [ -f "${MUSEDIR}/${OPTARG}" ]
            then
              SONG="${MUSEDIR}/${OPTARG}"
            else
              if [ -f "${HOME}/Music/${OPTARG}" ]
              then
                SONG="${HOME}/Music/${OPTARG}"
              else
                [ -f ${MPDCONF} ] || {
                  [ -f /etc/mpd.conf ] && MPDCONF=/etc/mpd.conf
                }
                mpd_music=`grep ^music_directory ${MPDCONF}`
                [ "${mpd_music}" ] || mpd_music=`grep \#music_directory ${MPDCONF}`
                mpd_music=`echo ${mpd_music} | awk ' { print $2 } ' | sed -e "s/\"//g"`
                # Need to expand the tilda to $HOME
                mpd_music="${mpd_music/#\~/$HOME}"
                if [ -f "${mpd_music}/${OPTARG}" ]
                then
                  SONG="${mpd_music}/${OPTARG}"
                else
                  custom_audio=
                  echo "Cannot locate ${OPTARG}"
                  echo "Using default song: ${SONG}"
                fi
              fi
            fi
          fi
          ;;
        t)
          DUDE=1
          ;;
        u)
          USAGE=1
          ;;
    esac
done
shift $(( OPTIND - 1 ))
[ "${AUDIO}" ] && {
  [ "${PYLEFT}" == "plasma" ] && {
    [ "${custom_audio}" ] || SONG="${PLASMA_SONG}"
  }
  if [ -f "${SONG}" ]
  then
    left_script_args="${left_script_args} -s ${SONG}"
  else
    if [ -f "${ALTSONG}" ]
    then
      left_script_args="${left_script_args} -s ${ALTSONG}"
    fi
  fi
}
script_args="${script_args} ${CYCLE}"

if [ "${DUDE}" ]
then
  [ "${PYLEFT}" == "art" ] && left_script_args="${left_script_args} -i -C"
  [ "${PYRIGHT}" == "art" ] && right_script_args="${right_script_args} -i -C"
  [ "${PYLEFT}" == "rocks" ] && left_script_args="${left_script_args} -m -C"
  [ "${PYRIGHT}" == "rocks" ] && right_script_args="${right_script_args} -m -C"
  [ "${PYLEFT}" == "plasma" ] && left_script_args="${left_script_args} -p -C"
  [ "${PYRIGHT}" == "plasma" ] && right_script_args="${right_script_args} -p -C"
  [ "${PYLEFT}" == "julia" ] && left_script_args="${left_script_args} -j -C"
  [ "${PYRIGHT}" == "julia" ] && right_script_args="${right_script_args} -j -C"
else
  [ "${PYLEFT}" == "art" ] && left_script_args="${left_script_args} -i"
  [ "${PYRIGHT}" == "art" ] && right_script_args="${right_script_args} -i"
  [ "${PYLEFT}" == "rocks" ] && left_script_args="${left_script_args} -m"
  [ "${PYRIGHT}" == "rocks" ] && right_script_args="${right_script_args} -m"
  [ "${PYLEFT}" == "plasma" ] && left_script_args="${left_script_args} -p"
  [ "${PYRIGHT}" == "plasma" ] && right_script_args="${right_script_args} -p"
  [ "${PYLEFT}" == "julia" ] && left_script_args="${left_script_args} -j"
  [ "${PYRIGHT}" == "julia" ] && right_script_args="${right_script_args} -j"
fi

if [ "${PYLEFT}" == "art" ]; then
  have_left=`type -p asciiart`
  [ "${have_left}" ] && PYLEFT="asciiart"
else
  have_left=`type -p mpp${PYLEFT}`
  [ "${have_left}" ] && PYLEFT="mpp${PYLEFT}"
fi

if [ "${PYRIGHT}" == "art" ]; then
  have_right=`type -p asciiart`
  [ "${have_right}" ] && PYRIGHT="asciiart"
else
  have_right=`type -p mpp${PYRIGHT}`
  [ "${have_right}" ] && PYRIGHT="mpp${PYRIGHT}"
fi

[ "${USAGE}" ] && usage

tmux new-session -d -x "$(tput cols)" -y "$(tput lines)" -s ${SESSION}
tmux set -g status off

tmux send-keys "stty -echo" C-m
sleep 2
tmux send-keys "tput civis -- invisible" C-m
[ -f ${HOME}/.venv/bin/activate ] && {
  tmux send-keys "source ${HOME}/.venv/bin/activate" C-m
}
tmux send-keys "export PS1=''" C-m
tmux send-keys "clear" C-m
[ "${DUAL}" ] && {
  tmux split-window -h -p 50
  [ -f ${HOME}/.venv/bin/activate ] && {
    tmux send-keys "source ${HOME}/.venv/bin/activate" C-m
  }
}

tmux select-pane -t 1
have_left=`type -p ${PYLEFT}`
[ "${have_left}" ] || {
  tmux kill-session -t ${SESSION}
  echo "${PYLEFT} not found. Exiting."
  exit 1
}

# Start the left pane script
tmux send-keys "mppsplash ${left_script_args} ${script_args}; tmux kill-session -t ${SESSION}" C-m

[ "${DUAL}" ] && {
  have_right=`type -p ${PYRIGHT}`
  [ "${have_right}" ] || {
    tmux kill-session -t ${SESSION}
    echo "${PYRIGHT} not found. Exiting."
    exit 1
  }
  tmux select-pane -t 2

  # Start the right pane script
  tmux send-keys "mppsplash ${right_script_args} ${script_args}; tmux kill-session -t ${SESSION}" C-m
}

#tmux resize-pane -t 0 -x ${WIDTH} -y ${HEIGHT}
#tmux set-hook client-resized "resize-pane -t 0 -x ${WIDTH} -y ${HEIGHT}"

if [ "${RECORD}" ]
then
  tmux d
  VID_DIR=$HOME/Videos
  [ -d ${VID_DIR} ] || mkdir ${VID_DIR}
  REC_DIR=${VID_DIR}/asciinema
  [ -d ${REC_DIR} ] || mkdir ${REC_DIR}
  echo "Recording this ${SESSION} session with asciinema"
  asciinema rec --command "tmux attach -t ${SESSION}" \
                ${REC_DIR}/${SESSION}-$(date +%F--%H%M).cast
else
  tmux a #
fi
