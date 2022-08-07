# MusicPlayerPlus

This major release of MusicPlayerPlus adds:

* Integration of the Beets media library management system
* Automated Beets xtractor plugin installation and configuration
    * Beets xtractor plugin performs acoustic analysis and metadata updates
    * Gaia and Essentia for audio analysis and audio-based information retrieval
    * Pre-compiled `streaming_extractor_music` extractor binary with Gaia
* Support for automated WAV to MP3 conversion with `mpplus -F`
* Support for automated lyrics download with `mpplus -L`
* Support for YAMS Last.fm scrobbler activation with `mpplus -Y`
* Help menu to `mpplus`
* Man pages for `scdl` and `bandcamp-dl`
* Script to download Soundcloud favorites
* Script to download Bandcamp collections
* Options to use AcousticBrainz rather than Essentia for audio information
* Custom targets to xtractor config
* Bandcamp and Soundcloud downloads to mppinit
* Import and metadata retrieval to `mppinit`
* Add blissify MPD library analysis and smart playlist generator
* Many more improvements and features (See [Changelog](#changelog) below)

## Installation

Download the [latest Debian or RPM package format release](https://github.com/doctorfree/MusicPlayerPlus/releases) for your platform.

Install the package on Debian based systems by executing the command

```bash
sudo apt install ./MusicPlayerPlus_2.0.1-1.amd64.deb
```

or, on a Raspberry Pi:

```bash
sudo apt install ./MusicPlayerPlus_2.0.1-1.armhf.deb
```

Install the package on RPM based systems by executing the command
```bash
sudo yum localinstall ./MusicPlayerPlus-2.0.1-1.x86_64.rpm
```

## Configuration

Execute the `mppinit` command (Required).

Edit `~/.config/mpd/mpd.conf` and set the `music_directory`.

If you change the `music_directory` setting in `~/.config/mpd/mpd.conf` then run `mppinit sync`.

To enable the Beets media library management system (Optional):

* Run `mppinit bandcamp` to download Bandcamp collections (Optional)
* Run `mppinit soundcloud` to download Soundcloud favorites (Optional)
* Run `mppinit import` to import the music library into Beets (Required)
* Run `mppinit metadata` to organize and improve library metadata (Optional)

See the [MusicPlayerPlus README](https://github.com/doctorfree/MusicPlayerPlus#readme) for additional configuration info.

## Removal

Removal of the package on Debian based systems can be accomplished by issuing the command:

```bash
sudo apt remove musicplayerplus
```

Removal of the package on RPM based systems can be accomplished by issuing the command:

```bash
sudo yum remove MusicPlayerPlus
```

## Changelog

Changes in version 2.0.1 release 1 include:

* Added Beets media library management integration
* Automated Beets xtractor plugin installation and configuration
    * Beets xtractor plugin performs acoustic analysis and metadata updates
    * Gaia and Essentia for audio analysis and audio-based information retrieval
    * Pre-compiled `streaming_extractor_music` extractor binary with Gaia
* Improved lastgenre Beets configuration
* Use %title template function to Title Case artist names in Beets
* Scripts to convert WAV format media to MP3 format media
* Custom Beets play plugin configuration to use `mpc`
* Auto generation of smart MPD playlists
* Add support for automated WAV to MP3 conversion with `mpplus -F`
* Add support for automated lyrics download with `mpplus -L`
* Add support for YAMS Last.fm scrobbler activation with `mpplus -Y`
* Add `create_playlist` command to create new playlists from Beets queries
* Add support for Calliope playlist toolkit
* Enhanced Beets import logging
* Man pages for `beets` and `beetsconfig`
* Integrate basic Beets initialization and management in `mpplus`
* Add tmux plugin manager settings to default configuration
* Compile and install Gaia and Essentia from customized source
* Automated install and configuration of many Beets plugins
    * acousticbrainz, albumtypes, bandcamp, describe, duplicates
    * edit, extrafiles, fromfilename, hook, importadded, info
    * lyrics, lastgenre, missing, mbsync, mpdstats, play, playlist
    * smartplaylist, mpdupdate, unimported, xtractor
* Add help menu to mpplus
* Add man pages for scdl and bandcamp-dl
* Add script to download Soundcloud favorites
* Add script to download Bandcamp collections
* Add options to use AcousticBrainz rather than Essentia for audio information
* Add custom targets to xtractor config
* Add Bandcamp and Soundcloud downloads to mppinit
* Add import and metadata retrieval to mppinit

Changes in version 1.0.3 release 1 include:

* Add support for Raspberry Pi
* Include `mppcava` fork of Cava spectrum visualizer in MusicPlayerPlus package
* Check if DISPLAY can be used and if not execute in console mode using tmux
* Configure MPD with user systemd service using configuration in `~/.config/mpd/`
* Add `Alt-f` mpcplus key binding to search music library using `fzf`
* Additional custom tmux key bindings
* Configure MPD user service in mpcinit, move MPD fifo to user MPD config dir
* Add option to specify alternate spectrum visualizer
* Create terminal profiles in mpcinit
* Add support for `tmuxp` tmux session manager
* Add `tmuxp` configuration files in `~/.config/tmuxp/`
* Convert mppsplash-tmux and mpcplus-tmux to use `tmuxp`
* Use gnome-terminal as default rather than xfce4-terminal
* Add fzmp command and fzf dependency
* Add command line option to invoke fzmp
* Add support for fzmp to interactive menu in mpplus
* Add man page for fzmp
* Add mpcplus cheat sheet
* Rename asciijulia to mppjulia to avoid conflict with Asciiville package
* Rename asciiplasma to mppplasma to avoid conflict with Asciiville package
* Rename asciimpplus to mpprocks to avoid conflict with Asciiville package
* Added asciinema dependency

Previous changes in version 1.0.2 include:

* Add `alsa_conf` command to configure ALSA sound system
* Add management of MPD services through `mpplus` command
* Disable tmux recording when tmux is disabled
* Improve interactive menu entries
* If -s song argument is provided look for song in MPD music library as well
* Added interactive mode with -i command line option
* Added support for mpplus front-end to mppsplash and mppsplash-tmux
* Add ability to download cover art to mpplus command
* Add option to download_cover_art to specify alternate music directory
* Add -d option to mpplus to download album cover art
* Use MPlayer to play media during ASCIImatics animations
* Use a signal handler in ASCIImatics animations to fade audio and cleanup
* Use a FIFO in ASCIImatics animations to communicate with MPlayer
* Added tmux session integration to `mpplus` command
* Re-enable visualizer in `mpcplus` MPD client build
* Cleanup tmux sessions, add ability to kill tmux sessions in `mpplus`
* Add capability to play audio while displaying ASCIImatics scenes
* Add several ASCIImatics scenes including one during initialization
* Rename `mpcava` to `mpplus`
* Integration with `asciinema` for recording ascii terminal sessions
* Several new commands including:
    * **alsa_audio_test**
    * **asciijulia**
    * **asciimpplus**
    * **asciiplasma**
    * **download_cover_art**
    * **mpcinit**
    * **mpcplus-tmux**
    * **mppsplash**
    * **mppsplash-tmux**
* Added display of client, visualizer, and album cover art in tmux
* Additional terminal support

