---
title: BLISSIFY
section: 1
header: User Manual
footer: blissify 0.2.7
date: August 6, 2022
---
# NAME
blissify = Analyze and make smart playlists from an MPD music database.

# SYNOPSIS
**blissify** [SUBCOMMAND] [FLAGS]

# DESCRIPTION

The *blissify* command can be used to create an MPD playlist of songs
based on computed similarity metrics. Blissify is a program used to make
playlists of songs that sound alike from your [MPD](https://www.musicpd.org/)
track library, à la Spotify radio.

Under the hood, it is an [MPD](https://www.musicpd.org/) plugin
for [bliss](https://crates.io/crates/bliss-audio).

Blissify needs first to analyze your music library, i.e. compute and store a
series of features from your songs, extracting the tempo, timbre, loudness, etc.

After that, it is ready to make playlists: play a song to start from, run
`blissify playlist 30`, and voilà! You have a playlist of 30 songs that
sound like your first track.

Note: you *need* to have MPD installed to use blissify.

# GLOBAL FLAGS

**-h, --help**
: Prints help information

**-V, --version**
: Prints version information

# SUBCOMMANDS

**help**
: Prints this message or the help of the given subcommand(s)

**interactive-playlist**
: Make a playlist, prompting a set of close songs, and asking which one will be the most appropriate.

**list-db**
: Print songs that have been analyzed and are in blissify's database.

**playlist**
: Erase the current playlist and make playlist of PLAYLIST_LENGTH from the currently played song

**rescan**
: (Re)scan completely an MPD library

**update**
: Scan new songs that were added to the MPD library since last scan.

**blissify-playlist**
: Erase the current playlist and make playlist of PLAYLIST_LENGTH from the currently played song

# PLAYLIST USAGE

blissify playlist [PLAYLIST FLAGS] [PLAYLIST OPTIONS] <PLAYLIST_LENGTH>

# PLAYLIST FLAGS

**--album-playlist**
: Make a playlist of similar albums from the current album.

**--deduplicate-songs**
: Deduplicate songs based both on the title / artist and theirsheer proximity.

**-h, --help**
: Prints help information

**--seed-song**
: Instead of making a playlist of only the closest song to the current song,make a playlist that queues the closest song to the first song, then the closest to the second song, etc. Can take some time to build.

**-V, --version**
: Prints version information

# PLAYLIST OPTIONS

**--distance <distance metric>**
: Choose the distance metric used to make the playlist. Default is 'euclidean',other option is 'cosine' [default: euclidean]

# PLAYLIST ARGS

**<PLAYLIST_LENGTH>**
: Number of items to queue, including the first song.

# INTERACTIVE USAGE

Make a playlist, prompting a set of close songs, and asking which one will be the most appropriate.

blissify interactive-playlist [INTERACTIVE FLAGS] [INTERACTIVE OPTIONS]

# INTERACTIVE FLAGS:

**--continue**
: Take the current playlist's last song as a starting point, instead of removing the current playlist and starting from the first song.

**-h, --help**
: Prints help information

**-V, --version**
: Prints version information

# INTERACTIVE OPTIONS

**--number-choices <choices>**
: Choose the number of proposed items you get each time. Defaults to 3, cannot be more than 9. [default: 3]

# LIST USAGE

Print songs that have been analyzed and are in blissify's database.

blissify list-db [LIST FLAGS]

# LIST FLAGS

**--detailed**
: Display analyzed song paths, as well as the corresponding analysis.

**-h, --help**
: Prints help information

**-V, --version**
: Prints version information

# EXAMPLES

All the commands below read the `MPD_HOST` and `MPD_PORT` environment
variables and try to reach MPD using that. You might want to change
it if MPD is listening to somewhere else than `127.0.0.1:6600` (the default).

## Analyze a library

To analyze your MPD library, use:

**blissify update /path/to/mpd/music_directory**

Note that it may take several minutes (up to some hours, on very large
libraries with more than for instance 20k songs) to complete.

If something goes wrong during the analysis, and the database enters an
unstable state, you can use:

**blissify rescan /path/to/mpd/music_directory**

to remove the existing database and rescan all files.

If you want to see if the analysis has been successful, or simply want to see
the current files in, you can use:

**blissify list-db**

## Make a simple playlist


**blissify playlist 100**

This will add 100 songs similar to the song that is currently
playing on MPD, starting with the closest possible.

## Changing the distance metric

To make a playlist with a distance metric different than the default one
(euclidean distance), which will yield different playlists, run:

**blissify playlist --distance <distance_name> 30**

`distance_name` is currently `euclidean` and `cosine`. Don't hesitate to
experiment with this parameter if the generated playlists are not to your
linking!

## Make a "seeded" playlist

Instead of making a playlist with songs that are only similar to the first song,
from the most similar to the least similar (the default), you can make a
playlist that queues the closest song to the first song, then the closest song
the second song, etc, effectively making "path" through the songs.

To try it out (it can take a bit more time to build the playlist):

**blissify playlist --seed-song 30**

## Make an album playlist

You can also make a playlist of album that sound like the current album
your listening to (more specifically, the album of the current song you're
playling, regardless of whether you queued the full album or not).

To try it out:

**blissify playlist --album-playlist 30**

## Make an interactive playlist

Interactive playlists start from a song, and let you choose which song should
be played next among the 3 closest songs (the number of songs displayed is
can be set manually):

**blissify playlist --interactive-playlist --number-choices 5**

By default, it crops the current playlist to just keep the currently played
song. If you want to just start from the last song and continue from there,
use `--continue`:

**blissify playlist --interactive-playlist --number-choices 5 --continue**

# AUTHORS

Blissify written by @Polochon_street

MusicPlayerPlus integration of Blissify written by Ronald Record github@ronrecord.com

# LICENSING
BLISSIFY is distributed under an Open Source license.
See the file LICENSE in the BLISSIFY source distribution
for information on terms &amp; conditions for accessing and
otherwise using BLISSIFY and for a DISCLAIMER OF ALL WARRANTIES.

# BUGS
Submit bug reports online at:

https://github.com/doctorfree/MusicPlayerPlus/issues

# SEE ALSO
**beet**(1), **mpplus**(1)

Full documentation and sources at:

https://github.com/doctorfree/MusicPlayerPlus

