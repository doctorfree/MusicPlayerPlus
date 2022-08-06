# MusicPlayerPlus

MusicPlayerPlus is a character-based console and terminal window music player
- ***plus*** Beets media library management
- ***plus*** character-based spectrum visualizer `mppcava`
- ***plus*** Music Player Daemon and ALSA configuration management
- ***plus*** Automated audio analysis and audio-based information retrieval
- ***plus*** YAMS MPD Last.fm scrobbler running as a service
- ***plus*** media fuzzy finder using `fzf`
- ***plus*** Bandcamp collections and album cover art download
- ***plus*** Soundcloud account favorites download
- ***plus*** `tmux` sessions managed by `tmuxp`
- ***plus*** `asciimatics` color ASCII animations
- ***plus*** `asciinema` text-based terminal session recording

## Table of contents

1. [Overview](#overview)
    1. [MusicPlayerPlus Commands](#musicplayerplus-commands)
    1. [Main mpcplus MPD client features](#main-mpcplus-mpd-client-features)
1. [Quickstart](#quickstart)
    1. [Quickstart summary](#quickstart-summary)
    1. [Full Tilt Boogie](#full-tilt-boogie)
1. [Installation](#installation)
    1. [Debian package installation](#debian-package-installation)
    1. [RPM Package installation](#rpm-package-installation)
1. [Post Installation Configuration](#post-installation-configuration)
    1. [Client Configuration (required)](#client-configuration-required)
    1. [MPD Music Directory Configuration](#mpd-music-directory-configuration)
    1. [Initializing the Beets media library management system](#initializing-the-beets-media-library-management-system)
    1. [Additional Beets metadata analysis and retrieval](#additional-beets-metadata-analysis-and-retrieval)
    1. [Activating the YAMS scrobbler for Last.fm](#activating-the-yams-scrobbler-for-lastfm)
    1. [MPD Audio Output Configuration](#mpd-audio-output-configuration)
    1. [Fuzzy Finder Configuration](#fuzzy-finder-configuration)
    1. [Start MPD](#start-mpd)
    1. [System verification checks](#system-verification-checks)
    1. [Initialize Music Database](#initialize-music-database)
    1. [Terminal Emulator Profiles](#terminal-emulator-profiles)
1. [Documentation](#documentation)
    1. [README for MusicPlayerPlus configuration](#readme-for-musicplayerplus-configuration)
    1. [README for mpcplus MPD client](#readme-for-mpcplus-mpd-client)
    1. [README for tmuxp configs](#readme-for-tmuxp-configs)
    1. [Man Pages](#man-pages)
    1. [Usage](#usage)
    1. [Example client invocations](#example-client-invocations)
    1. [Adding Album Cover Art](#adding-album-cover-art)
    1. [Custom key bindings](#custom-key-bindings)
    1. [Tmux session exit issues](#tmux-session-exit-issues)
1. [Removal](#removal)
1. [Troubleshooting](#troubleshooting)
    1. [Known issues](#known-issues)
1. [Infrared remote control of MPD](#infrared-remote-control-of-mpd)
1. [Screenshots](#screenshots)
1. [Videos](#videos)
1. [Building MusicPlayerPlus from source](#building-musicplayerplus-from-source)
1. [Contributing](#contributing)
    1. [Testing and Issue Reporting](#testing-and-Issue-Reporting)
    1. [Sponsor MusicPlayerPlus](#sponsor-musicplayerplus)
    1. [Contribute to Development](#contribute-to-development)

## Overview

The MusicPlayerPlus project provides integration and extension of several audio
packages designed to stream and play music. MusicPlayerPlus interacts with the
Music Player Daemon (MPD). Outputs from the MPD streaming audio server are used
as MusicPlayerPlus inputs for playback and visualization. MusicPlayerPlus
components are used to manage and control MPD and ALSA configuration.

MusicPlayerPlus integrations and extensions are primarily aimed at the
character-based terminal user. They enable an easy to use seamlessly
integrated control of audio streaming, playing, music library management,
and visualization in a lightweight character-based environment.

Audio streaming is provided by the Music Player Daemon (MPD).
At the core of MusicPlayerPlus is the `mpplus` command which acts as
a front-end for a variety of terminal and/or `tmux` sessions.

The `mpplus` command can be used to invoke:

* The lightweight character-based MPD client, `mpcplus`
* One or more terminal emulators running an MPD client and visualizer
* A tmux session using the tmux session manager `tmuxp`
* A spectrum visualizer
* A download of album cover art for every album in a music library
* Conversion of all WAV format media in a music library to MP3 format media
* An import of a music library to the Beets media library manager
* A download of lyrics for all songs in the music library without lyrics
* Analysis and retrieval of audio-based information for media matching a query
* YAMS MPD Last.fm scrobbler activation
* Any MPD client the user wishes to run
* One of several asciimatics animations optionally accompanied by audio
* A fuzzy listing and searching of the audio library using `fzf`

Integration is provided for:

* [mpd](https://www.musicpd.org/), the Music Player Daemon
* [mpcplus](mpcplus/README.md), character-based Music Player Plus MPD client
* [beets](https://beets.io/), media library management system
* [yams](https://github.com/Berulacks/yams/), MPD scrobbler for Last.fm
* [cantata](https://github.com/CDrummond/cantata), graphical MPD client
* [cava](https://github.com/karlstav/cava), an audio spectrum visualizer
* [mplayer](http://mplayerhq.hu/design7/info.html), a media player
* [fzf](https://github.com/junegunn/fzf), interactive fuzzy finder
* [asciimatics](https://github.com/peterbrittain/asciimatics) - automatically display a variety of character-based animation effects
* [asciinema](https://asciinema.org/) - automatically create ascii character-based video clips
* [tmux](https://github.com/tmux/tmux/wiki), a terminal multiplexer
* [tmuxp](https://github.com/tmux-python/tmuxp), a tmux session manager
* Enhanced key bindings for extended control of terminal windows and tmux sessions
* Several terminal emulators
    * gnome-terminal
    * tilix
    * cool-retro-term

The goal of MusicPlayerPlus is to provide the user with a sophisticated set
of complex music library tools that can be integrated and managed in a fairly
simple to understand and administer fashion. We wish to make the difficult easy.
Also, to make some cool looking powerful stuff happen from the command-line
in a character-based environment.

### MusicPlayerPlus Commands

MusicPlayerPlus adds the following commands to your system:

* **mpplus** : primary user interface, invokes an MPD client, spectrum visualizer, and more
* **mpcplus** : Featureful NCurses MPD client, compiled with spectrum visualizer
* **mppinit** : one-time initializaton of a user's mpcplus configuration
* **mpcplus-tmux** : runs mpcplus, a visualizer, and displays album art in a tmux session
* **mppsplash-tmux** : runs mppsplash, a visualizer, in a tmux session
* **mppsplash** : fun ascii art screens using ASCIImatics animations. Ascii art commands:
    * **mppjulia** : ASCIImatics animated zoom on a Julia Set
    * **mppplasma** : ASCIImatics animated plasma graphic
    * **mpprocks** : ASCIImatics animated MusicPlayerPlus splash screen
* **raise_cava** : raises the mppcava spectrum visualizer window
* **set_term_trans** : sets an xfce4-terminal window's transparency level
* **fzmp** : browse, search, and manage MPD library using `fzf` fuzzy finder and `mpc` MPD client
* **create_playlist** : create a new playlist using a Beets query

Additional detail and info can be found in the
[MusicPlayerPlus Wiki](https://github.com/doctorfree/MusicPlayerPlus/wiki).

### Main mpcplus MPD client features

* tag editor
* playlist editor
* easy to use search engine
* media library
* integration with external spectrum visualizer
* ability to fetch song lyrics from a variety of sources
* ability to fetch artist info from last.fm
* new display mode
* alternative user interface
* ability to browse and add files from outside of MPD music directory
* cute trick to add album cover art in character display using tmux

## Quickstart

### Required setup

* Create a music library if you do not already have one
    * Default MusicPlayerPlus location for the music library is `$HOME/Music`
    * Recommended structure of the music library is `artist/album/songs`
* Install the latest Debian or RPM format installation package from the [MusicPlayerPlus Releases](https://github.com/doctorfree/MusicPlayerPlus/releases) page
* Run the `mppinit` command as your normal user

### Optional additional setup steps

For many installations, installing the MusicPlayerPlus package and initializing
the user configuration with the `mppinit` command is all that need be done.

Some common additional setup steps that can be performed include:

- Configuring the music library location
- Download albums in your Bandcamp collections
- Download favorites in your Soundcloud account
- Converting WAV format media files to MP3 format
- Importing a music library into the Beets library management system
- Downloading album cover art
- Downloading additional lyrics
- Activation of YAMS scrobbler for Last.fm
- Analysis and retrieval of audio-based information for media matching a query

Configure the music library location by editing `~/.config/mpd/mpd.conf` and
setting the `music_directory` to your music library location (default setting
is `~/Music`). If you change the `music_directory` setting in mpd.conf then
run the command `mppinit sync`.

Download albums in your Bandcamp collections with `mppinit bandcamp`.

Download favorites in your Soundcloud account with `mppinit soundcloud`.

#### Two step post-initialization setup

The following optional post-initialization steps can be performed individually
as described below or they can be performed in two steps using `mppinit`.

**Step 1**, import the music library into Beets:

```
mppinit import
```

The `mppinit import` command converts any WAV format media to MP3 format
and imports the music library into the Beets media library management system.

**[NOTE:]** A Beets import can take hours for a large music library.
A test import using a music library over 500GB in size, with nearly
4000 artists, 3000 albums, and over 30,000 tracks consumed nearly 12 hours.
Import times will vary from system to system and library to library
depending on several factors. The above test may provide a ballpark idea
of the length of time a Beets library import might take.

When the import is complete

**Step 2**, retrieve additional metadata:

```
mppinit metadata
```

The `mppinit metadata` command identifies and deletes duplicate tracks,
retrieves album genres from Last.fm, downloads album cover art, and
(optionally) analyzes and retrieves metadata for all songs in the music library.

**[NOTE:]** A Beets metadata retrieval can take hours for a large music library.
The MusicPlayerPlus default Beets configuration uses `ffmpeg` to compute
checksums for every track in the library to find duplicates.

An optional audio analysis can be performed during metadata retrieval.
MusicPlayerPlus provides several optional methods for acoustic analysis.
The method used for acoustic analysis and retrieval can be specified
on the command line:

- AcousticBrainz metadata retrieval (deprecated)
    - `mppinit -a metadata`
- Blissify acoustic analysis of the MPD music library (the default)
    - `mppinit -b metadata`
- Essentia acoustic analysis and Beets metadata retrieval (long)
    - `mppinit -e metadata`

If none of the `-a, -b, or -e` options are specified then acoustic
analysis, extraction, and retrieval is performed by Blissify.

The AcousticBrainz service is the fastest method but is being retired in
2023, the service is no longer being updated, and it is often inaccurate.

The Essentia acoustic analysis is the most thorough, adds acoustic
metadata to the Beets library management system, and provides the greatest
flexibility but at a cost of possibly days of analysis and extraction time.

The Blissify analysis is the default method employed by `mppinit metadata`.
Blissify creates a similarity database of all songs in the MPD music library.
This can be used to automate the creation of playlists and other actions.
The drawback of using Blissify is it does not add acoustic metadata to
the Beets library so the results of a Blissify analysis are only available
to Blissify and not Beets.

It is sometimes desirable to augment one acoustic analysis with another.
For example, the AcousticBrainz service seems to think a lot of songs
have 0 beets per minute and tags them erroneously. After retrieving
metadata using AcousticBrainz, list the songs that have a bpm value of 0:

```
beet list bpm:0
```

These songs can get an accurate setting for bpm and other audio parameters
by following the `mppinit -a metadata` command with `mpplus -X bpm:0`.

#### Individual commands post-initialization setup

Download albums in your Bandcamp collections with `mppinit bandcamp`.

Download favorites in your Soundcloud account with `mppinit soundcloud`.

Convert WAV format media files in your library to MP3 format files with
the command `mpplus -F`. Conversion from WAV to MP3 allows these files to
be imported into the Beets media library management system.

If you wish to manage your music library with Beets, import the music library
with the command `mpplus -I`.

Album cover art can be downloaded with the command `mpplus -D`.

Download additional lyrics with the command `mpplus -L`.

Activate the YAMS scrobbler for Last.fm with the command `mpplus -Y`.

Analysis and retrieval of audio-based information can be performed with
the command `mpplus -X 'query'` where 'query' is a Beets library query.
The special query term 'all' indicates the entire music library, i.e.
`mpplus -X all`. Alternatively, query the AcousticBrainz service with
`mpplus -x all` or create a "song similarity" database using Blissify
with `mpplus -B`.

These common additional setup steps and more are covered in greater
detail in the [MusicPlayerPlus Beets README](beets/README.md) and the
[Post Installation Configuration](#post-installation-configuration)
section below.

### Quickstart summary

To summarize, a MusicPlayer quickstart can be accomplished by:

* Install the latest Debian or RPM format installation package
* Run the `mppinit` command as your normal user
* If the music library is not located at `$HOME/Music`:
    * Configure the `music_directory` setting by editing `~/.config/mpd/mpd.conf`
    * Run the command `mppinit sync`
* Optionally:
    * Download albums in your Bandcamp collections with `mppinit bandcamp`
    * Download favorites in your Soundcloud account with `mppinit soundcloud`
    * Perform these steps with the command `mppinit import`
        * Convert WAV format files to MP3 format with the command `mpplus -F`
        * Import your music library into Beets with the command `mpplus -I`
    * Perform these steps with the command `mppinit metadata`
        * Remove duplicate tracks with the command `beet duplicates -d`
        * Rename tracks left after duplicate removal with `beet move`
        * Download album cover art with the command `mpplus -D`
        * Analyze and retrieve audio-based information with a command like:
		    * `mpplus -B` creates a "song similarity" database with Blissify
            * `mpplus -X all` analyze the entire Beets library with Essentia
            * `mpplus -X 'query'` where 'query' is a Beets library query
            * `mpplus -x all` query AcousticBrainz for the entire Beets library
    * Activate the YAMS scrobbler for Last.fm with the command `mpplus -Y`
    * Download additional lyrics with the command `mpplus -L`

### Full Tilt Boogie

The entire full tilt boogie initialization, for those with both Bandcamp
and Soundcloud accounts with songs and albums in a collection or liked,
and who wish to apply thorough, reliable, complete, and accurate metadata,
might go something like:

```
mppinit
mppinit bandcamp
mppinit soundcloud
mppinit import
# One of the acoustic analyses supported by MusicPlayerPlus
mppinit -a metadata # AcousticBrainz analysis is faster but flawed
mppinit -b metadata # Blissify analysis is faster but no Beets support
mppinit -e metadata # Essentia analysis is thorough but may take days
```

## Installation

MusicPlayerPlus v1.0.0 and later can be installed on Linux systems using
either the Debian packaging format or the Red Hat Package Manager (RPM).

### Debian package installation

Many Linux distributions, most notably Ubuntu and its derivatives, use the
Debian packaging system.

To tell if a Linux system is Debian based it is usually sufficient to
check for the existence of the file `/etc/debian_version` and/or examine the
contents of the file `/etc/os-release`.

To install on a Debian based Linux system, download the latest Debian format
package from the
[MusicPlayerPlus Releases](https://github.com/doctorfree/MusicPlayerPlus/releases).

Install the MusicPlayerPlus package by executing the command

```console
sudo apt install ./MusicPlayerPlus_<version>-<release>.amd64.deb
```
or
```console
sudo dpkg -i ./MusicPlayerPlus_<version>-<release>.amd64.deb
```

or, on a Raspberry Pi:

```console
sudo apt install ./MusicPlayerPlus_<version>-<release>.armhf.deb
```
or
```console
sudo dpkg -i ./MusicPlayerPlus_<version>-<release>.armhf.deb
```

**NOTE:** In some cases you may see a warning message when installing the
Debian package. The message:

Repository is broken: musicplayerplus:amd64 (= <version-<release>) has no Size information

can safely be ignored. This is an issue with the Debian packaging system
and has no effect on the installation.

### RPM Package installation

Red Hat Linux, SUSE Linux, and their derivatives use the RPM packaging
format. RPM based Linux distributions include Fedora, AlmaLinux, CentOS,
openSUSE, OpenMandriva, Mandrake Linux, Red Hat Linux, and Oracle Linux.

To install on an RPM based Linux system, download the latest RPM format
package from the
[MusicPlayerPlus Releases](https://github.com/doctorfree/MusicPlayerPlus/releases).

Install the MusicPlayerPlus package by executing the command

```console
sudo yum localinstall ./MusicPlayerPlus_<version>-<release>.x86_64.rpm
```
or
```console
sudo rpm -i ./MusicPlayerPlus_<version>-<release>.x86_64.rpm
```

## Post Installation Configuration

**[NOTE:]** Extensive post-installation steps are covered here.
Minimal post-installation configuration required is the execution
of the command `mppinit`. If the MPD music library is located in
the default `$HOME/Music` directory then no further configuration
may be necessary. See the [Quickstart](#quickstart) section.

After installing MusicPlayerPlus there are several recommended
configuration steps. If not already configured, the MPD server
will need to know where to locate your music library. This can
be configured by editing the MPD configuration file `~/.config/mpd/mpd.conf`.

Following any modification of the music library location in
`~/.config/mpd/mpd.conf` execute `mppinit sync`.

### Client Configuration (required)

Initialize the `mpcplus` client configuration by executing the command:

```
mppinit
```

Examine the generated `mpcplus` configuration in `~/.config/mpcplus/config`
and `~/.config/mpcplus/bindings` and make any desired changes.

The client configuration performed by `mppinit` includes the configuration
of an MPD user service. The configuration, files, and folders used by
this user level MPD service are stored in `~/.config/mpd/`. Examine the
generated MPD configuration file `~/.config/mpd/mpd.conf`.

### MPD Music Directory Configuration

**NOTE:** MusicPlayerPlus version 1.0.3 release 1 and later perform
an automated MPD user configuration and systemd service activation.
This is performed by the `mppinit` command. MusicPlayerPlus 1.0.3r1
and later installations need not perform the following manual procedures
but users may wish to review the automated MPD configuration and alter
the default MPD music directory location.

The default MPD and `mpcplus` music directory is set to:

`$HOME/Music`

If your media library resides in another location then perform the following
steps and run `mppinit sync`:

* Edit `$HOME/.config/mpd/mpd.conf` and set the `music_directory` entry to the location of your music library (e.g. `vi ~/.config/mpd/mpd.conf`)
* Run the `mppinit sync` command

For example, to set the MPD music directory to the `/u/audio/music` directory,
edit `$HOME/.config/mpd/mpd.conf` and change the *music_directory* setting:

```
music_directory		"/u/audio/music"
```

The *music_directory* location must be writeable by your user.

Any time the MPD music directory is manually modified, run `mppinit sync`.

### Initializing the Beets media library management system

**[NOTE:]** Beets is NOT the now defunct music service purchased by Apple.
It is an open source media library management system.

MusicPlayerPlus includes the Beets media library management system
and preconfigured settings to allow easy integration with MPD and `mpcplus`.
Beets is an application that catalogs your music collection, automatically
improving its metadata. It then provides a suite of tools for manipulating
and accessing your music. Beets includes an extensive set of plugins that
can be used to enhance and extend the functionality of the media library
management Beets provides. Many Beets plugins are installed and configured
automatically by MusicPlayerPlus.

To get started using the Beets media library management system, it is
necessary to import your music library into the Beets database. This process
catalogs your music collection and improves its metadata. The default
Beets configuration provided by MusicPlayerPlus moves and tags files in the
music library during this process. It adds music library data to the Beets
database. To import your music library into Beets, issue the following command:

```
mppinit import
```

or to skip WAV format media conversion and just perform the Beets import:

```
mpplus -I
```

Try playing something with a command like:

```
beet play QUERY
```

Where 'QUERY' is a valid
[Beets query](https://beets.readthedocs.io/en/stable/reference/query.html).
This can be a simple string like
"blue" or "love" or a more complicated expression as described in the
Beets query documentation. The Beets `play` plugin should match the
query string to songs in your music library, add those songs to the
MPD queue, and play them. Use `beet ls QUERY` to see what would be played.

**[NOTE:]** MusicPlayerPlus has configured the Beets play plugin
to use the command `/usr/share/musicplayerplus/scripts/mpcplay.sh`
to play media with this plugin. This script clears the MPD queue,
adds any songs matching the query to the queue, and plays the MPD queue.
In addition, two arguments are supported: `--shuffle` and `--debug`.
These additional arguments are passed using the `--args` feature.
For example, to play all media matching the string "velvet" and shuffle
the order of play, issue the command `beet play --args --shuffle velvet`.

Example usage of the `beet play` command:

* `beet play velvet`
* `beet play playlist:1970s`
* `beet play --args --shuffle playlist:1990s`
* `beet play --args "--debug --shuffle" green eyes`

For instructions on Beets media library setup and use see the
[MusicPlayerPlus Beets README](beets/README.md).

Learn more about the Beets media library management system at
https://beets.io/

### Additional Beets metadata analysis and retrieval

After completing the Beets music library import with either `mppinit import`
or `mpplus -I`, additional Beets metadata can be retrieved with the command:

```
mppinit metadata
```

This will identify and delete duplicate tracks, retrieve album genres,
download album cover art, and optionally analyze and retrieve metadata
for all songs in the music library using the
[Essentia extractor](https://essentia.upf.edu/index.html) and
[Essentia trained models](https://essentia.upf.edu/models.html).

MusicPlayerPlus uses Essentia for extracting acoustic characteristics
of music, including low-level spectral information, rhythm, keys, scales,
and much more, and automatic annotation by genres, moods, and instrumentation.

This is the same sort of thing that
[AcousticBrainz](https://acousticbrainz.org/) does but the AcousticBrainz
project is no longer collecting data and will be withdrawn in 2023.
MusicPlayerPlus provides the same functionality using pre-compiled and
packaged Essentia binaries and models.

However, the process of analyzing, extracting, and retrieving metadata
can be time consuming for a large music library. The `mppinit metadata`
command performs several metadata retrieval steps in a non-interactive
manner and in the background so it can be left unattended if desired.

The individual metadata retrieval steps performed automatically by
`mppinit metadata` can be performed manually using the instructions in
the [MusicPlayerPlus Beets README](beets/README.md).

### Activating the YAMS scrobbler for Last.fm

YAMS is an acronym for "Yet Another MPD Scrobbler".
When YAMS is configured and running, any songs, artists, or albums
played through MPD get "scrobbled" to [Last.fm](https://www.last.fm).
This enables a tracking of your listening patterns and habits,
creating a fairly extensive set of statistics viewable on Last.fm.

Features:

- Authenticate with the new Last.fm Scrobbling API v2.0 - without the need to input/store your username/password locally.
- Update your profile's "Now Playing" track via Last.fm's "Now Playing" API
- Save failed scrobbles to a disk and upload them at a later date.
- Timing configuration (e.g. scrobble percentage, real world timing values for scrobbling, etc.).
- Prevent accidental duplicate scrobbles on rewind/playback restart/etc.
- Automatic daemonization and config file generation.

In order to activate the YAMS scrobbler you will need an account with Last.fm.
Free accounts with Last.fm include many of the service features and can
provide extensive listening history statistics. If you do not wish to
use Last.fm to analyze MPD track plays then this optional setup step
can be ignored and no action is required as MusicPlayerPlus disables
YAMS by default. Disable a previously activated YAMS service with the
command `mpplus -y`.

Activate the YAMS scrobbler for Last.fm with the command:

```
mpplus -Y
```

The activation process must be run in a terminal window and will provide
you with a URL. Copy the URL and navigate to it using a web browser.
This will take you to Last.fm to authenticate if not already logged in
and authorize YAMS access. Once access is authorized there is no need
to authenticate for future Last.fm access with YAMS. There is also no
need to manually run the `yams` command as a user service is activated
to run it automatically. Basically, nothing else to do, just play music
and it will be scrobbled by YAMS.

YAMS creates a configuration file `$HOME/.config/yams/yams.yml`.

#### Using YAMScrobbler with Libre.fm

YAMS works fine with Libre.fm, a Free Software replacement for Last.fm.
If you prefer to use Libre.fm rather than Last.fm, do the following:

- Set the `base_url` config variable to `https://libre.fm/2.0/` in `$HOME/.config/yams/yams.yml` (don't forget the trailing slash!)
- Delete any leftover `.lastfm_session` files
- Authenticate like you normally would with Last.fm, however replace `last.fm` with `libre.fm` in the authorization URL printed out by YAMS

### MPD Audio Output Configuration

Adjust the `audio_output` settings in `~/.config/mpd/mpd.conf`.
MPD must have at least one `audio_output` configured and in order
to use the spectrum visualizer as configured by default it is necessary
to configure a second `audio_output` in MPD.

A FIFO `audio_output` is used as a data source for the spectrum visualizer.
To configure this output, add the following to `~/.config/mpd/mpd.conf`:

```
audio_output {
    type            "fifo"
    name            "Visualizer feed"
    path            "~/.config/mpd/mpd.fifo"
    format          "44100:16:2"
}
```

An example ALSA `audio_output` configuration in `~/.config/mpd/mpd.conf`:

```
audio_output {
	type		"alsa"
	name		"My ALSA Device"
    buffer_time "50000"   # (50ms); default is 500000 microseconds (0.5s)
#	device		"hw:0,0"	# optional
#	mixer_type      "hardware"      # optional
#	mixer_device	"default"	# optional
#	mixer_control	"PCM"		# optional
#	mixer_index	"0"		# optional
}
```

Or, to use PulseAudio:

```
audio_output {  
    type  "pulse"  
    name  "pulse audio"
    device         "pulse" 
    mixer_type      "hardware" 
}  
```

Output with PipeWire can also be configured:

```
audio_output {
    type  "pipewire"
    name  "PipeWire Sound Server"
}
```

MPD is a powerful and flexible music player server with many configuration
options. Additional MPD configuration may be desired. See the
[MPD User's Manual](https://mpd.readthedocs.io/en/stable/user.html)

### Fuzzy Finder Configuration

The `fzmp` command lists, searches, and selects media from the MPD
library using the `fzf` fuzzy finder command line utility. A default
`fzmp` configuration file for each user is created when the `mppinit`
command is executed. The `fzmp` configuration file is located at:

```
~/.config/mpcplus/fzmp.conf
```

The initial default `fzmp` configuration should suffice for most use cases.
Some of the interactive key bindings may need to be modified if they are
already in use by other utilities. For example, the default key binding to
switch to playlist view is 'F1' but the `xfce4-terminal` command binds 'F1'
by default to its help window. In this case either the `fzmp` playlist view
key binding must be changed or the XFCE4 terminal help window shortcut must
be disabled.

To disable the XFCE4 terminal help window shortcut, in `xfce4-terminal` select:

*Edit -> Preferences -> Advanced*

Select the *Disable help window shortcut key (F1 by default)* and Close
the Preferences dialog. The XFCE4 terminal help window shortcut will no
longer be bound to 'F1' and no modification to the playlist view key binding
for `fzmp` would be necessary.

To modify the `fzmp` playlist view key binding, edit the `fzmp` configuration
file `~/.config/mpcplus/fzmp.conf` and add a line like the following:

```
playlist_view_key F6
```

This revised configuration would change the playlist view key binding from
'F1' to 'F6' and the XFCE4 terminal help window shortcut could remain enabled
and bound to 'F1'.

Several other `fzmp` bindings and options can be configured. See `man fzmp`
for details.

### Start MPD

**NOTE:** MusicPlayerPlus version 1.0.3 release 1 and later perform
an automated MPD user configuration and systemd service activation.
Initialization with `mppinit` for these installations should automatically
start the user MPD service. No further action should be required for
MusicPlayerPlus v1.0.3r1 or later installations.

Status of the MPD service can be checked with:

```
systemctl --user status mpd.service
```

Installation and initialization of MusicPlayerPlus prior to v1.0.3r1
will need to start mpd as a system-wide service by executing the commands:

`sudo systemctl start mpd`

If you want MPD to start automatically on subsequent reboots, run:

`sudo systemctl enable mpd`

Alternatively, if you want MPD to start automatically when a client
attempts to connect:

`sudo systemctl enable mpd.socket`

### System verification checks

Once the music directory has been set correctly, album art downloaded,
music library imported, and `mppinit sync` has completed initialization,
some system checks can optionally be performed.

* Verify the `mpd` service is running and if not then start it:
    * `systemctl --user is-active mpd.service`
    * `systemctl --user start mpd.service`
* Update the MPD client database:
    * `mpc update`
* Verify the `mpd` service is enabled and if not enable it
    * `systemctl --user is-enabled mpd.service`
    * `systemctl --user enable mpd.service`
* Play music with `mpplus`
    * See the [online mpcpluskeys cheat sheet](https://github.com/doctorfree/MusicPlayerPlus/wiki/mpcpluskeys.1) or `man mpcpluskeys` for help navigating the `mpplus` windows
    * See the [online mpplus man page](https://github.com/doctorfree/MusicPlayerPlus/wiki/mpplus.1) or `man mpplus` for different ways to invoke the `mpplus` command

### Initialize Music Database

**NOTE:** MusicPlayerPlus version 1.0.3 release 1 and later perform an
automated MPD music database initialization during execution of `mppinit`.

For versions of MusicPlayerPlus prior to v1.0.3r1, initialize the music
database with an MPD client and update the database. The `mpcplus` MPD
client can be used for this or the standard `mpc` MPD client can be used.
With `mpcplus`, launch the `mpcplus` MPD client, verify the client window
has focus, and type `u` to update the database. With `mpc` simply execute
the command `mpc update`.

If your music library is very large this process can take several minutes
to complete. Once the music database has been updated you should see the
songs, albums, and playlists in your music library appear in the client view.

### Terminal Emulator Profiles

The `mppcava` spectrum visualizer looks better when the font used by the
terminal emulator in which it is running is a small sized font. Some
terminal emulators rely on a profile from which they draw much of
their configuration. Profiles are used in MusicPlayerPlus to provide
an enhanced visual presentation.

There are four terminal profiles in two terminal emulators used by
MusicPlayerPlus. The `gnome-terminal` emulator and the `tilix` terminal
emulator each have two custom profiles created during `mppinit` initialization.
These profiles are named "MusicPlayer" and "Visualizer".

The custom MusicPlayerPlus terminal profiles are used to provide font sizes
and background transparencies that enhance the visual appeal of both the
MusicPlayerPlus control window and the spectrum visualizer. 

To modify these terminal emulator profiles, launch the desired terminal
emulator and modify the desired profile in the Preferences dialog.

## Documentation

All MusicPlayerPlus commands have manual pages. Execute `man <command-name>`
to view the manual page for a command. The `mpplus` frontend is the primary
user interface for MusicPlayerPlus and the manual page for `mpplus` can be
viewed with the command `man mpplus`. Most commands also have
help/usage messages that can be viewed with the **-u** argument option,
e.g. `mpplus -u`.

### README for MusicPlayerPlus configuration
- [**config/README.md**](config/README.md) - Overview and details of the MusicPlayerPlus configuration

### README for mpcplus MPD client
- [**mpcplus/README.md**](mpcplus/README.md) - Introduction to the mpcplus MPD client

### README for tmuxp configs
- [**config/tmuxp/README.md**](config/tmuxp/README.md) - How to invoke the MusicPlayerPlus provided `tmuxp` session configurations

### Man Pages

- [**mpplus**](markdown/mpplus.1.md) : Primary MusicPlayerPlus user interface
- [**mppcava**](markdown/mppcava.1.md) : Audio Spectrum Visualizer
- [**mppjulia**](markdown/mppjulia.1.md) : asciimatics animation of a Julia Set
- [**mpprocks**](markdown/mpprocks.1.md) : asciimatics animation of MusicPlayerPlus intro
- [**mppplasma**](markdown/mppplasma.1.md) : asciimatics animation with Plasma effect
- [**mppinit**](markdown/mppinit.1.md) : MusicPlayerPlus initialization
- [**mpcplus-tmux**](markdown/mpcplus-tmux.1.md) : MusicPlayerPlus in a tmux session
- [**mpcplus**](markdown/mpcplus.1.md) : MusicPlayerPlus MPD client
- [**mpcpluskeys**](markdown/mpcpluskeys.1.md) : Cheat sheet for `mpcplus` MPD client navigation
- [**mppsplash-tmux**](markdown/mppsplash-tmux.1.md) : MusicPlayerPlus asciimatics animations in a tmux session
- [**mppsplash**](markdown/mppsplash.1.md) : MusicPlayerPlus asciimatics animations
- [**beet**](markdown/beet.1.md) : Beets media library management command-line interface
- [**beetsconfig**](markdown/beetsconfig.5.md) : Beets media library management configuration
- [**bandcamp-dl**](markdown/bandcamp-dl.1.md) : Download Bandcamp collections
- [**scdl**](markdown/scdl.1.md) : Download Soundcloud favorites
- [**fzmp**](markdown/fzmp.1.md) : List and search MPD media using fuzzy find
- [**create_playlist**](markdown/create_playlist.1.md) : Create playlists using Beets queries

### Usage

The usage messages for `mppinit`, `mpplus`, `mpcplus`, and `mppcava`
provide a brief summary of the command line options:

```
Usage: mppinit [-a] [-b] [-d] [-e] [-o] [-q] [-U] [-y] [-u] [bandcamp|import|metadata|soundcloud|sync|yams]
Where:
	'-a' use AcousticBrainz for acoustic audio analysis (deprecated)
	'-b' use Blissify for MPD acoustic audio analysis (default)
	'-d' install latest Beets development branch rather than
		the latest stable release (for testing purposes)
	'-e' use Essentia for Beets acoustic audio analysis (long)
	'-o' indicates overwrite any pre-existing configuration
	'-q' indicates quiet execution, no status messages
	'-U' indicates upgrade installed Python modules if needed
	'-y' indicates answer 'yes' to all and proceed
	'-u' displays this usage message and exits

	'bandcamp' downloads all albums in your Bandcamp collections
	'import' performs a Beets music library import
	'metadata' performs a library metadata update
	'soundcloud' downloads all favorites in your Soundcloud account
	'sync' synchronizes the music library location across configs
	'yams' activates the YAMS Last.fm scrobbler service

'mppinit' must be run prior to sync, metadata, bandcamp, soundcloud, or import
Only one of bandcamp, soundcloud, import, metadata, or sync can be specified
```

```
Usage: mpplus [-A] [-a] [-b] [-B] [-c] [-C client] [-D] [-d music_directory]
		[-g] [-F] [-f] [-h] [-I] [-i] [-jJ] [-k] [-L] [-m] [-n num]
		[-M alsaconf|enable|disable|restart|start|stop|status] [-N]
		[-p] [-P script] [-q] [-r] [-R] [-s song] [-S] [-t] [-T] [-u]
		[-v viz_comm] [-w|W] [-x query] [-X query] [-y] [-Y] [-z fzmpopt]
MPCplus/Visualizer options:
	-A indicates display album cover art (implies tmux session)
	-c indicates use cantata MPD client rather than mpcplus
	-C 'client' indicates use 'client' MPD client rather than mpcplus
	-f indicates fullscreen display
	-g indicates do not use gradient colors for spectrum visualizer
	-h indicates half-height for visualizer window (with -f only)
	-P script specifies the ASCIImatics script to run in visualizer pane
	-q indicates quarter-height for visualizer window (with -f only)
	-r indicates use retro terminal emulator
	-t indicates use tilix terminal emulator
	-v 'viz_comm' indicates use visualizer 'viz_comm' rather than mppcava
ASCIImatics animation options:
	-a indicates play audio during ASCIImatics display
	-b indicates use backup audio during ASCIImatics display
	-j indicates use Julia Set scenes in ASCIImatics display
	-J indicates Julia Set with several runs using different parameters
	-m indicates use MusicPlayerPlus scenes in ASCIImatics display
	-n num specifies the number of times to cycle ASCIImatics scenes
	-N indicates use alternate comments in Plasma ASCIImatics scenes
	-p indicates use Plasma scenes in ASCIImatics display
	-s song specifies a song to accompany an ASCIImatics animation
		'song' can be the full pathname to an audio file or a
		relative pathname to an audio file in the MPD music library
		or $HOME/Music/
	-S indicates display ASCIImatics splash animation
General options:
	-B indicates analyze MPD music dir with Blissify and exit
	-D indicates download album cover art and exit
	-d 'music_directory' specifies the music directory to use for
		downloaded album cover art (without this option -D will use
		the 'music_directory' setting in '~/.config/mpd/mpd.conf'
	-F indicates convert all WAV format files in the music library
		to MP3 format files and exit. A subsequent 'mpplus -I' import
		will be necessary to import these newly converted music files.
	-I indicates import albums and songs from 'music_directory' to beets and exit
		In conjunction with '-I', the '-A' flag disables auto-tagging
	-i indicates start mpplus in interactive mode
	-k indicates kill MusicPlayerPlus tmux sessions and ASCIImatics scripts
	-L indicates download lyrics to the Beets library and exit
	-M 'action' can be used to control the Music Player Daemon (MPD)
	    or configure the ALSA sound system
		ALSA configuration will update the ALSA configuration in '/etc/asound.conf'
	-R indicates record tmux session with asciinema
	-T indicates use a tmux session for either ASCIImatics or mpcplus
	-w indicates write metadata during beets import
	-W indicates do not write metadata during beets import
	-x 'query' uses AcousticBrainz to retrieve audio-based information
		for all music library media matching 'query'. A query
		of 'all' performs the retrieval on the entire music library.
	-X 'query' performs an analysis and retrieval, using Essentia,
		of audio-based information for all music library media
		matching 'query'. A query of 'all' performs the analysis
		and retrieval on the entire music library.
	-Y initializes the YAMS last.fm scrobbler service
	-y disables the YAMS last.fm scrobbler service
	-z fzmpopt specifies the fzmp option and invokes fzmp to
		list/search/select media in the MPD library.
		Valid values for fzmpopt are 'a', 'A', 'g', 'p', or 'P'
	-u displays this usage message and exits
```

```
Usage: mpcplus [options]...
Options:
  -h [ --host ] HOST (=localhost)       connect to server at host
  -p [ --port ] PORT (=6600)            connect to server at port
  --current-song [=FORMAT(={{{(%l) }{{%a - }%t}}|{%f}})]
                                        print current song using given format 
                                        and exit
  -c [ --config ] PATH (=~/.config/mpcplus/config AND ~/.mpcplus/config)
                                        specify configuration file(s)
  --ignore-config-errors                ignore unknown and invalid options in 
                                        configuration files
  --test-lyrics-fetchers                check if lyrics fetchers work
  -b [ --bindings ] PATH (=~/.config/mpcplus/bindings AND ~/.mpcplus/bindings)
                                        specify bindings file(s)
  -s [ --screen ] SCREEN                specify the startup screen
  -S [ --slave-screen ] SCREEN          specify the startup slave screen
  -? [ --help ]                         show help message
  -v [ --version ]                      display version information
  -q [ --quiet ]                        suppress logs and excess output
```

The mpcplus MPD client has an extensive set of key bindings that allow
quick and easy control of MPD, searches, lyrics display, client navigation,
and much more via the keyboard. View the
[**mpcpluskeys man page**](markdown/mpcpluskeys.1.md) with the command
`man mpcpluskeys`.

```
Usage: mppsplash [-A] [-a] [-b] [-C] [-c num] [-d] [-jJ] [-m] [-p] [-s song] [-u]
Where:
	-A indicates use all effects
	-a indicates play audio during ASCIImatics display
	-b indicates use backup audio during ASCIImatics display
	-C indicates use alternate comments in Plasma effect
	-c num specifies the number of times to cycle
	-d indicates enable debug mode
	-j indicates use Julia Set effect
	-J indicates Julia Set with several runs using different parameters
	-m indicates use MusicPlayerPlus effect
	-p indicates use Plasma effect
	-s song specifies the audio file to play as accompaniment
		'song' can be the full pathname to an audio file or a relative
		pathname to an audio file in the MPD music library or
		$HOME/Music/
	-u displays this usage message and exits
```

```
Usage : mppcava [options]
Visualize audio input in terminal. 

Options:
    -p          path to config file
    -v          print version

Keys:
        Up        Increase sensitivity
        Down      Decrease sensitivity
        Left      Decrease number of bars
        Right     Increase number of bars
        r         Reload config
        c         Reload colors only
        f         Cycle foreground color
        b         Cycle background color
        q         Quit

All options are specified in a config file. See `$HOME/.config/mppcava/config`
```

### Example client invocations
The `mpplus` command is intended to serve as the primary interface to invoke
the `mpcplus` MPD client and `mppcava` spectrum visualizer. The `mpplus` command
utilizes several different terminal emulators and can also be used to invoke
any specified MPD client. Some example invocations of `mpplus` follow.

Open the mpcplus client and spectrum visualizer in fullscreen mode:

`mpplus -f`

Open the mpcplus client and mppcava visualizer in fullscreen mode using the
tilix terminal emulator and displaying the visualizer using quarter-height:

`mpplus -f -q -t`

Open the cantata MPD graphical client and mppcava visualizer:

`mpplus -c`

Open the mpcplus client in the cool-retro-term terminal and mppcava visualizer
in gnome-terminal:

`mpplus -r`

Browse, list, search, and select media in the MPD library using the
`fzf` fuzzy finder utility.

Search artist then filter by album using `fzf`:

`mpplus -z a`

Search all songs in the library using `fzf`:

`mpplus -z A`

Search the current playlist using `fzf`:

`mpplus -z p`

The mpcplus MPD client can be opened directly without using mpplus.
Similarly, the mppcava spectrum visualizer can be opened directly without mpplus.

`mpcplus` # In one terminal window

`mppcava` # In another terminal window

To test the mpcplus lyrics fetchers:

`mpcplus --test-lyrics-fetchers`

### Adding Album Cover Art

The `mpcplus` MPD client is a character-based application. As such, it is
difficult to display graphical images. However, this limitation can be
overcome using `tmux` and additional tools. In this way we can add album
cover art to MusicPlayerPlus when using the character-based `mpcplus` client.

See [Adding album art to MusicPlayerPlus](config/README.md) to get
started integrating album art in MusicPlayerPlus.

An album cover art downloader is included in MusicPlayerPlus. To download
cover art for all of the albums in your MPD music directory, run the command:

```
mpplus -D
```

Cover art for each album is saved as the file `cover.jpg` in the album folder.
Existing cover art is preserved.

### Custom key bindings

A few custom key bindings are configured during MusicPlayerPlus initialization
with the `mppinit` command. These are purely for convenience and can be altered or
removed if desired.

Tmux custom key bindings are defined in `$HOME/.tmux.conf`.
MusicPlayerPlus custom key bindings for tmux sessions include the following:

-   `[ Alt-PgDn ]`     - Next window
-   `[ Shift-Right ]`  - Next window
-   `[ Alt-PgUp ]`     - Previous window
-   `[ Shift-Left ]`   - Previous window
-   `[ Alt-x ]`        - Prompt to kill session
-   `[ Alt-X ]`        - Kill session
-   `[ Alt-Left ]`     - Move pane focus to left
-   `[ Alt-Right ]`    - Move pane focus to right
-   `[ Alt-Up ]`       - Move pane focus up
-   `[ Alt-Down ]`     - Move pane focus down
-   `[ Prefix q ]`     - Prompt to kill session
-   `[ Prefix Q ]`     - Kill session

The tmux prefix key is remapped from `Ctrl-b` to `Ctrl-a` and the status bar
is configured to display a `Ctrl` message when the prefix key is pressed.

The MusicPlayerPlus tmux customization enables tmux mouse mode. The mouse can
be used to select and resize tmux panes and windows.

There are hundreds of tmux key bindings. To view the currently configured
tmux key bindings, execute the command `tmux list-keys`.

Custom key bindings are also defined for the `mpcplus` music player client command.
Mpcplus custom key bindings are defined in `$HOME/.config/mpcplus/bindings`.
MusicPlayerPlus custom key bindings for `mpcplus` include the following:

-   `[ Alt-f ]` - Open the fuzzy finder to search/select media
-   `[ Alt-r ]` - Raise/lower the spectrum visualizer window
-   `[ Alt-1 ]` - Set xfce4-terminal window transparency to 90%
-   `[ Alt-2 ]` - Set xfce4-terminal window transparency to 80%
-   `[ Alt-3 ]` - Set xfce4-terminal window transparency to 70%
-   `[ Alt-4 ]` - Set xfce4-terminal window transparency to 60%
-   `[ Alt-5 ]` - Set xfce4-terminal window transparency to 50%
-   `[ Alt-6 ]` - Set xfce4-terminal window transparency to 40%
-   `[ Alt-7 ]` - Set xfce4-terminal window transparency to 30%
-   `[ Alt-8 ]` - Set xfce4-terminal window transparency to 20%
-   `[ Alt-9 ]` - Set xfce4-terminal window transparency to 10%
-   `[ Alt-0 ]` - Set xfce4-terminal window 100% opaque

#### Tmux session exit issues

In addition to the `Alt-x` and `Alt-X` key bindings above to kill the current
tmux session, MusicPlayerPlus tmux key bindings include `Ctrl-a q` and
`Ctrl-a Q` which also are mapped to `kill-session` in a similar manner. This
is because some terminal emulators, in particular iTerm2, may already have key
bindings for the `Alt` key or the Meta key may be something other than `Alt`.

In a MusicPlayerPlus tmux session, if `Alt-x` and `Alt-X` do not initiate
a `kill-session` then use the configured tmux prefix key (e.g. `Ctrl-a`)
followed by `q` or `Q` to exit the current tmux session.

If a MusicPlayerPlus tmux session has been initiated over SSH using the
Terminal app on macOS then it may be necessary to configure the Terminal
profile in use to "Use Option as Meta key" in order to recognize the custom
tmux key bindings using the `Alt` key. To configure the Terminal app profile
in this manner, go to `Terminal -> Preferences -> Profiles`. Select the 
profile you are using (usually "Basic Default") and select the `Keyboard` tab.
Click the "Use Option as Meta key" checkbox and exit Terminal preferences.

## Removal

On Debian based Linux systems where the MusicPlayerPlus package was installed
using the MusicPlayerPlus Debian format package, remove the MusicPlayerPlus
package by executing the command:

```console
    sudo apt remove musicplayerplus
```
or
```console
    sudo dpkg -r musicplayerplus
```

On RPM based Linux systems where the MusicPlayerPlus package was installed
using the MusicPlayerPlus RPM format package, remove the MusicPlayerPlus
package by executing the command:

```console
    sudo yum remove MusicPlayerPlus
```
or
```console
    sudo rpm -e MusicPlayerPlus
```

The MusicPlayerPlus package can be removed by executing the "Uninstall"
script in the MusicPlayerPlus source directory:

```console
    git clone https://github.com/doctorfree/MusicPlayerPlus.git
    cd MusicPlayerPlus
    ./Uninstall
```

## Troubleshooting
Many problems encountered with MusicPlayerPlus often resolve to problems with
the underlying Linux audio configuration. As a first step in troubleshooting,
verify the audio subsystem is functioning properly. Most systems use either
ALSA or PulseAudio and there are numerous audio test guides available.

MusicPlayerPlus includes a convenience script to test the ALSA audio subsystem.
The command `alsa_audio_test` can be run to test your ALSA audio setup.
If successful you will hear the test output of the `aplay` command.
To view a `alsa_audio_test` usage message and current ALSA configuration
settings, run the command `alsa_audio_test -u`

Another source of problems to investigate is the Music Player Daemon (MPD).
This is the music streaming server that MusicPlayerPlus connects to. MPD
is run as a system service that runs automatically. You can check the status
of the MPD service by running the command `systemctl --user status mpd`.
You can restart the MPD service with `systemctl --user restart mpd.service`.
If the issue is not resolved by a restart or reboot, check the MPD log file
at `$HOME/.config/mpd/log` looking for recent failures and exceptions.

It may be the case that the root of a problem is a missing dependency.
MusicPlayerPlus should have installed any missing dependencies but one
may have been overlooked, improperly installed, or subsequently removed.
If the system logs or error output indicates something was "not found"
then check for its existence. On Debian based systems there is a nice
repository package index maintained. If a command was not found, it is
often possible to simply type that command at a shell prompt and the
Debian packaging system will be searched for any packages that contain
a command with that name. If a likely looking package is returned, the
problem may be solved by installing that package.

Finally, see the Troubleshooting section of the
[MusicPlayerPlus Wiki](https://github.com/doctorfree/MusicPlayerPlus/wiki).
for additional troubleshooting techniques and commonly resolved issues.

If an issue cannot be resolved and all troubleshooting efforts have
failed, open an issue at
[MusicPlayerPlus issues](https://github.com/doctorfree/MusicPlayerPlus/issues).
Even if you do manage to resolve an issue, it may still be helpful to
report the issue at https://github.com/doctorfree/MusicPlayerPlus/issues
so that a fix may be incorporated in the next release.

### Known issues

#### Tmux key bindings in iTerm2 terminal emulator

The `iTerm2` terminal emulator has built-in support for tmux. Several of
the iTerm2 built-in tmux key bindings conflict with and override the default
tmux key bindings and the MusicPlayerPlus custom tmux key bindings.

Unless you are quite familiar with iTerm2 and its tmux implementation, we do
not recommend using iTerm2 with MusicPlayerPlus when running tmux sessions.

MusicPlayerPlus support for iTerm2 may be forthcoming in future releases but
at this time iTerm2 is not a supported MusicPlayerPlus terminal emulator.

#### Tmux sessions over SSH to Fedora systems

A tmux session initiated over SSH to a Fedora Linux system may size the
tmux panes incorrectly. This issue is not yet understood but will hopefully
be addressed in a future release of MusicPlayerPlus. If, for example, a
`mpplus` or `mpcplus-tmux` tmux session displays the `mpcplus` pane with
a small height while the spectrum visualizer pane consumes most of the session
window, then the `mpcplus` pane will need to be resized manually.

Tmux panes can be resized either using keyboard shortcuts or with the mouse.

To resize the `mpcplus` tmux pane using the mouse, click and drag the bottom
of the upper pane in the session window. Drag the pane border down until the
`mpcplus` display of music media appears.

To resize the `mpcplus` tmux pane using keyboard shortcuts, use one of the
default tmux key bindings:

```
bind-key -r -T prefix       M-Up              resize-pane -U 5
bind-key -r -T prefix       M-Down            resize-pane -D 5
bind-key -r -T prefix       M-Left            resize-pane -L 5
bind-key -r -T prefix       M-Right           resize-pane -R 5
bind-key -r -T prefix       C-Up              resize-pane -U
bind-key -r -T prefix       C-Down            resize-pane -D
bind-key -r -T prefix       C-Left            resize-pane -L
bind-key -r -T prefix       C-Right           resize-pane -R
```

This means you can resize a pane by `<prefix>` `Alt ↓` (tmux prefix followed
by "Alt-DownArrow"). The default MusicPlayerPlus tmux prefix is `Ctrl-a` so in
order to resize the `mpcplus` pane using the keyboard, type `Ctrl-a` then type
`Alt ↓`. You can repeat `Alt ↓` several times without needing to re-type the
`Ctrl-a` prefix if you type it fast enough (about a second). If the display of 
`Ctrl` on the tmux status line disappears and you still need to resize the
`mpcplus` pane, then you will need to re-type the prefix key `Ctrl-a`.

This issue has only been detected on Fedora Linux over SSH. However, it may
occur with other systems and may not be exclusive to either SSH or Fedora.

## Infrared remote control of MPD

Advanced users may wish to add remote control capabilities to MusicPlayerPlus.
Getting IR remote control of MPD working is pretty geeky and fun. Also cool.

This can be accomplished on most Linux systems using LIRC (Linux Infrared
Remote Control). LIRC setup and usage is described at
https://wiki.archlinux.org/title/LIRC

To get started, see the
[ArchLinux Step-by-step LIRC setup guide](https://wiki.archlinux.org/title/LIRC/Quick_start_guide)
for USB IR receiver with universal remote control.

The only prerequisites are a USB IR receiver, preferably an MCE model, and
an old universal remote control you have lying around the house.

A long list of LIRC supported remotes with corresponding LIRC configurations
can be found at the
[LIRC Remotes Databass](http://lirc-remotes.sourceforge.net/remotes-table.html).


The hard part is getting the remote control device talking to the IR receiver
since there are a number of different protocols and devices supported.
The LIRC setup guide linked above has pretty good step-by-step procedures for
establishing communication between the remote and the receiver.

Once the hardware is successfully communicating, you can control MPD with `lirc`
and `mpc` by configuring lirc. For example, add the following to `~/.lircrc`:

```
## irexec
begin
     prog = irexec
     button = play_pause
     config = mpc toggle
     repeat = 0
end

begin
     prog = irexec
     button = stop
     config = mpc stop
     repeat = 0
end
begin
     prog = irexec
     button = previous
     config = mpc prev
     repeat = 0
end
begin
     prog = irexec
     button = next
     config = mpc next
     repeat = 0
end
begin
     prog = irexec
     button = volup
     config = mpc volume +2
     repeat = 1
end
begin
     prog = irexec
     button = voldown
     config = mpc volume -2
     repeat = 1
end
begin
     prog = irexec
     button = pbc
     config = mpc random
     repeat = 0
end
begin
     prog = irexec
     button = pdvd
     config = mpc update
     repeat = 0
end
begin
     prog = irexec
     button = right
     config = mpc seek +00:00:05
     repeat = 0
end
begin
     prog = irexec
     button = left
     config = mpc seek -00:00:05
     repeat = 0
end
begin
     prog = irexec
     button = up
     config = mpc seek +1%
     repeat = 0
end
begin
     prog = irexec
     button = down
     config = mpc seek -1%
     repeat = 0
end
```

A guide for configuring `lirc` to control MPD using `mpc` can be found at
https://wiki.archlinux.org/title/Music_Player_Daemon/Tips_and_tricks#Control_MPD_with_lirc

## Screenshots

<p float="left">
  <img src="screenshots/mpplus-tilix.png" style="width:800px;height:600px;">
  <img src="screenshots/mpplus-lyrics.png" style="width:800px;height:600px;">
</p>

## Videos

- [![MusicPlayerPlus Intro](https://i.imgur.com/UH2A21h.png)](https://www.youtube.com/watch?v=r7XLA9tO45Q "MusicPlayerPlus ASCIImatics Intro")
- [![MusicPlayerPlus Demo](https://i.imgur.com/ZntE1sH.jpg)](https://www.youtube.com/watch?v=y2yaHm04ELM "MusicPlayerPlus Demo")

## Building MusicPlayerPlus from source

### Clone MusicPlayerPlus repository

```
git clone https://github.com/doctorfree/MusicPlayerPlus.git
cd MusicPlayerPlus
```

### Install build dependencies

MusicPlayerPlus components have build dependencies on the following:

* libtool
* automake
* build-essentials
* [Boost library](https://www.boost.org/)
* [NCurses library](http://www.gnu.org/software/ncurses/ncurses.html)
* [Readline library](https://tiswww.case.edu/php/chet/readline/rltop.html)
* [Curl library](https://curl.haxx.se/)
* [fftw library](http://www.fftw.org/)
* [tag library](https://taglib.org/)
* [iniparser](https://github.com/ndevilla/iniparser)
* [ALSA dev files](http://alsa-project.org/)
* [Pulseaudio dev files](http://freedesktop.org/software/pulseaudio/doxygen/)
* [Eigen](http://eigen.tuxfamily.org/)
* [Gaia](https://github.com/MTG/gaia)
* [libavcodec/libavformat/libavutil/libswresample](http://ffmpeg.org/)
* [libsamplerate](http://www.mega-nerd.com/SRC/)
* [LibYAML](http://pyyaml.org/wiki/LibYAML)
* [Chromaprint](https://github.com/acoustid/chromaprint)
* [TensorFlow](https://tensorflow.org/)

On Debian based systems like Ubuntu Linux, install build dependencies via:

```
./install-dev-env.sh
```

or manually with:

```
sudo apt-get install \
    build-essential libeigen3-dev libfftw3-dev clang \
    libavcodec-dev libavformat-dev libavutil-dev libswresample-dev \
    libsamplerate0-dev libtag1-dev libchromaprint-dev libmpdclient-dev \
    autotools-dev autoconf libtool libboost-all-dev fftw-dev \
    libiniparser-dev libyaml-dev swig python3-dev pkg-config \
    libncurses-dev libasound2-dev libreadline-dev libpulse-dev \
    libcurl4-openssl-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
    libavfilter-dev libavdevice-dev libsqlite3-dev
```

On RPM based systems like Fedora Linux, install build dependencies via:

```
./install-dev-env.sh
```

or manually with:

```
sudo dnf install alsa-lib-devel ncurses-devel fftw3-devel \
     pulseaudio-libs-devel libtool automake iniparser-devel \
     SDL2-devel eigen3-devel libyaml-devel clang-devel \
     ffmpeg-devel libchromaprint-devel python-devel \
     python3-devel python3-yaml python3-six sqlite-devel
```

It is necessary to build and install Gaia from source:

```
./build-gaia.sh -i
```

### Install packaging dependencies

MusicPlayerPlus components have packaging dependencies on the following:

On Debian based systems like Ubuntu Linux, install packaging dependencies via:

```
sudo apt install dpkg
```

On RPM based systems like Fedora Linux, install packaging dependencies via:

```
sudo dnf install rpm-build rpm-devel rpmlint rpmdevtools
```

### Build and package MusicPlayerPlus

On Debian based systems like Ubuntu Linux, build and package MusicPlayerPlus via:

```
./mkdeb
```

On RPM based systems like Fedora Linux, build and package MusicPlayerPlus via:

```
./mkrpm
```

### Install MusicPlayerPlus from source build

After successfully building and packaging MusicPlayerPlus with either
`./mkdeb` or `./mkrpm`, install the MusicPlayerPlus package with the command:

```
./Install
```

## Contributing

There are a variety of ways to contribute to the MusicPlayerPlus project.
All forms of contribution are appreciated and valuable. Also, it's fun to
collaborate. Here are a few ways to contribute to the further improvement
and evolution of MusicPlayerPlus:

### Testing and Issue Reporting

MusicPlayerPlus is fairly complex with many components, features, options,
configurations, and use cases. Although currently only supported on
Linux platforms, there are a plethora of Linux platforms on which
MusicPlayerPlus can be deployed. Testing all of the above is time consuming
and tedious. If you have a Linux platform on which you can install
MusicPlayerPlus and you have the time and will to put it through its paces,
then issue reports on problems you encounter would greatly help improve the
robustness and quality of MusicPlayerPlus. Open issue reports at
[https://github.com/doctorfree/MusicPlayerPlus/issues](https://github.com/doctorfree/MusicPlayerPlus/issues)

### Sponsor MusicPlayerPlus

MusicPlayerPlus is completely free and open source software. All of the
MusicPlayerPlus components are freely licensed and may be copied, modified,
and redistributed freely. Nobody gets paid, nobody is making any money,
it's a project fully motivated by curiousity and love of music. However,
it does take some money to procure development and testing resources.
Right now MusicPlayerPlus needs a multi-boot test platform to extend support
to a wider variety of Linux platforms and potentially Mac OS X.

If you have the means and you would like to sponsor MusicPlayerPlus development,
testing, platform support, and continued improvement then your monetary
support could play a very critical role. A little bit goes a long way
in MusicPlayerPlus. For example, a bootable USB SSD device could serve as a 
means of porting and testing support for additional platforms. Or, a
decent cup of coffee could be the difference between a bug filled
release and a glorious musical adventure.

Sponsor the MusicPlayerPlus project at
[https://github.com/sponsors/doctorfree](https://github.com/sponsors/doctorfree)

### Contribute to Development

If you have programming skills and find the management and ease-of-use of
digital music libraries to be an interesting area, you can contribute to
MusicPlayerPlus development through the standard Github "fork, clone,
pull request" process. There are many guides to contributing to Github hosted
open source projects on the Internet. A good one is available at
[https://www.dataschool.io/how-to-contribute-on-github/](https://www.dataschool.io/how-to-contribute-on-github/). Another short succinct guide is at
[https://gist.github.com/MarcDiethelm/7303312](https://gist.github.com/MarcDiethelm/7303312).

Once you have forked and cloned the MusicPlayerPlus repository, it's time to
setup a development environment. Although many of the MusicPlayerPlus commands
are Bash shell scripts, there are also applicatons written in C and C++ along
with documentation in Markdown format, configuration files in a variety of
formats, examples, screenshots, video demos, build scripts, packaging, and more.

The development environment consists of several packages needed to build,
package, and test MusicPlayerPlus components. These include:

```
    build-essential libeigen3-dev libfftw3-dev clang
    libavcodec-dev libavformat-dev libavutil-dev libswresample-dev
    libsamplerate0-dev libtag1-dev libchromaprint-dev libmpdclient-dev
    autotools-dev autoconf libtool libboost-all-dev fftw-dev
    libiniparser-dev libyaml-dev swig python3-dev pkg-config
    libncurses-dev libasound2-dev libreadline-dev libpulse-dev
    libcurl4-openssl-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools
    libavfilter-dev libavdevice-dev libsqlite3-dev
```

Utilities and applications built from source in MusicPlayerPlus include:

- essentia audio analysis and extraction
- gaia audio similarity and classification library
- mpcplus character based MPD client
- mppcava character based spectrum visualizer

The build scripts in the top-level directory of the MusicPlayerPlus repository
can be used to compile essentia, gaia, mpcplus, and mppcava. These are:

- build-essentia.sh
- build-gaia.sh
- build-mpcplus.sh
- build-mppcava.sh

Invoke the appropriate build script for the utility you wish to compile.
For example, to compile the MPD client `mpcplus` from source, run the command:

```
./build-mpcplus.sh
```

On Debian and RPM based systems the MusicPlayerPlus installation package can be
created with the `mkdeb` and `mkrpm` scripts. These scripts invoke the build
scripts for each of the projects included with MusicPlayerPlus, populate a
distribution tree, and call the respective packaging utilities. Packages are
saved in the `./releases/<version>/` folder. Once a package has been created
it can be installed with the `Install` script.

It's not necessary to have C/C++ expertise to contribute to MusicPlayerPlus
development. Many of the MusicPlayerPlus commands are Bash scripts and require
no compilaton. Script commands reside in the `bin` and `share/scripts`
directories. To modify a shell script, install MusicPlayerPlus and edit the
`bin/<script>` or `share/scripts/<script.sh>` you wish to improve. After making
your changes simply copy the revised script to `/usr/bin` and test your changes.

Modifying the configuration files is a little more tricky. Configuration
files generally live in the `config` directory but each has its own installation
location and some are modified by the `mppinit` command during installation.
If you are just modifying the shell scripts or configuration files then
you don't need to worry about the extensive list of dependencies listed above.

Feel free to email me at github@ronrecord.com with questions or comments.
