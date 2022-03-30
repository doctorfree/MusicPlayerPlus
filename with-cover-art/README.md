# Adding album art to MusicPlayerPlus

**MusicPlayerPlus** includes the really nice character based mpd client
**mpcplus**. It has all the functionality one would need, but sadly it
has no built-in way of showing album art for the current playing song
as rendering images via a terminal emulator is pretty tricky.

Here you will learn how to include album art in your mpcplus client and
include the cava spectrum visualizer while browsing songs. Luckily, you
will not have to copy and paste these files and setup the system yourself.
The MusicPlayerPlus package contains all the configuration, scripts, dependencies,
and a convenience startup command. To run `mpcplus` with spectrum visualization
and album art all you need to do is execute the `mpcplus-tmux` command.
If your music library contains album art in the album folders then it will
be displayed alongside the visualizer and MPD client.

The final result would be something like this:

![MusicPlayerPlus With Album Art](musicplayerplus.png)

# Prerequisites

To start off, a few dependencies need to be installed:

-   tmux           (to encapsulate everything in one window)
-   inotify-tools  (for changing album art when switching songs)
-   ueberzug       (for image rendering)
-   ffmpeg         (used in scaling the album art)
-   mpc            (cli client for MPD)

## Tmux
Tmux should already be installed either as a base package for your
Linux distribution or as a MusicPlayerPlus dependency. If it is not
installed (try `type -p tmux`) then install
[tmux](https://github.com/tmux/tmux/wiki) with:

```
sudo apt install tmux
```

## Inotify-tools
Install [inotify-tools](https://github.com/inotify-tools/inotify-tools) with:

```
sudo apt install inotify-tools
```

## Ueberzug
Install [Ueberzug](https://github.com/seebye/ueberzug) with:

```
python -m pip install ueberzug
```

## Ffmpeg
Install [ffmpeg](http://www.ffmpeg.org/) with:

```
sudo apt install ffmpeg
```

## Mpc
Mpc should already be installed as a MusicPlayerPlus dependency.
If it is not installed (try `type -p mpc`) then install
[mpc](https://www.musicpd.org/clients/mpc/) with:

```
sudo apt install mpc
```

# Setup

## Displaying cover images

The basic idea is that each time the song changes it triggers a script
that searches for an album cover and copies it in `/tmp` as
`album_cover.png`. Another script listens for changes on that file and
renders the new image in the terminal.

Start by creating a script named `album_cover.sh` in `~/.config/mpcplus/`:

```bash
#!/bin/bash

source "`ueberzug library`"

function add_cover {
  ImageLayer::add [identifier]="img" [x]="1" [y]="2" [path]="${COVER}"
}

if [ -f ${HOME}/.config/mpcplus/config ]
then
  MPCDIR=".config/mpcplus"
else
  if [ -f ${HOME}/.mpcplus/config ]
  then
    MPCDIR=".mpcplus"
  else
    mpcinit
    MPCDIR=".config/mpcplus"
  fi
fi

COVER=${HOME}/${MPCDIR}/album_cover.png

ImageLayer 0< <(
if [ ! -f "${COVER}" ]; then
  cp ${HOME}/${MPCDIR}/default_cover.png ${COVER}
fi
while inotifywait -q -q -e close_write "${COVER}"; do
  add_cover
done
)

```

This is going to listen for album cover changes and render them.

If no album cover for the current song is found, a default image will be
selected. Be sure to add one named `default_cover.png` in `~/.config/mpcplus/`.

Now create `cover_obs.sh` in the same directory:

```bash
#!/bin/bash

if [ -f ${HOME}/.config/mpcplus/config ]
then
  MPCDIR=".config/mpcplus"
else
  if [ -f ${HOME}/.mpcplus/config ]
  then
    MPCDIR=".mpcplus"
  else
    mpcinit
    MPCDIR=".config/mpcplus"
  fi
fi

COVER="${HOME}/${MPCDIR}/album_cover.png"
COVER_SIZE="400"

mpd_music=`grep ^music_directory /etc/mpd.conf`
if [ "${mpd_music}" ]
then
  MUSIC_DIR=`echo ${mpd_music} | awk ' { print $2 } ' | sed -e "s/\"//g"`
else
  mpd_music=`grep ^mpd_music_dir ${HOME}/${MPCDIR}/config`
  if [ "${mpd_music}" ]
  then
    MUSIC_DIR=`echo ${mpd_music} | awk ' { print $3 } '`
  else
    MUSIC_DIR=${HOME}/Music
  fi
fi

file="${MUSIC_DIR}/$(mpc --format %file% current)"
album="${file%/*}"
art=$(find "${album}"  -maxdepth 1 | grep -m 1 ".*\.\(jpg\|png\|gif\|bmp\)")
if [ "${art}" = "" ]; then
  art="${HOME}/${MPCDIR}/default_cover.png"
fi
ffmpeg -loglevel 0 -y -i "${art}" -vf "scale=${COVER_SIZE}:-1" "${COVER}"

```

This is the script executed when switching songs. It searches for images
in the directory of the current song.

Here I chose a render size of 400 x 400, but it can be anything.

Tell mpcplus to execute it every time the song changes by adding this to
`~/.config/mpcplus/catalog.conf`

```
    execute_on_song_change = "~/.config/mpcplus/cover_obs.sh"
```

And don't forget to make them executable

```
    chmod +x album_cover.sh
    chmod +x cover_obs.sh
```

## Wrapping everything in one window

As mentioned above, we use tmux to run multiple terminal based programs in a
single window so that everything fits nicely (i.e. an instance of `mpcplus`,
an instance of `cava`, and one terminal running our image rendering script).

MusicPlayerPlus includes a command that starts the tmux session and configures
the tmux panes. Start a tmux session displaying `mpcplus`, the `cava` spectrum
visualizer, and album art in separate tmux panes by executing the command:

```
mpcplus-tmux
```

```bash
#!/bin/bash

if [ -f ${HOME}/.config/mpcplus/config ]
then
  MPCDIR=".config/mpcplus"
else
  if [ -f ${HOME}/.mpcplus/config ]
  then
    MPCDIR=".mpcplus"
  else
    mpcinit
    MPCDIR=".config/mpcplus"
  fi
fi

usage() {
  printf "\nUsage: mpcplus-tmux [-a] [-p script] [-r] [-x width] [-y height] [-u]"
  printf "\nWhere:"
  printf "\n\t-a indicates display album cover art"
  printf "\n\t-p script specifies a python script to display ascii art in the visualizer pane"
  printf "\n\t-r indicates record tmux session with asciinema"
  printf "\n\t-x width specifies the width of the spectrum visualizer"
  printf "\n\t-y height specifies the height of the spectrum visualizer"
  printf "\n\t-u displays this usage message and exits\n"
  printf "\nDefaults: width=256 height=9, cover art disabled, ascii art disabled, recording disabled"
  printf "\nThis run:\n\twidth=${WIDTH} height=${HEIGHT}"
  if [ "${ART}" ]
  then
    printf "\n\tcover art enabled"
  else
    printf "\n\tcover art disabled"
  fi
  if [ "${PYART}" ]
  then
    printf "\n\tascii art enabled"
  else
    printf "\n\tascii art disabled"
  fi
  if [ "${RECORD}" ]
  then
    printf "\n\trecording enabled"
  else
    printf "\n\trecording disabled"
  fi
  printf "\nType 'man mpcplus-tmux' for detailed usage info on mpcplus-tmux"
  printf "\nType 'man mpcplus' for detailed usage info on the mpcplus MPD client\n"
  exit 1
}

ART=
PYART=
RECORD=
WIDTH=256
HEIGHT=9
USAGE=
while getopts "ap:rx:y:u" flag; do
    case $flag in
        a)
          have_uebz=`type -p ueberzug`
          [ "${have_uebz}" ] && ART=1
          ;;
        p)
          PYART=${OPTARG}
          ;;
        r)
          have_nema=`type -p asciinema`
          [ "${have_nema}" ] && RECORD=1
          ;;
        x)
          WIDTH=${OPTARG}
          ;;
        y)
          HEIGHT=${OPTARG}
          ;;
        u)
          USAGE=1
          ;;
    esac
done
shift $(( OPTIND - 1 ))

# If both ART and PYART have been specified, disable ART and use PYART
# [ "${ART}" ] && [ "${PYART}" ] && ART=

[ "${ART}" ] && {
  [ ${HEIGHT} -lt 9 ] && HEIGHT=9
}
[ "${PYART}" ] && {
  [ ${HEIGHT} -lt 12 ] && HEIGHT=12
}

[ "${USAGE}" ] && usage

COVER="${HOME}/${MPCDIR}/album_cover.png"
[ -f ${COVER} ] || cp ${HOME}/${MPCDIR}/default_cover.png ${COVER}

tmux new-session -d -x 256 -y 128 -s musicplayerplus
tmux set -g status off

tmux send-keys "stty -echo" C-m
tmux send-keys "tput civis -- invisible" C-m
tmux send-keys "export PS1=''" C-m
tmux send-keys "clear" C-m
[ "${ART}" ] && tmux send-keys "${HOME}/${MPCDIR}/album_cover.sh " C-m

tmux split-window -v
tmux select-pane -t 1
tmux send-keys "mpcplus --config='${HOME}/${MPCDIR}/catalog.conf'" C-m
tmux send-keys 1

tmux select-pane -t 0
[ "${ART}" ] && tmux split-window -h
if [ "${PYART}" ]
then
  have_pyart=`type -p ascii${PYART}`
  [ "${have_pyart}" ] && PYART="ascii${PYART}"
  tmux send-keys "${PYART}" C-m
else
  tmux send-keys "cava -p ${HOME}/${MPCDIR}/config-cava" C-m
fi

tmux resize-pane -t 0 -x ${WIDTH} -y ${HEIGHT}
[ "${ART}" ] && tmux resize-pane -t 1 -y ${HEIGHT}

tmux set-hook client-resized "resize-pane -t 0 -x ${WIDTH} -y ${HEIGHT}"

if [ "${ART}" ]
then
  tmux select-pane -t 2
else
  tmux select-pane -t 1
fi

if [ "${RECORD}" ]
then
  tmux d
  REC_DIR=$HOME/Videos
  [ -d ${REC_DIR} ] || mkdir ${REC_DIR}
  echo "Recording this mpplus session with asciinema"
  asciinema rec --command "tmux attach -t musicplayerplus" ${REC_DIR}/tmux-$(date +%F--%H%M).asciicast
else
  tmux a #
fi
```

Here I used some custom configuration but it's not mandatory.
If you changed the image size from `cover_obs.sh`, you may want
to adjust the pane resize values.

Now simply type `mpcplus-tmux` into the terminal to launch it.

You can take a look at
<a href="https://github.com/doctorfree/MusicPlayerPlus/tree/master/with-cover-art" target="_blank"> the complete config files</a>.
