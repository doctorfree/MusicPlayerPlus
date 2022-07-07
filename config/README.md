# Adding album art to MusicPlayerPlus

**MusicPlayerPlus** includes the really nice character based mpd client
**mpcplus**. It has all the functionality one would need, but sadly it
has no built-in way of showing album art for the current playing song
as rendering images via a terminal emulator is pretty tricky.

Here you will learn how to include album art in your mpcplus client and
include the mppcava spectrum visualizer while browsing songs. Luckily, you
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
`~/.config/mpcplus/config-art.conf`

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
an instance of `mppcava`, and one terminal running our image rendering script).

MusicPlayerPlus includes commands that start a tmux session and configures
the tmux panes. Start a tmux session displaying `mpcplus`, the `mppcava` spectrum
visualizer, and album art in separate tmux panes by executing the command:

```
mpcplus-tmux
```

You can take a look at
<a href="https://github.com/doctorfree/MusicPlayerPlus/tree/master/config" target="_blank"> the complete config files</a>.
