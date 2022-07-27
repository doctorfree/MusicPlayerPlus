---
title: MPCINIT
section: 1
header: User Manual
footer: mppinit 1.0.0
date: March 24, 2022
---
# NAME
mppinit - performs one-time MusicPlayerPlus initialization

# SYNOPSIS
**mppinit** [import|metadata|sync]

# DESCRIPTION
The *mppinit* command copies and configures default configuration files in
$HOME/.config/mpcplus/

In addition, *mppinit* initializes the default tmux configuration for the
user running the command.

Finally, *mppinit* installs required pip modules if not already installed.

Invoked with the `import` argument, *mppinit import* imports the music
library to the Beets media management system.

Invoked with the `metadata` argument, *mppinit metadata* updates the Beets
library with analyzed and retrieved metadata.

Invoked with the `sync` argument, *mppinit sync* synchronizes the music
library location across all configuration files.

# AUTHORS
Written by Ronald Record github@ronrecord.com

# LICENSING
MPCINIT is distributed under an Open Source license.
See the file LICENSE in the MPCINIT source distribution
for information on terms &amp; conditions for accessing and
otherwise using MPCINIT and for a DISCLAIMER OF ALL WARRANTIES.

# BUGS
Submit bug reports online at:

https://github.com/doctorfree/MusicPlayerPlus/issues

# SEE ALSO
**mpcplus**(1), **mpcpluskeys**(1)

Full documentation and sources at:

https://github.com/doctorfree/MusicPlayerPlus

