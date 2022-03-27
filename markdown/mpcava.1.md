---
title: MPCAVA
section: 1
header: User Manual
footer: mpcava 2.0.1
date: December 05, 2021
---
# NAME
mpcava - Launch an MPD music player client and cava spectrum visualizer

# SYNOPSIS
**mpcava** [-c] [-C client] [-f] [-h] [-q] [-r] [-t] [-u]

# DESCRIPTION
The *mpcava* command acts as a front-end for launching the mpcplus music player client and cava spectrum visualizer in various terminal emulators and window placements. It can be used to display these utilities juxtaposed in separate windows or fullscreen overlayed with transparency. Alternately, mpcava can launch the cantata MPD client or any specified MPD client along with the cava spectrum visualizer.

# COMMAND LINE OPTIONS
**-c**
: indicates launch cantata MPD client rather than mpcplus

**-C client**
: indicates launch 'client' MPD client rather than mpcplus

**-f**
: indicates fullscreen display

**-h**
: indicates half-height for cava window (with -f only)

**-q**
: indicates quarter-height for cava window (with -f only)

**-r**
: indicates use retro terminal emulator

**-t**
: indicates use tilix terminal emulator

**-u**
: displays this usage message and exits

# EXAMPLES
**mpcava**
: Launches mpcplus music player client running in xfce4 terminal emulator with cava spectrum visualizer running in a gnome-terminal terminal emulator window. 

**mpcava -r**
: Launches mpcplus music player client running in cool-retro-term terminal emulator with cava spectrum visualizer running in a gnome-terminal terminal emulator window. 

**mpcava -c**
: Launches cantata music player client running in a separate window with cava spectrum visualizer running in a gnome-terminal terminal emulator window. 

**mpcava -C mcg**
: Launches the CoverGrid music player client (mcg) running in a separate window with cava spectrum visualizer running in a gnome-terminal terminal emulator window. 

**mpcava -f -q -t**
: Launches mpcplus music player client in fullscreen mode with cava spectrum visualizer in quarter-screen mode, both running in a tilix terminal emulator window. 

# AUTHORS
Written by Ronald Record github@ronrecord.com

# LICENSING
MPCAVA is distributed under an Open Source license.
See the file LICENSE in the MPCAVA source distribution
for information on terms &amp; conditions for accessing and
otherwise using MPCAVA and for a DISCLAIMER OF ALL WARRANTIES.

# BUGS
Submit bug reports online at:

https://github.com/doctorfree/MusicPlayerPlus/issues

# SEE ALSO
**mpcplus**(1), **mpcpluskeys**(1), **cava**(1)

Full documentation and sources at:

https://github.com/doctorfree/MusicPlayerPlus

