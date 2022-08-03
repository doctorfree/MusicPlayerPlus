---
title: MPPINIT
section: 1
header: User Manual
footer: mppinit 1.0.0
date: March 24, 2022
---
# NAME
mppinit - performs one-time MusicPlayerPlus initialization

# SYNOPSIS
**mppinit** [-a] [-d] [-o] [-q] [-U] [-y] [-u] [bandcamp|import|metadata|sync]

# DESCRIPTION
The *mppinit* command copies and configures default MusicPlayerPlus
configuration files in `$HOME/.config/` and installs required Python
modules if not already installed.

Invoked with the `bandcamp` argument, *mppinit bandcamp* downloads the
albums in your Bandcamp collections. A valid Bandcamp username must be
configured in `$HOME/.config/calliope/calliope.conf`. The Bandcamp albums
are downloaded to the `music_directory` folder configured in
`$HOME/.config/mpd/mpd.conf` in a `Bandcamp` sub-folder.

Invoked with the `import` argument, *mppinit import* imports the music
library to the Beets media management system.

Invoked with the `metadata` argument, *mppinit metadata* updates the Beets
library with analyzed and retrieved metadata. If accompanied by the `-a`
argument, AcousticBrainz is used to retrieve audio information rather than
analyzing audio files with Essentia.

Invoked with the `sync` argument, *mppinit sync* synchronizes the music
library location across all configuration files.

# COMMAND LINE OPTIONS

**-a**
: indicates use AcousticBrainz to retrieve audio information rather than using Essentia to analyze audio files

**-d**
: indicates install latest Beets development branch rather than the latest stable release (for testing purposes)

**-o**
: indicates overwrite any pre-existing configuration

**-q**
: indicates quiet execution, no status messages

**-U**
: indicates upgrade installed Python modules if needed

**-y**
: indicates answer 'yes' to all and proceed

**-u**
: displays usage message and exits

**import**
: performs a Beets music library import

**metadata**
: performs a Beets library metadata update

**sync**
: synchronizes the music library location across configs

*mppinit* must be performed before a *sync*, *metadata*, *bandcamp*, or *import*

Only one of *bandcamp*, *import*, *metadata*, or *sync* can be specified

# AUTHORS
Written by Ronald Record github@ronrecord.com

# LICENSING
MPPINIT is distributed under an Open Source license.
See the file LICENSE in the MPPINIT source distribution
for information on terms &amp; conditions for accessing and
otherwise using MPPINIT and for a DISCLAIMER OF ALL WARRANTIES.

# BUGS
Submit bug reports online at:

https://github.com/doctorfree/MusicPlayerPlus/issues

# SEE ALSO
**mpplus**(1), **mpcplus**(1), **mpcpluskeys**(1)

Full documentation and sources at:

https://github.com/doctorfree/MusicPlayerPlus

