---
title: ARTIST_TO_ALBUMARTIST
section: 1
header: User Manual
footer: artist_to_albumartist 1.0.1
date: August 6, 2022
---
## NAME
artist_to_albumartist - copies Artist tag to AlbumArtist tag for given mp3/ogg/flac files

## SYNOPSIS
**artist_to_albumartist** [--dry-run] files

## DESCRIPTION

The *artist_to_albumartist* command can be used to copy the Artist tag (if present) to the AlbumArtist tag (if not present) for given mp3/ogg/flac files

**[Note:]** To run it recursively for all your files, you can use:

```
find DIRECTORY \( -name "*.flac" -o -name "*.mp3" -o -name "*.ogg" \) -exec artist_to_albumartist [--dry-run] {} \;
```

## OPTIONS

**--dry-run**
: Report which files would be modified but do not alter any tags

When invoked without any arguments *artist_to_albumartist* displays a brief usage message and exits

## AUTHORS

Written by Andrzej Rybczak andrzej@rybczak.net

MusicPlayerPlus integration by Ronald Record github@ronrecord.com

## LICENSING

ARTIST_TO_ALBUMARTIST is distributed under an Open Source license.
See the file LICENSE in the ARTIST_TO_ALBUMARTIST source distribution
for information on terms &amp; conditions for accessing and
otherwise using ARTIST_TO_ALBUMARTIST and for a DISCLAIMER OF ALL WARRANTIES.

## BUGS

Submit bug reports online at:

https://github.com/doctorfree/MusicPlayerPlus/issues

## SEE ALSO

**mpplus**(1), **mpcplus**(1)

Full documentation and sources at:

https://github.com/doctorfree/MusicPlayerPlus

