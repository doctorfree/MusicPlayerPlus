---
title: MPPRC
section: 5
header: User Manual
footer: musicplayerplus 3.0.1
date: January 20, 2023
---
## NAME
mpprc - MusicPlayerPlus configuration

## DESCRIPTION

The MusicPlayerPlus configuration file `$HOME/.config/mpprc` contains user configurable settings for the MusicPlayerPlus music library, MPD client, music services, album cover art display, and other settings controlling the system. It acts as a centralized point of configuration for all of the MusicPlayerPlus components. Thus, when a change is made to any of the `mpprc` settings, it should be followed by executing the command `mppinit sync`. The `mppinit sync` command populates the settings in `mpprc` out to the various configuration files used by the MusicPlayerPlus components.

A brief description of each of the settings in `mpprc` follows.

**General settings**

*Music library*

The full path to the location of the music library.

```shell
MUSIC_DIR="~/Music"
```

*MPD client*

The name of the Music Player Daemon client to use.

```shell
MPD_CLIENT="mpcplus"
```

*MusicPlayerPlus initialization*

Whether MusicPlayerPlus has been initialized with `mppinit`. This setting is automatically configured by `mppinit`.

```shell
MPPINIT=
```

*Asciimatics audio*

Whether to play audio during `asciimatics` animations.

```shell
AUDIO=1
```

*Display album cover art*

Whether to display album cover art along with the MPD client and spectrum visualizer.

```shell
COVER_ART=1
```

*Display in a tmux session*

Whether to use `tmux` to display the MPD client, visualizer, and album cover art. This setting may be ignored depending on the mode.

```shell
USE_TMUX=1
```

*Terminal emulator / display mode*

Which terminal emulator or display mode to use.

Can be one of: `console`, `current`, `gnome`, `kitty`, `retro`, `simple`, `tilix`

Where:

- 'console' will force a tmux session
- 'current' will force a tmux session in the current terminal window
- 'gnome' will use the gnome-terminal emulator if installed
- 'kitty' will use the Kitty terminal emulator if installed
- 'retro' will use cool-retro-term if installed
- 'simple' will use the ST terminal emulator if installed
- 'tilix' will use the Tilix terminal emulator if installed

Default fallback if none specified or not available is `kitty`

Uncomment the preferred mode

```shell
#MPP_MODE=console
#MPP_MODE=current
#MPP_MODE=gnome
#MPP_MODE=retro
#MPP_MODE=simple
#MPP_MODE=tilix
MPP_MODE=kitty
```

**Service access settings**

*Bandcamp username*

The Bandcamp username can be found by visiting Bandcamp 'Settings' -> 'Fan'

If you do not have a Bandcamp account, leave blank

```shell
BANDCAMP_USER=
```

*Discogs settings*

The Discogs username can be found by visiting discogs.com. Login, use the dropdown of your user icon in the upper right corner, click on 'Profile'.  Your Discogs username is the last component of the profile URL.

```shell
DISCOGS_USER=
```
The Discogs API token can be found by visiting https://www.discogs.com/settings/developers

```shell
DISCOGS_TOKEN=
```
Location of the generated custom Discogs Obsidian vault

Can be anywhere you have write permission

```shell
DISCOGS_DIR="~/Documents/Obsidian/Discogs"
```

*Last.fm settings*

Your Last.fm username, api key, and api secret

If you do not have a Last.fm account, leave blank

```shell
LASTFM_USER=
LASTFM_APIKEY=
LASTFM_SECRET=
```

*Soundcloud slug*

The Soundcloud user slug can be found by logging in to Soundcloud

Click on the username at top right then 'Profile'. The user slug is the last component of the URL when viewing your Soundcloud Profile.

If you do not have a Soundcloud account, leave blank

```shell
SOUNDCLOUD_SLUG=
```

*Spotify settings*

Your Spotify client id and client secret

If you do not have a Spotify account, leave blank

```shell
SPOTIFY_CLIENT=
SPOTIFY_SECRET=
```

*YouTube API key*

Your YouTube api key

If you do not have a YouTube account, leave blank

```shell
YOUTUBE_APIKEY=
```

**Album cover art settings**

*Album cover art position*

Album cover art is positioned within the preferred terminal window with padding values hard coded in the cover art display script. These padding values are customized for each of the supported terminal emulators. The default padding values should suffice but they can be overriden here. To override the padding values, set `OVERRIDE_PADDING=1` and set any or all of
the `padding_override_*` values to adjust album cover art placement.

See `~/.config/mpcplus/ueberzug/mpcplus_cover_art.sh` for default padding values.
 
Set to 1 to override default padding, leave unset to use custom defaults

```shell
OVERRIDE_PADDING=
# Uncomment any or all and set preferred padding value(s)
# padding_override_top=3
# padding_override_bottom=1
# padding_override_right=0
# padding_override_left=1
```

*Album cover art font size*

The font size in pixels is set to 22x45 for album cover art display. To override this, set OVERRIDE_FONT_SIZE=1 and adjust the font width and/or font height in pixels to match your system.

```shell
OVERRIDE_FONT_SIZE=
# Uncomment either or both and set font width and/or font height value(s)
# font_override_width=22
# font_override_height=45
```

## AUTHORS

Written by Ronald Record github@ronrecord.com

## LICENSING

MPPRC is distributed under an Open Source license.
See the file LICENSE in the MPPRC source distribution
for information on terms &amp; conditions for accessing and
otherwise using MPPRC and for a DISCLAIMER OF ALL WARRANTIES.

## BUGS

Submit bug reports online at:

https://github.com/doctorfree/MusicPlayerPlus/issues

## SEE ALSO

**mpplus**(1), **mppinit**(1)

Full documentation and sources at:

https://github.com/doctorfree/MusicPlayerPlus

