## Warning

This project is in a very early stage and currently more of a draft and also serves me as a backup of my local files (therefore there are updates in relatively short intervals).

The basic functions should work so far and help with the identification of unknown albums. I have only tested all this with a few files at the moment and have not yet run it over my current library.

Before you do this, you should have at least one backup of your current files.

## Why?

Because music files that contain relatively little information and therefore can not always be identified by [Roon](https://roonlabs.com/r/n6HeIaGsYUKKh60AONYs5Q) (Referral Link), I try here to do this by a special configuration of beets by changing the files accordingly.

My plan for the future is to write additional tags (which can be interpreted by Roon) to contain information that may not be present in the Roon database.
Also, to have functions that Roon can not (yet).

Of course, there is already software that can do this (possibly even better), but I try to automate the import process to the extent that, at best, I don't have to intervene at all.

## Installation

The installation is [Debian Bullseye](https://www.debian.org/releases/bullseye/index.en.html) based.

`sudo apt install -y python3-pip python3-gi`

`pip3 install beets`

### Create a symlink

`sudo ln -s ~/.local/bin /usr/local/bin && sudo reboot`

### Update

`pip3 -U install beets`

~`pip3 install -U https://github.com/beetbox/beets/tarball/master`~

## Goals

- [ ] Submit acoustic analysis results to the AcousticBrainz server.
  - [ ] [absubmit](https://beets.readthedocs.io/en/latest/plugins/absubmit.html) (auto)
  * Install: `pip3 install requests`
- [x] Get acoustic-analysis information from the AcousticBrainz project.
  * [acousticbrainz](https://beets.readthedocs.io/en/latest/plugins/acousticbrainz.html) (auto)
- [x] Check for missing and corrupt files. 
  - [x] [badfiles](https://beets.readthedocs.io/en/latest/plugins/badfiles.html) (manually)
    * Command: `beet bad`
- [x] Use bandcamp as an autotagger source, for fetching lyrics and cover art.
  - [x] [bandcamp](https://github.com/snejus/beetcamp) (auto) @test
    * Install: `pip3 install beetcamp`
- [x] Create folders with the first letters of the band names and assign them accordingly.
  - [x] [bucket](https://beets.readthedocs.io/en/latest/plugins/bucket.html)
- [x] Automatically checksum files to detect corruption.
  * [check](https://github.com/geigerzaehler/beets-check) (auto) @test
    * Install: `pip3 install beets-check`
    - [ ] Install `mp3val`
    - [ ] Install `oggz-validate`
- [x] Use acoustic fingerprinting to identify audio files with missing or incorrect metadata.
  - [x] [chroma](https://beets.readthedocs.io/en/latest/plugins/chroma.html) (auto)
    * Install: `pip3 install pyacoustid`
- [x] Transcode Roon exports to redbook flac files for mobile devices.
  - [x] [convert](https://beets.readthedocs.io/en/latest/plugins/convert.html) (manually)
    * Command: `beet convert`
- [x] Copy additional files (like covers, booklets) and directories during the import process and place it in the right directory.
  - [x] [copyartifacts](https://github.com/adammillerio/beets-copyartifacts)
    * Install: `pip3 install beets-copyartifacts3`
- [x] Extend the autotagger’s search capabilities to include matches from the Discogs database.
  - [x] [discogs](https://beets.readthedocs.io/en/latest/plugins/discogs.html) (auto)
    * Install: `pip3 install discogs-client`
  - [ ] [discogs_extradata](https://github.com/SimonPersson/beets-plugins)
    * Original year, if earlier than musicbrainz
    * Label is set to label of original release
    * Performers tag is populated
- [x] Find and list duplicate tracks or albums in the collection.
  - [x] [duplicates](https://beets.readthedocs.io/en/latest/plugins/duplicates.html) (manually)
    * Command: `beet duplicates`
- [ ] Modify music metadata using your favorite text editor or MusicBrainz Picard.
  - [ ] [edit](https://beets.readthedocs.io/en/latest/plugins/edit.html)
    * Command: `beet edit QUERY` # In case you need to edit the album-level fields, the recommended approach is to invoke the plugin via the command line in album mode after the import.
  - [ ] Alternative: https://github.com/kergoth/beets-kergoth/blob/master/beetsplug/picard.py
- [x] Fetch album art from different web sources.
  - [x] [fetchart](https://beets.readthedocs.io/en/latest/plugins/fetchart.html) (auto)
    * Install: `pip3 install requests`
    - [ ] Fetch booklets - do not seem to be possible at the moment.
    - [ ] Alternative: [arttools](https://github.com/mried/beetsplug/wiki/arttools)
- [ ] Fetch artist pictures and place them in the artist directories.
  - [ ] [fetchartist](https://github.com/dkanada/beets-fetchartist) (manually)
    * Install:
      * `pip3 install requests`
      * Copy to pluginpath
    * Command: `beet fetchartist`
    - [ ] `path not found`
- [x] Follow album artists from your library on Muspy to get notifications about new releases.
  - [x] [follow](https://github.com/nolsto/beets-follow) (auto)
    * Install: `pip3 install beets-follow`
- [x] Tag albums that are missing tags altogether.
  - [x] [fromfilename](https://beets.readthedocs.io/en/latest/plugins/fromfilename.html) (auto)
- [x] Preserve the import date.
  - [x] [importadded](https://beets.readthedocs.io/en/latest/plugins/importadded.html)
- [x] Dump the current tag values for any file format supported by beets.
  - [x] [info](https://beets.readthedocs.io/en/latest/plugins/info.html) (manually)
- [x] Collect play counts from Last.fm. Doesn't make any sense for the use with Roon yet.
  - [x] [lastimport](https://beets.readthedocs.io/en/latest/plugins/lastimport.html) (manually)
    * Install: `pip3 install pylast`
    * Command: `beet -v lastimport`
    * To keep up-to-date, you can run this plugin every once in a while (cron?).
- [x] Fetch genres from Last.fm. MusicBrainz actually doesn’t contain genre information and set a fallback genre if none is available.
  - [x] [lastgenre](https://beets.readthedocs.io/en/latest/plugins/lastgenre.html)
    * Install: `pip3 install pylast`
  - [ ] [whatlastgenre](https://github.com/YetAnotherNerd/whatlastgenre)
    * Discogs, Last.FM, MusicBrainz, Redacted.ch
- [x] Fetch lyrics from various sources.
  - [x] [lyrics](https://beets.readthedocs.io/en/latest/plugins/lyrics.html)
    * Install: `pip3 install requests beautifulsoup4`
- [x] Submit the catalog to MusicBrainz to maintain the music collection list there. (auto)
  - [x] [mbcollection](https://beets.readthedocs.io/en/latest/plugins/mbcollection.html)
  * Remove Album from collection (manually): `beet mbupdate -r`
- [x] Fetch metadata from MusicBrainz for albums and tracks that already have MusicBrainz IDs.
  - [x] [mbsync](https://beets.readthedocs.io/en/latest/plugins/mbsync.html)
- [x] Find and list, which or how many tracks are missing, for every album in the collection.
  - [x] [missing](https://beets.readthedocs.io/en/latest/plugins/missing.html)
- [x] Set file permissions for imported music files and its directories.
  - [x] [permissions](https://beets.readthedocs.io/en/latest/plugins/permissions.html) (auto)
- [x] Add ReplayGain tags for mobile devices.
  - [x] [replaygain](https://beets.readthedocs.io/en/latest/plugins/replaygain.html)
- [x] List all files in the library folder which are not listed in the beets library database.
  - [x] [unimported](https://beets.readthedocs.io/en/latest/plugins/unimported.html)
- [ ] Watch directories for changes and trigger imports.
  * [watch](https://github.com/zersetz-end/beets-watch)
- [ ] Fetch tags:
  - [ ] `website`
  - [ ] `barcode`
  - [ ] `isrc`
  - [ ] `origninalyear`
  - [ ] `artists`
- [ ] Add Roon specific tags, like `ROONALBUMTAG`, `ROONTRACKTAG`, `ROONRADIOBAN` ...
  - [ ] Write track genres to `ROONTRAGTAG`
  - [ ] Automatically add `ROONRADIOBAN`, value `false`, if the tag doesn't exist.
  - [ ] [usertag](https://github.com/igordertigor/beets-usertag) (manually)
- [ ] Copy tags from one to another to get Roon compatibility.
  - [ ] [tagcopy](https://github.com/mattbarnicle/beetsplug)
- [x] Automatically extract compressed archives in Download directory.
  * Only seem to work for single files, for example: `beet import /mnt/external/work/incoming/Album.zip`
  * Doesn't work with whitespaces in file names.
- [ ] Assign Qobuz comment/description to the appropriate tags.
  - [ ] [structuredcomments](https://github.com/michaeltoohig/BeetsPluginStructuredComments)
  * https://discourse.beets.io/t/comments-field-template-dev-questions/1354
- [ ] Refine matches.
- [x] Hide credentials in `config.yaml` (`secrets.yaml`).
- [ ] Automate Beets installation including plugins

## Beets commands

Of course, the given commands assume that the music files to import are located in `/mnt/external/work/incoming/`, otherwise the path must be changed.

`beet import /mnt/external/work/incoming/` # Import and change tags.

`beet import -A /mnt/external/work/incoming/` # Import but don't change any tags.

`beet import -W /mnt/external/work/incoming/` # When autotagging, don’t write new tags to the files themselves (just keep the new metadata in beets’ database.)

`beet import -C /mnt/external/work/incoming/` # Don’t copy imported files to your music directory; leave them where they are.

`beet import -m /mnt/external/work/incoming/` # Move imported files to your music directory (overrides the -c option).

`beet import -l LOGFILE /mnt/external/work/incoming/` # Write a message to `LOGFILE` every time you skip an album or choose to take its tags “as-is” (see below) or the album is skipped as a duplicate; this lets you come back later and reexamine albums that weren’t tagged successfully.

`beet import -q /mnt/external/work/incoming/` # Quiet mode. Never prompt for input and, instead, conservatively skip any albums that need your opinion. The `-ql` combination is recommended.

`beet import -t /mnt/external/work/incoming/` # Timid mode, which is sort of the opposite of “quiet.” The importer will ask your permission for everything it does, confirming even very good matches with a prompt.

`beet import -p /mnt/external/work/incoming/` # Automatically resume an interrupted import. The importer keeps track of imports that don’t finish completely (either due to a crash or because you stop them halfway through) and, by default, prompts you to decide whether to resume them. The `-p` flag automatically says “yes” to this question. Relatedly, `-P` flag automatically says “no.”

`beet import -s /mnt/external/work/incoming/` # Run in singleton mode, tagging individual tracks instead of whole albums at a time. See the “as Tracks” choice below. This means you can use beet import `-AC` to quickly add a bunch of files to your library without doing anything to them.

`beet import -g /mnt/external/work/incoming/` # Assume there are multiple albums contained in each directory. The tracks contained a directory are grouped by album artist and album name and you will be asked to import each of these groups separately. See the “Group albums” choice below.



`beet update`

`beet stats`

`beet ls` # List all music of the library

`beet ls -a` # List all albums of the library

`beet rm <part of name>` # Remove track(s) of the library

`beet rm -a <part of name>` # Remove album(s) of the library

## Tips

### Enabling tab-completion in bash

Beets includes support for Bash shell command completion. To enable completion, put the following line into your `.bashrc`:

```
~/.bashrc

eval "$(beet completion)"
```

You will also need to install `bash-completion` for this to work. 

## Links

* [Documentation](https://beets.readthedocs.io)
* [Beets @ jundar.de (German)](https://jundar.de/beets-konfigurieren/)
* [Beets Docker](https://blog.linuxserver.io/2016/10/08/managing-your-music-collection-with-beets/)
* [music-workflow](https://github.com/djdembeck/music-workflow)

### Configs

* https://github.com/hashhar/picard-beets-config
* https://github.com/kergoth/Beets-Library
* https://github.com/RollingStar/dial-beets
* https://github.com/trapd00r/configs/tree/master/beets

### Similar

* [roon-tagger](https://github.com/babysnakes/roon-tagger)
