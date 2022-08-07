---
title: MPPLUS
section: 1
header: User Manual
footer: mpplus 2.0.1
date: December 05, 2021
---
# NAME
mpplus - Launch an MPD music player client and spectrum visualizer

# SYNOPSIS
**mpplus** [-A] [-a] [-b] [-B] [-C client] [-D] [-d music_directory] [-g] [-F] [-f] [-h] [-I] [-i] [-jJ] [-k] [-L] [-m] [-n num] [-M alsaconf|enable|disable|restart|start|stop|status] [-N] [-p] [-P script] [-q] [-r] [-R] [-s song] [-S] [-t] [-T] [-u] [-v viz_comm] [-w|W] [-x query] [-X query] [-y] [-Y] [-z fzmpopt]

# DESCRIPTION
The *mpplus* command acts as a front-end for launching the mpcplus music player client and a spectrum visualizer in various terminal emulators and window placements. It can be used to display these utilities juxtaposed in separate windows or fullscreen overlayed with transparency. Alternately, mpplus can launch any specified MPD client along with a specified spectrum visualizer (`mppcava` spectrum visualizer is used by default). Command line options also support running the *mpplus* windows in a tmux session and recording that session using *asciinema*.

The *mpplus* command can be used to control the *mpd* and *mpd.socket* system services when invoked with the `-M action` command line option. The Music Player Daemon (MPD) can be started, stopped, enabled, disabled, restarted, and status queried.

The *mpplus* command can also act as a front-end to the *mppsplash* and *mppsplash-tmux* commands when invoked with the `-S` and `-T` command line options.

The *mpplus* command can be used in conjunction with the Beets music library management system:

- When invoked as `mpplus -D` it will downlad album cover art for all albums in the music library
- When invoked as `mpplus -F` it will convert all WAV format files in the music library to MP3 format files
- When invoked as `mpplus -I` it will perform a Beets library import of all songs and albums in the music library. If a previous import has been performed it will import any new songs or albums it finds in the music library.
- When invoked as `mpplus -L` it will downlad lyrics for all songs in the music library that do not already have lyrics

When invoked with the `-i` option, `mpplus` presents a selection menu and operates in interactive mode.

Occasionally a tmux session or asciimatics script will hang. Previously started tmux sessions and asciimatics scripts can be quickly and easily killed by executing the `mpplus -k` command.

# COMMAND LINE OPTIONS

*MPCplus/Visualizer options:*

**-A**
: indicates display album cover art (implies tmux session)

**-C 'client'**
: indicates use 'client' MPD client rather than mpcplus

**-f**
: indicates fullscreen display

**-g**
: indicates do not use gradient colors for spectrum visualizer

**-h**
: indicates half-height for mppcava window (with -f only)

**-P script**
: specifies the ASCIImatics script to run in visualizer pane

**-q**
: indicates quarter-height for mppcava window (with -f only)

**-r**
: indicates use retro terminal emulator

**-t**
: indicates use tilix terminal emulator

**-v 'viz_comm'**
: indicates use visualizer 'viz_comm' rather than mppcava

*ASCIImatics animation options:*

**-a**
: indicates play audio during ASCIImatics display

**-b**
: indicates use backup audio during ASCIImatics display

**-j**
: indicates use Julia Set scenes in ASCIImatics display

**-J**
: indicates Julia Set with several runs using different parameters

**-m**
: indicates use MusicPlayerPlus scenes in ASCIImatics display

**-n num**
: specifies the number of times to cycle ASCIImatics scenes

**-N**
: indicates use alternate comments in Plasma ASCIImatics scenes

**-p**
: indicates use Plasma scenes in ASCIImatics display

**-s song**
: specifies a song to accompany an ASCIImatics animation

**-S**
: indicates display ASCIImatics splash animation

*General options:*

**-B**
: uses Blissify to create audio-based information in a song similarity database for all music library media.

**-D**
: indicates download album cover art and exit

