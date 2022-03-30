---
title: MPCPLUS-TMUX
section: 1
header: User Manual
footer: mpcplus-tmux 1.0.0
date: March 26, 2022
---
# NAME
mpcplus-tmux - runs mpcplus, a visualizer, and displays album art in a tmux session

# SYNOPSIS
**mpcplus-tmux** [-a] [-p script] [-r] [-x width] [-y height] [-u]

# DESCRIPTION
The *mpcplus-tmux* command opens several panes in a terminal window,
executing the mpcplus MPD client in one pane, a visualizer in another pane,
and displaying album cover art in another pane. The album cover art
automatically updates when another album is selected in the MPD client pane.
The visualizer pane displays, by default, the cava spectrum visualizer.
Alternately, the visualizer pane can display a Python asciimatics visualization.

# COMMAND LINE OPTIONS
**-a**
: indicates display album cover art

**-p script**
: specifies a python script to run in the visualizer pane. Available scripts are "julia", "musicplayerplus", and "mpcplus".

**-r**
: indicates record tmux session with asciinema

**-x width**
: specifies the width of the spectrum visualizer

**-y height**
: specifies the height of the spectrum visualizer

**-u**
: displays this usage message and exits

**Defaults:**
: width=256 height=9, cover art disabled, python art disabled, recording disabled

# EXAMPLES
**mpcplus-tmux**
: Without options, *mpcplus-tmux* displays the mpcplus MPD client and cava spectrum visualizer in a tmux session. 

**mpcplus-tmux -a**
: With the -a option, *mpcplus-tmux* displays the mpcplus MPD client, cava spectrum visualizer, and album cover art in a tmux session. 

**mpcplus-tmux -r**
: With the -r option, *mpcplus-tmux* displays the mpcplus MPD client and cava spectrum visualizer in a tmux session and records the session using asciinema. Recordings are stored in the user's `$HOME/Videos/` folder.

# AUTHORS
Written by Ronald Record github@ronrecord.com

# LICENSING
MPCPLUS-TMUX is distributed under an Open Source license.
See the file LICENSE in the MPCPLUS-TMUX source distribution
for information on terms &amp; conditions for accessing and
otherwise using MPCPLUS-TMUX and for a DISCLAIMER OF ALL WARRANTIES.

# BUGS
Submit bug reports online at:

https://github.com/doctorfree/MusicPlayerPlus/issues

# SEE ALSO
**mpcplus**(1), **mpcpluskeys**(1)

Full documentation and sources at:

https://github.com/doctorfree/MusicPlayerPlus

