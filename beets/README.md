# Beets media library management

## Table of contents

1. [Overview](#overview)
1. [Getting started with Beets](#getting-started-with-beets)
    1. [Quickstart with Beets](#quickstart-with-beets)
    1. [Create a music library](#create-a-music-library)
    1. [Configure the music library location](#configure-the-music-library-location)
    1. [Download album cover art](#download-album-cover-art)
    1. [Convert WAV format media files](#convert-wav-format-media-files)
    1. [Import the music library into Beets](#import-the-music-library-into-beets)
1. [Fetching lyrics](#fetching-lyrics)
1. [Automated audio analysis and audio-based information retrieval](#automated-audio-analysis-and-audio-based-information-retrieval)
1. [Configuring the Discogs metadata source](#configuring-the-discogs-metadata-source)
1. [MusicPlayerPlus Beets plugins](#musicplayerplus-beets-plugins)

## Overview

MusicPlayerPlus includes integrated installation and extensive configuration
for the Beets media library management system. Beets is an open source,
extensible, highly configurable suite of tools and plugins that organizes
and improves the structure, cataloging, and metadata of a music library.

Management of your music library with Beets is an optional feature provided
by MusicPlayerPlus. Although optional, use of Beets can enhance your
music library in ways that make it more useful and easier to access with
the `mpcplus` MusicPlayerPlus MPD client. For example, one of the automated
tasks that Beets performs is updating the tags in your music library. Beets
queries online sources like MusicBrainz, Bandcamp, and Last.fm to update the
music library with widely used metadata for songs and albums it can identify.
Subsequent invocations of `mpcplus` will be able to use this rich set of tags
to filter, search, and find items in your music library.

The primary source of online data for Beets is
[MusicBrainz](https://musicbrainz.org), a collaborative music database.
As of March 2022, MusicBrainz contained information on roughly 1.9 million
artists, 3 million releases, and 26.5 million recordings. This extensive set
of data, along with additional data from other online sources like
[Bandcamp](https://bandcamp.com) and [Last.fm](https://www.last.fm)
can be used to significantly improve the metadata content and organization
of your music library.

**[NOTE:]** Beets is NOT the now defunct music service purchased by Apple.
It is an open source media library management system.

## Getting started with Beets

MusicPlayerPlus has integrated Beets initialization and use into the `mpcinit`
initialization command and the `mpplus` primary user interface. Due to its
complexity, flexibility, and power, Beets can be fairly difficult to manage.
MusicPlayerPlus attempts to ease the task of managing your music library
with Beets. The following few steps are all that is necessary to get started
with Beets after installing MusicPlayerPlus and initializing with `mpcinit`.

### Quickstart with Beets

- After installing MusicPlayerPlus and running `mpcinit`
- Create a music library if you do not already have one
- If your music library is not in `$HOME/Music/`:
    - Edit `$HOME/.config/mpd/mpd.conf`
    - Set `music_directory` to the music library location 
    - Run the command `mpcinit sync`
- Optionally:
    - Download album cover art with the command `mpplus -D`
    - Convert WAV format media to MP3 format with the command `mpplus -F`
- Import the music library into Beets with the command `mpplus -I`

### Create a music library

If you do not already have one, create a music library on the system where
MusicPlayerPlus is installed. This is the music library that MPD will be
accessing and its location is defined in `$HOME/.config/mpd/mpd.conf`.
The default location for the music library is `$HOME/Music/`. If you wish
to store your music library in another location, e.g. on an external drive,
then there will be a couple of extra steps to perform, outlined below.

It is recommended to organize the music library with a structure like
`Artist/Album/songs` but this is not necessary. One of the ways Beets
tries to identify albums and songs is by examining filenames and paths.
If the music library is organized with top-level directories being artist
names, subdirectories being album names, and files within album folders
being songs from that album then Beets can use that structure to match
artists and albums with online data. Should your music library be organized
in a different fashion then Beets will still identify artists, albums, genres,
songs, and other metadata using intelligent matching algorithms.

The music library must be writeable by the MusicPlayerPlus user.

### Configure the music library location

If you have created a music library in a location other than `$HOME/Music/`
then edit `$HOME/.config/mpd/mpd.conf` and set the `music_directory`
configuration to the location of your music library.

After configuring `mpd.conf` with the proper `music_directory` setting,
run the command `mpcinit sync`. This will update other MusicPlayerPlus
and Beets configuration files that need to know the music library location.

If your music library location is `$HOME/Music` then you can skip this step.

### Download album cover art

Once your music library has been created and the library location set,
you can download album cover art with the command `mpplus -D`.

This step is optional as album cover art is not required by either Beets
or MusicPlayerPlus. However, cover art can be displayed by many MPD clients
and enhances the user experience. Pre-existing album cover art is retained
and only albums with no cover art are updated.

Note, for large libraries with many albums missing cover art this process
may take a long time. Monitor the download process with the command
`tail -f ${HOME}/.config/mpcplus/download_art.log`.

The `mpplus -D` command downloads album cover art for each album in your
music library and places the album cover art in the file `cover.jpg` in the
album folder. The `mpplus -D` command downloads images of size 600x600.

If you wish to name album cover art differently or if you wish to create
a different sized album cover art, then execute the `sacad_r` command
directly rather than with `mpplus -D` as follows:


```
sacad_r <MUSIC_DIRECTORY> <SIZE> <FILENAME>
```

Where <MUSIC_DIRECTORY> is the full pathname to your music library, <SIZE>
is the desired size of the image, and <FILENAME> is the desired filename.

For example, to download album art for a music library located in
`/u/audio/music` with an image size of 500x500, in PNG image format,
and album art filenames `album_cover.png` execute the command:

```
sacad_r /u/audio/music 500 album_cover.png
```

Learn more about the Smart Automatic Cover Art Downloader `sacad` at
https://github.com/desbma/sacad

### Convert WAV format media files

If your music library contains WAV format media files, these will not be
imported into Beets. The WAV format is an older media format and does not
support metadata in a way that Beets can manipulate. If you wish to import
these files into Beets it is necessary to convert them to a format that
is compatible with Beets. MusicPlayerPlus provides a convenience command
to convert all WAV format media to MP3 format.

Convert WAV format media files in your library to MP3 format files with
the command `mpplus -F`. Conversion from WAV to MP3 allows these files to
be imported into the Beets media library management system.

If the music libary does not contain any WAV format media files then this
step can be skipped.

### Import the music library into Beets

If you wish to manage your music library with Beets, import the music library
with the command `mpplus -I`.

To get started using the Beets media library management system, it is
necessary to import your music library into the Beets database. This process
catalogs your music collection and improves its metadata. The default
Beets configuration provided by MusicPlayerPlus moves and tags files in the
music library during this process. It adds music library data to the Beets
database. To import your music library into Beets, issue the following command:

```
mpplus -I
```

The Beets import defaults are controlled by the Beets configuration file
at `$HOME/.config/beets/config.yaml` and command-line options to the
`beet import` command. By default, MusicPlayerPlus imports the MPD music
library into Beets, moving rather than copying files to conform with
standard detected artist/album/song naming conventions, and writing
detected metadata. A log of the album import is written to the file
`$HOME/.config/beets/import.log`. A log of the singletons import
is written to the file `$HOME/.config/beets/import_singletons.log`.
A log of the import times is written to the file
`$HOME/.config/beets/import_time.log`.

Prior to performing the intial Beets import of your music library,
examine the *import* section of the Beets configuration at
`$HOME/.config/beets/config.yaml`. Modify the *import* settings
to suit your preferences. The default *import* settings configured
by MusicPlayerPlus are:

```
import:
    copy: yes
    move: yes
    write: yes
    incremental: yes
    incremental_skip_later: yes
    quiet: no
    quiet_fallback: asis
    resume: yes
    from_scratch: no
    default_action: apply
    detail: yes
    non_rec_action: ask
    # duplicate_action can be 'skip', 'keep', 'remove', 'merge' or 'ask'
    duplicate_action: skip
    group_albums: no
    autotag: yes
    bell: no
    log: ~/.config/beets/import.log
```

You may prefer to set `move: no` if you do not wish your files and folders
to be moved or if you wish that rearrangement to be performed by
copying rather than moving. Moving conserves disk space, copying preserves
a libary's structure but can consume much additional disk space. The
MusicPlayerPlus default preference is to move rather than copy.

**[NOTE:]** Some users prefer to use
[MusicBrainz Picard](https://picard.musicbrainz.org/)  to tag their music
library. If you have previously tagged your music library using
MusicBrainz Picard then you may wish to modify the default Beets
*import* configuration to preserve Picard tagging and speed up import.
An example *import* section of the Beets `config.yaml` that would
preserve Picard tags might look like the following:

```
import:
    write: no
    copy: no
    move: no
    resume: ask
    incremental: yes
    incremental_skip_later: no
    from_scratch: no
    timid: yes
    log: ~/.config/beets/import.log
    group_albums: no
    autotag: yes
    bell: no
```

The import process, depending on the size of the music library and metadata
analyzed, may take several hours. For this reason, it is performed in the
background and non-interactively. For extremely large music libraries
(e.g. over 200GB) the import may need to run overnight. As long as your
computer remains on and connected to the Internet, the import process
should run uninterrupted and without need for attention. You may continue
working or leave the import unattended.

An interrupted Beets import can be resumed simply by re-running the
`mpplus -I` command. The import process will skip over previously imported
items and import items the previous import failed to reach.

A rough estimate of the time to import a music library into Beets can be
obtained by calculating the size of the library. On a moderately equipped
Ubuntu Linux system, a test import of a 4GB music library of ~200 songs
took about 15 minutes. Import times will vary with network speed, how quickly
metadata sources like MusicBrainz and Bandcamp can locate media matches,
and many other factors. Unfortunately, it is not possible to speed an
import beyond the frequency with which MusicBrainz permits API requests.

A good workflow might be: Kickoff a Beets import, Enjoy some Sun with a good
book, Check the import progress, Return to reading, Check progress, Repeat.

When running in the background, monitor the progess of the import by
examining the log file. For example, to view the progress of the album
import in real-time:

```
tail -f $HOME/.config/beets/import_time.log
```

To view the progress of the singletons import in real-time:

```
tail -f $HOME/.config/beets/import_singletons.log
```

The `mpplus -I ...` command performs both an import of the music library
albums and an import of singleton songs.

Music library folders that are skipped are likely those for which `beet import`
did not find the entire album. These songs should be picked up and imported
during the subsequent import where singletons are identified and imported.

If a manual beets import is desired, it may be performed by issuing the commands:

```
beet import -[w|W] <MUSIC_DIRECTORY>
```

and

```
beet import -[w|W] -s <MUSIC_DIRECTORY>
```

Where <MUSIC_DIRECTORY> is the full pathname to your music library and the
`-w` flag indicates 'write metadata' while `-W` flag indicates 'do not write metadata'.
Omitting both the `-w` and `-W` flags will use the *write* setting in the
*import* section of `~/.config/beets/config.yaml` to determin if metadata are
written. The first import command above imports albums from the music library
at <MUSIC_DIRECTORY>. The second import command imports singleton songs.

To perform a faster import without auto-tagging, writing tags, or copying,
run the command:

```
beet import -qAWC
```

If you wish to update the tags in your music library after having imported
without auto-tagging or writing, use the `mbsync` plugin to update tags
using MusicBrainz: `beet mbsync`.

If auto-tagging, writing, moving, or otherwise modifying the music library
during import, you may wish to backup your music library prior to importing.
To view help on Beets importing, run the command `beet help import`.

If new songs or albums are added to the MPD music library, the Beets import
can be re-run with `mpplus -I` or manually and only new albums and songs
will be added to the Beets database as the import is performed incrementally.
Incremental imports is a configuration option set in the *import* section
of the Beets `$HOME/.config/beets/config.yaml` configuration file.

List the currently imported music library items with the command `beet list`
and the currently imported music library albums with the command `beet list -a`.

View music library statistics with the `beet describe` command. For example,
to view library genre statistics run the command `beet describe genre`.
To view library beats per minute statistics run the command `beet describe bpm`.

The `beet` command-line reference is available at
https://beets.readthedocs.io/en/latest/reference/cli.html

Learn more about the Beets media library management system at
https://beets.io/

## Fetching lyrics

The Beets media library management system can fetch lyrics using the
`lyrics` plugin. The MusicPlayerPlus default Beets configuration does
not enable lyrics fetching using the `lyrics` plugin during Beets import.
Albums and songs imported using Bandcamp as a metadata source will
automatically fetch lyrics during import. That is, the default MusicPlayerPlus
Beets import will only fetch lyrics for Bandcamp sourced items.

To view a list of music library items that do not have lyrics metadata,
issue the command:

```
beet list -f '$artist: $album - $title' lyrics::^$
```

To fetch lyrics for all songs in the music library that do not already have
lyrics. after the Beets import process completes issue the command:

```
mpplus -L
```

MusicPlayerPlus has chosen to provide a default Beets configuration that
disables auto-fetching of lyrics during import in order to reduce the
import time which can be quite lengthy. To enable auto-fetching of lyrics
during import, prior to performing the music library Beets import, change
the `auto: no` setting to `auto: yes` in the `lyrics:` section of
`$HOME/.config/beets/config.yaml`

The `lyrics` plugin also has a configuration option to specify the lyrics
sources to query when fetching lyrics. Some of these online lyrics services
have blocked the Beets User-Agent thereby disabling those services for
Beets users. Google does not block Beets lyrics queries but the Google
lyrics service requires additional configuration - providing an API key.

For these reasons, MusicPlayerPlus distributes a Beets lyrics configuration
that auto-fetches from Bandcamp when that is used as a metadata source
and only queries the Polish lyrics service at https://www.tekstowo.pl
for `lyrics` plugin requests. You may wish to add to or replace this service.
To modify the list of lyrics services queried by the Beets `lyrics` plugin,
change the `sources: tekstowo` setting in the `lyrics:` section of
`$HOME/.config/beets/config.yaml` to one or more of
`google musixmatch genius tekstowo`.

See the
[Beets lyrics plugin documentation](https://beets.readthedocs.io/en/stable/plugins/lyrics.html)
for more information on configuring and using the Beets lyrics plugin.

## Automated audio analysis and audio-based information retrieval

MusicPlayerPlus includes a pre-compiled `essentia_streaming_extractor_music`
binary along with pre-installed and configured `xtractor` Beets plugin.
This enables Beets to analyze audio files, extract information on a wide
variety of audio parameters, and write metadata to the Beets library.
This process can provide information on audio in a music library that
can be used to filter and select songs by their detected audio qualities.

The `acousticbrainz` plugin, also installed and pre-configured in
MusicPlayerPlus 2.0.1, performs the same function and even uses the
same Essentia technology to analyze audio data. A MusicPlayerPlus
initialization of the Beets music library database will automatically
add metadata for songs in the music library using `acousticbrainz`.

However, `acousticbrainz` does not perform an analysis on all songs
and, worse, the AcousticBrainz service is being retired in 2023.
For these reasons, MusicPlayerPlus provides the built-in capability
to perform acoustic audio analysis using Essentia and the xtractor plugin.

To perform an audio analysis and audio-based information retrieval using
MusicPlayerPlus, issue the command `mpplus -X 'query'` where 'query' is
a Beets media library query specifying which songs or albums or artists
to match. A special query of 'all' indicates the entire music library.

For example, to analyze and retrieve audio information on all songs with
filename or pathname that include the string "Love Party", issue the command:

```
mpplus -X 'love party'
```

To analyze and retrieve audio information on the entire music library:

```
mpplus -X all
```

The process of analyzing and retrieving audio information can be very
time consuming. For this reason, the process is run in the background
and a terminal window is opened to monitor the extraction process.

Due to the long extraction times needed to perform an audio analysis,
it is often desirable to identify only those songs that do not already
have the desired metadata and perform the analysis selectively on those
songs using an appropriate Beets query string. For example, to identify
all songs in the music library that do not have a 'mood_party' metadata
tag, issue the command:

```
beet list -f '$artist: $album - $title' mood_party::^$
```

Other songs for which the `xtractor` plugin may prove useful are those
for which `acousticbrainz` mistakenly added a bpm value of 0. To find
these songs, issue the command:

```
beet list -f '$artist: $album - $title' bpm:0
```

## Configuring the Discogs metadata source

Beets uses [MusicBrainz](https://musicbrainz.org) as the default source
for metadata. This is sufficient for many Beets users as MusicBrainz has
a vast amount of data and requires no registration or API key to utilize.
However, MusicBrainz does not have every artist, album, and song in its
database and there are several Beets plugins that extend metadata search
to additional sources.

MusicPlayerPlus provides a pre-configured Beets `bandcamp` plugin to enable
[Bandcamp](https://bandcamp.com) as a metadata source. Many artists have
chosen to only distribute their works on Bandcamp in order to avoid the
miniscule royalty payments made to artists by streaming services. Bandcamp
is also a frequent home for artists who have not been signed to a label
or are otherwise not well known. The default Beets configuration that
MusicPlayerPlus provides will automatically use Bandcamp as a metadata
source thereby finding matches for artists, albums, and songs in the music
library that were downloaded from Bandcamp.

The default MusicPlayerPlus Beets configuration, using both MusicBrainz
and Bandcamp as metadata sources, should satisfy most use cases.
However, some users may wish to enable additional metadata sources.
One of the most complete sources of music metadata is
[Discogs](https://www.discogs.com). To enable Discogs as a metadata source,
it will be necessary to register for a Discogs account, provide
authorization and credentials, and configure the `discogs` plugin.
This process is not too difficult but MusicPlayerPlus cannot perform
this automatically. It must be performed by the Beets user. Follow these
steps to enable Discogs as a metadata source:

* Register for a free Discogs account by visiting https://www.discogs.com
* No need to install `python3-discogs-client` as this was done during the MusicPlayerPlus initialization with `mpcinit`
* Login to Discogs to generate a user token
    * Visit the [Developer settings page](https://www.discogs.com/settings/developers) at https://www.discogs.com/settings/developers
    * Press the `Generate new token` button
    * Copy the generated token to your clipboard (select the token and press Ctrl-c)
* Add the generated token in the `discogs` section of the Beets configuration
    * Edit `$HOME/.config/beets/config.yaml`
    * Uncomment the `discogs` entry in the `plugins` section
    * Uncomment the `discogs:` plugin configuration section
    * Set the `user_token:` configuration option in the `discogs:` section
        * user_token: Your_Discogs_User_Token

After editing `config.yaml` the discogs plugin configuration should look
something like the following:

```yaml
discogs:
    source_weight: 0.0
    index_tracks: yes
    user_token: DruiHPid_I_Just_Made_This_Up_LSAPTWUCnpRJ
```

After completing the above steps Discogs will be used as a metadata
source by Beets. The `user_token` setting will alleviate the need to
authenticate or provide credentials when accessing Discogs with Beets.

For additional information on the Beets discogs plugin, visit
https://beets.readthedocs.io/en/stable/plugins/discogs.html

## MusicPlayerPlus Beets plugins

Beets includes an extensive set of plugins that can be used to enhance and
extend the functionality of the media library management Beets provides. Many
Beets plugins are installed and configured automatically by MusicPlayerPlus.

MusicPlayerPlus 2.0.1 and later include automated installation and
configuration for the following Beets plugins:

* acousticbrainz, albumtypes, bandcamp, describe, duplicates, edit, extrafiles
* fromfilename, hook, importadded, info, lyrics, lastgenre, missing, mbsync
* mpdstats, play, playlist, smartplaylist, mpdupdate, unimported, xtractor, yearfixer

See the MusicPlayerPlus [Wiki article on Beets plugins](https://github.com/doctorfree/MusicPlayerPlus/wiki/BeetsPlugins)
for an introduction to the installed and configured MusicPlayerPlus Beets plugins.