**-d 'music_directory'**
: specifies the music directory to use for downloaded album cover art (without this option -D will use the `music_directory` setting in `~/.config/mpd/mpd.conf`

**-F**
: indicates convert all WAV format files in the music library to MP3 format files and exit. A subsequent 'mpplus -I' import will be necessary to import these newly converted music files.

**-I**
: indicates import albums and songs from 'music_directory' to Beets and exit

**-i**
: indicates interactive mode with selection menus

**-k**
: indicates kill MusicPlayerPlus tmux sessions and ASCIImatics scripts

**-L**
: indicates download lyrics to the Beets library and exit

**-M 'enable|disable|start|stop|restart|status'**
: Enable, disable, start, stop, restart, or get the status of the MPD and MPD socket system services 

**-R**
: indicates record tmux session with asciinema

**-T**
: indicates use a tmux session for either ASCIImatics or mpcplus

**-w**
: indicates write metadata during Beets import

**-W**
: indicates do not write metadata during Beets import

**-x 'query'**
: uses AcousticBrainz to retrieve audio-based information for all music library media matching 'query'. A query of 'all' performs the retrieval on the entire music library.

**-X 'query'**
: performs an analysis and retrieval, using Essentia, of audio-based information for all music library media matching 'query'. A query of 'all' performs the analysis and retrieval on the entire music library.

**-Y**
: initializes the YAMS last.fm scrobbler service

**-y**
: disables the YAMS last.fm scrobbler service

**-z opt**
: specifies an `fzmp` option and invokes `fzmp` to list/search/select MPD media. Valid values for `opt` are 'a', 'A', 'g', 'p', or 'P'

**-u**
: displays this usage message and exits

# EXAMPLES
**mpplus**
: Launches `mpcplus` music player client running in gnome terminal emulator with mppcava spectrum visualizer running in a gnome-terminal terminal emulator window. 

**mpplus -i**
: Launches `mpplus` in interactive mode with menu selections controlling actions rather than command line arguments

**mpplus -r**
: Launches `mpcplus` music player client running in cool-retro-term terminal emulator with mppcava spectrum visualizer running in a gnome-terminal terminal emulator window. 

**mpplus -C cantata**
: Launches `cantata` music player client running in a separate window with mppcava spectrum visualizer running in a gnome-terminal terminal emulator window. 

**mpplus -C cmus**
: Launches the `cmus` music player client with mppcava spectrum visualizer running in a gnome-terminal terminal emulator window. 

**mpplus -C mcg**
: Launches the CoverGrid music player client (`mcg`) running in a separate window with mppcava spectrum visualizer running in a gnome-terminal terminal emulator window. 

**mpplus -f -q -t**
: Launches `mpcplus` music player client in fullscreen mode with mppcava spectrum visualizer in quarter-screen mode, both running in a tilix terminal emulator window. 

**mpplus -a -T**
: Launches `mpcplus` music player client and visualizer running in a tmux session displaying album cover art. 

**mpplus -M stop**
: Stops the Music Player Daemon service and the associated MPD socket service

**mpplus -R -T**
: Creates an asciinema recording of `mpcplus` music player client and visualizer running in a tmux session

**mpplus -S -j -a**
: Launch `mppsplash` displaying the Julia Set asciimatics animation with audio

**mpplus -D**
: Download album cover art for any albums in the music library that do not already have cover art 

**mpplus -I**
: Import the music library into the Beets library management system

**mpplus -I -W**
: Import the music library into the Beets library management system, do not write metadata

**mpplus -L**
: Download lyrics for any songs in the music library that do not already have lyrics

**mpplus -X all**
: Analyze audio using Essentia and retrieve information for the entire music library

**mpplus -x all**
: Retrieve audio information for the entire music library using AcousticBrainz

# AUTHORS
Written by Ronald Record github@ronrecord.com

# LICENSING
MPPLUS is distributed under an Open Source license.
See the file LICENSE in the MPPLUS source distribution
for information on terms &amp; conditions for accessing and
otherwise using MPPLUS and for a DISCLAIMER OF ALL WARRANTIES.

# BUGS
Submit bug reports online at:

https://github.com/doctorfree/MusicPlayerPlus/issues

# SEE ALSO
**mppcava**(1), **mppsplash**(1), **mpcplus**(1), **mpcpluskeys**(1)

Full documentation and sources at:

https://github.com/doctorfree/MusicPlayerPlus

