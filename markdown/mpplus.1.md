---
title: MPPLUS
section: 1
header: User Manual
footer: mpplus 2.0.1
date: December 05, 2021
---
# NAME
mpplus - Launch an MPD music player client and cava spectrum visualizer

# SYNOPSIS
**mpplus** [-a] [-c] [-C client] [-f] [-h] [-k] [-p script] [-q] [-r] [-R] [-t] [-T] [-u]

# DESCRIPTION
The *mpplus* command acts as a front-end for launching the mpcplus music player client and cava spectrum visualizer in various terminal emulators and window placements. It can be used to display these utilities juxtaposed in separate windows or fullscreen overlayed with transparency. Alternately, mpplus can launch the cantata MPD client or any specified MPD client along with the cava spectrum visualizer. Command line options also support running the *mpplus* windows in a tmux session and recording that session using *asciinema*.

Occasionally a tmux session or asciimatics script will hang. Previously started tmux sessions and asciimatics scripts can be quickly and easily killed by executing the `mpplus -k` command.

# COMMAND LINE OPTIONS
**-a**
: indicates display album cover art (implies tmux session)

**-c**
: indicates launch cantata MPD client rather than mpcplus

**-C client**
: indicates launch 'client' MPD client rather than mpcplus

**-f**
: indicates fullscreen display

**-h**
: indicates half-height for cava window (with -f only)

**-k**
: indicates kill any previously started tmux sessions and asciimatics scripts

**-p script**
: specifies an asciimatics script to run in the visualizer pane

**-R**
: indicates record tmux session with asciinema

**-T**
: indicates use a tmux session for terminal display

**-q**
: indicates quarter-height for cava window (with -f only)

**-r**
: indicates use retro terminal emulator

**-t**
: indicates use tilix terminal emulator

**-u**
: displays this usage message and exits

Type 'man mpplus' for detailed usage info on mpplus
Type 'man mpcplus' for detailed usage info on the mpcplus MPD client

# EXAMPLES
**mpplus**
: Launches `mpcplus` music player client running in xfce4 terminal emulator with cava spectrum visualizer running in a gnome-terminal terminal emulator window. 

**mpplus -r**
: Launches `mpcplus` music player client running in cool-retro-term terminal emulator with cava spectrum visualizer running in a gnome-terminal terminal emulator window. 

**mpplus -c**
: Launches `cantata` music player client running in a separate window with cava spectrum visualizer running in a gnome-terminal terminal emulator window. 

**mpplus -C cmus**
: Launches the `cmus` music player client with cava spectrum visualizer running in a gnome-terminal terminal emulator window. 

**mpplus -C mcg**
: Launches the CoverGrid music player client (`mcg`) running in a separate window with cava spectrum visualizer running in a gnome-terminal terminal emulator window. 

**mpplus -f -q -t**
: Launches `mpcplus` music player client in fullscreen mode with cava spectrum visualizer in quarter-screen mode, both running in a tilix terminal emulator window. 

**mpplus -a -T**
: Launches `mpcplus` music player client and visualizer running in a tmux session displaying album cover art. 

**mpplus -R -T**
: Creates an asciinema recording of `mpcplus` music player client and visualizer running in a tmux session

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
**mpcplus**(1), **mpcpluskeys**(1), **cava**(1)

Full documentation and sources at:

https://github.com/doctorfree/MusicPlayerPlus

