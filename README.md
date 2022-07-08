# MusicPlayerPlus

Character based console and terminal window music player ***plus*** album cover art
***plus*** media fuzzy finder using `fzf` ***plus*** `tmux` sessions managed by `tmuxp`
***plus*** character based spectrum visualizer `mppcava` ***plus*** Music Player Daemon
and ALSA configuration management ***plus*** `asciimatics` animations ***plus***
`asciinema` text-based terminal session recording.

The MusicPlayerPlus project provides integration and extension of several audio
packages designed to stream and play music. MusicPlayerPlus interacts with the
Music Player Daemon (MPD). Outputs from the MPD streaming audio server are used
as MusicPlayerPlus inputs for playback and visualization. MusicPlayerPlus
components are used to manage and control MPD and ALSA configuration.

## Table of contents

1. [Overview](#overview)
    1. [MusicPlayerPlus Commands](#musicplayerplus-commands)
    1. [Main mpcplus MPD client features](#main-mpcplus-mpd-client-features)
1. [Quickstart](#quickstart)
1. [Requirements](#requirements)
1. [Installation](#installation)
    1. [Debian package installation](#debian-package-installation)
    1. [RPM Package installation](#rpm-package-installation)
1. [Post Installation Configuration](#post-installation-configuration)
    1. [Client Configuration](#client-configuration)
    1. [MPD Server Configuration](#mpd-server-configuration)
    1. [Fuzzy Finder Configuration](#fuzzy-finder-configuration)
    1. [Start MPD](#start-mpd)
    1. [Initialize Music Database](#initialize-music-database)
    1. [Terminal Emulator Profiles](#terminal-emulator-profiles)
1. [Documentation](#documentation)
    1. [README for mpcplus MPD client](#readme-for-mpcplus-mpd-client)
    1. [Man Pages](#man-pages)
    1. [Usage](#usage)
    1. [Example client invocations](#example-client-invocations)
    1. [Adding Album Cover Art](#adding-album-cover-art)
    1. [Custom key bindings](#custom-key-bindings)
1. [Removal](#removal)
1. [Troubleshooting](#troubleshooting)
1. [Screenshots](#screenshots)
1. [Videos](#videos)

## Overview

MusicPlayerPlus integrations and extensions are primarily aimed at the
character based terminal user. They enable an easy to use seamlessly
integrated control of audio streaming, playing, and visualization in
a lightweight character based environment.

Audio streaming is provided by the Music Player Daemon (MPD).
At the core of MusicPlayerPlus is the `mpplus` command which acts as
a front-end for a variety of terminal and/or `tmux` sessions.

The `mpplus` command can be used to invoke:

* The lightweight character based MPD client, `mpcplus`
* One or more terminal emulators running an MPD client and visualizer
* A tmux session using the tmux session manager `tmuxp`
* A spectrum visualizer
* Any MPD client the user wishes to run
* One of several asciimatics animations optionally accompanied by audio
* A fuzzy listing and searching of the audio library using `fzf`

Integration is provided for:

* [mpd](https://www.musicpd.org/), the Music Player Daemon
* [mpcplus](mpcplus/README.md), character based Music Player Plus MPD client
* [cantata](https://github.com/CDrummond/cantata), graphical MPD client
* [cava](https://github.com/karlstav/cava), an audio spectrum visualizer
* [mplayer](http://mplayerhq.hu/design7/info.html), a media player
* [asciimatics](https://github.com/peterbrittain/asciimatics) - automatically display a variety of character based animation effects
* [asciinema](https://asciinema.org/) - automatically create ascii character based video clips
* [tmux](https://github.com/tmux/tmux/wiki), a terminal multiplexer
* [tmuxp](https://github.com/tmux-python/tmuxp), a tmux session manager
* Enhanced key bindings for extended control of terminal windows and tmux sessions
* Several terminal emulators
    * gnome-terminal
    * tilix
    * cool-retro-term
* [fzf](https://github.com/junegunn/fzf), interactive fuzzy finder

### MusicPlayerPlus Commands

MusicPlayerPlus adds the following commands to your system:

* **mpplus** : primary user interface, invokes an MPD client, spectrum visualizer, and more
* **mpcplus** : Featureful NCurses MPD client, compiled with spectrum visualizer
* **mpcinit** : one-time initializaton of a user's mpcplus configuration
* **mpcplus-tmux** : runs mpcplus, a visualizer, and displays album art in a tmux session
* **mppsplash-tmux** : runs mppsplash, a visualizer, in a tmux session
* **mppsplash** : fun ascii art screens using ASCIImatics animations. Ascii art commands:
    * **mppjulia** : ASCIImatics animated zoom on a Julia Set
    * **mppplasma** : ASCIImatics animated plasma graphic
    * **mpprocks** : ASCIImatics animated MusicPlayerPlus splash screen
* **raise_cava** : raises the mppcava spectrum visualizer window
* **set_term_trans** : sets an xfce4-terminal window's transparency level
* **download_cover_art** : automatically downloads cover album art for your entire music directory
* **fzmp** : browse, search, and manage MPD library using `fzf` fuzzy finder and `mpc` MPD client

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

* Install the latest Debian or RPM format installation package from the [MusicPlayerPlus Releases](https://github.com/doctorfree/MusicPlayerPlus/releases) page
* Run the `mpcinit` command (must be done as your normal user, no need for `sudo`)
* Edit `$HOME/.config/mpd/mpd.conf` and set the `music_directory` entry to the location of your music library (e.g. `vi ~/.config/mpd/mpd.conf`)
* Verify the `mpd` service is running and if not then start it:
    * `systemctl --user is-active mpd.service`
    * `systemctl --user start mpd.service`
* Update the MPD client database:
    * `mpc update`
* Optionally, verify the `mpd` service is enabled and if not enable it
    * `systemctl --user is-enabled mpd.service`
    * `systemctl --user enable mpd.service`
* Play music with `mpplus`
    * See the [online mpcpluskeys cheat sheet](https://github.com/doctorfree/MusicPlayerPlus/wiki/mpcpluskeys.1) or `man mpcpluskeys` for help navigating the `mpplus` windows
    * See the [online mpplus man page](https://github.com/doctorfree/MusicPlayerPlus/wiki/mpplus.1) or `man mpplus` for different ways to invoke the `mpplus` command

## Requirements

MusicPlayerPlus can be installed on Debian or RPM based Linux systems.
It requires:

* [MPD Music Player Daemon](https://www.musicpd.org/)
* [Boost library](https://www.boost.org/)
* [NCurses library](http://www.gnu.org/software/ncurses/ncurses.html)
* [Readline library](https://tiswww.case.edu/php/chet/readline/rltop.html)
* [Curl library](https://curl.haxx.se/)
* [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell))

These dependencies will all be automatically installed if not present
when MusicPlayerPlus is installed using the Debian or RPM packaging.

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
After installing MusicPlayerPlus there are several recommended
configuration steps. If not already configured, the MPD server
will need to know where to locate your music library. This can
be configured by editing the MPD configuration file `~/.config/mpd/mpd.conf`.

Minimal post installation configuration required is the execution
of the command `mpcinit`.

### Client Configuration
Initialize the `mpcplus` client configuration by executing the command:

```
mpcinit
```

Examine the generated `mpcplus` configuration in `~/.config/mpcplus/config`
and `~/.config/mpcplus/bindings` and make any desired changes.

The client configuration performed by `mpcinit` includes the configuration
of an MPD user service. The configuration, files, and folders used by
this user level MPD service are stored in `~/.config/mpd/`. Examine the
generated MPD configuration file `~/.config/mpd/mpd.conf`.

### MPD Server Configuration

**NOTE:** MusicPlayerPlus version 1.0.3 release 1 and later perform
an automated MPD user configuration and systemd service activation.
This is performed by the `mpcinit` command. MusicPlayerPlus 1.0.3r1
and later installations need not perform the following manual procedures
but users may wish to review the automated MPD configuration by
following these steps.

Edit `~/.config/mpd/mpd.conf`, uncomment the `music_directory` entry and
set the value to the location of your music library. For example,

```
music_directory		"~/.config/mpd/music"
```

The `music_directory` location must be writeable by your user.

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
`fzmp` configuration file for each user is created when the `mpcinit`
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
Initialization with `mpcinit` for these installations should automatically
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

### Initialize Music Database
**NOTE:** MusicPlayerPlus version 1.0.3 release 1 and later perform an
automated MPD music database initialization during execution of `mpcinit`.

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
The Cava spectrum visualizer looks better when the font used by the
terminal emulator in which it is running is a small sized font. Some
terminal emulators rely on a profile from which they draw much of
their configuration. Profiles are used in MusicPlayerPlus to provide
an enhanced visual presentation.

There are four terminal profiles in two terminal emulators used by
MusicPlayerPlus. The `gnome-terminal` emulator and the `tilix` terminal
emulator each have two custom profiles created during `mpcinit` initialization.
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

### README for mpcplus MPD client
- [**mpcplus/README.md**](mpcplus/README.md) - Introduction to the mpcplus MPD client

### Man Pages

- [**mpplus**](markdown/mpplus.1.md) : Primary MusicPlayerPlus user interface
- [**mppcava**](markdown/mppcava.1.md) : Audio Spectrum Visualizer
- [**mppjulia**](markdown/mppjulia.1.md) : asciimatics animation of a Julia Set
- [**mpprocks**](markdown/mpprocks.1.md) : asciimatics animation of MusicPlayerPlus intro
- [**mppplasma**](markdown/mppplasma.1.md) : asciimatics animation with Plasma effect
- [**mpcinit**](markdown/mpcinit.1.md) : MusicPlayerPlus initialization
- [**mpcplus-tmux**](markdown/mpcplus-tmux.1.md) : MusicPlayerPlus in a tmux session
- [**mpcplus**](markdown/mpcplus.1.md) : MusicPlayerPlus MPD client
- [**mpcpluskeys**](markdown/mpcpluskeys.1.md) : Cheat sheet for `mpcplus` MPD client navigation
- [**mppsplash-tmux**](markdown/mppsplash-tmux.1.md) : MusicPlayerPlus asciimatics animations in a tmux session
- [**mppsplash**](markdown/mppsplash.1.md) : MusicPlayerPlus asciimatics animations
- [**fzmp**](markdown/fzmp.1.md) : List and search MPD media using fuzzy find

### Usage

The usage messages for `mpplus`, `mpcplus`, and `mppcava` provide a brief
summary of the command line options:

```
Usage: mpplus [-A] [-a] [-b] [-c] [-C client] [-D] [-d music_directory]
		[-f] [-h] [-i] [-jJ] [-k] [-m]
		[-M alsaconf|enable|disable|restart|start|stop|status]
		[-n num] [-N] [-p] [-P script] [-q] [-r] [-R] [-s song]
		[-S] [-t] [-T] [-u] [-v viz_comm] [-z fzmpopt]
MPCplus/Visualizer options:
	-A indicates display album cover art (implies tmux session)
	-c indicates use cantata MPD client rather than mpcplus
	-C 'client' indicates use 'client' MPD client rather than mpcplus
	-f indicates fullscreen display
	-i indicates start mpplus in interactive mode
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
	-D indicates download album cover art
	-d 'music_directory' specifies the music directory to use for
		downloaded album cover art (without this option -D will use
		the 'music_directory' setting in '~/.config/mpd/mpd.conf'
	-k indicates kill MusicPlayerPlus tmux sessions and ASCIImatics scripts
	-M 'action' can be used to control the Music Player Daemon (MPD)
	    or configure the ALSA sound system
		ALSA configuration will update the ALSA configuration in '/etc/asound.conf'
	-R indicates record tmux session with asciinema
	-T indicates use a tmux session for either ASCIImatics or mpcplus
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
The `mpcplus` MPD client is a character based application. As such, it is
difficult to display graphical images. However, this limitation can be
overcome using `tmux` and additional tools. In this way we can add album
cover art to MusicPlayerPlus when using the character based `mpcplus` client.

See [Adding album art to MusicPlayerPlus](config/README.md) to get
started integrating album art in MusicPlayerPlus.

An album cover art downloader is included in MusicPlayerPlus. To download
cover art for all of the albums in your MPD music directory, run the command:

```
download_cover_art
```

or, alternately,

```
mpplus -d
```

Cover art for each album is saved as the file `cover.jpg` in the album folder.
Existing cover art is preserved.

### Custom key bindings

A few custom key bindings are configured during MusicPlayerPlus initialization
with the `mpcinit` command. These are purely for convenience and can be altered or
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

The tmux prefix key is remapped from `Ctrl-b` to `Ctrl-a` and the status bar
is configured to display a `Ctrl` message when the prefix key is pressed.

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
    git clone git@github.com:doctorfree/MusicPlayerPlus.git
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

## Screenshots

<p float="left">
  <img src="screenshots/mpplus-tilix.png" style="width:800px;height:600px;">
  <img src="screenshots/mpplus-lyrics.png" style="width:800px;height:600px;">
</p>

## Videos

- [![MusicPlayerPlus Intro](https://i.imgur.com/UH2A21h.png)](https://www.youtube.com/watch?v=r7XLA9tO45Q "MusicPlayerPlus ASCIImatics Intro")
- [![MusicPlayerPlus Demo](https://i.imgur.com/ZntE1sH.jpg)](https://www.youtube.com/watch?v=y2yaHm04ELM "MusicPlayerPlus Demo")
