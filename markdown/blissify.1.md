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
based on similarity metrics computed and stored in a database.

```
USAGE:
    blissify [SUBCOMMAND]

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

SUBCOMMANDS:
    help                    Prints this message or the help of the given subcommand(s)
    interactive-playlist    Make a playlist, prompting a set of close songs, and asking which one will be the most
                            appropriate.
    list-db                 Print songs that have been analyzed and are in blissify's database.
    playlist                Erase the current playlist and make playlist of PLAYLIST_LENGTH from the currently
                            played song
    rescan                  (Re)scan completely an MPD library
    update                  Scan new songs that were added to the MPD library since last scan.
blissify-playlist 
Erase the current playlist and make playlist of PLAYLIST_LENGTH from the currently played song
```

```
USAGE:
    blissify playlist [FLAGS] [OPTIONS] <PLAYLIST_LENGTH>

FLAGS:
        --album-playlist       Make a playlist of similar albums from the current album.
        --deduplicate-songs    Deduplicate songs based both on the title / artist and theirsheer proximity.
    -h, --help                 Prints help information
        --seed-song            Instead of making a playlist of only the closest song to the current song,make a playlist
                               that queues the closest song to the first song, then
                                                   the closest to the second song, etc. Can take some time to build.
    -V, --version              Prints version information

OPTIONS:
        --distance <distance metric>    Choose the distance metric used to make the playlist. Default is
                                        'euclidean',other option is 'cosine' [default: euclidean]

ARGS:
    <PLAYLIST_LENGTH>    Number of items to queue, including the first song.
blissify-interactive-playlist 
Make a playlist, prompting a set of close songs, and asking which one will be the most appropriate.
```

```
USAGE:
    blissify interactive-playlist [FLAGS] [OPTIONS]

FLAGS:
        --continue    Take the current playlist's last song as a starting point, instead of removing the current
                      playlist and starting from the first song.
    -h, --help        Prints help information
    -V, --version     Prints version information

OPTIONS:
        --number-choices <choices>    Choose the number of proposed items you get each time. Defaults to 3, cannot be
                                      more than 9. [default: 3]
blissify-list-db 
Print songs that have been analyzed and are in blissify's database.
```

```
USAGE:
    blissify list-db [FLAGS]

FLAGS:
        --detailed    Display analyzed song paths, as well as the corresponding analysis.
    -h, --help        Prints help information
    -V, --version     Prints version information
```

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

