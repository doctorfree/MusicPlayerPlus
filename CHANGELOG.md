## Changelog

All notable changes to this project will be documented in this file.

## MusicPlayerPlus-3.0.1r2 (2023-01-11)
* Use external `mppcava` package
* MusicPlayerPlus package is now architecture independent

## MusicPlayerPlus-3.0.1r1 (2023-01-09)
* Arch Linux modular installation fixes
* Support for Arch-like platforms (e.g. Manjaro)

## MusicPlayerPlus-3.0.0r2 (2023-01-03)
* Modular installation and configuration of supporting components
* Add support for adding markdown releases to a Discogs collection folder
* Update mppcava with changes from cava version 0.8.3
* Install ueberzug from forked repo as it was deleted from PyPi
* Integrate Discogs workflow into mppinit and mpplus
* Support generation of an Obsidian vault from a local music library
* Add support for auto-generation of Obsidian vault from Discogs collection
* Modify Beets `paths` configuration to support Discogs release matching
* Add `DISCOGS_USER`, `DISCOGS_TOKEN`, `DISCOGS_DIR` to `mpprc` configuration
* Add Jekyll theme for Github Pages
* Update tmux configuration
* Check if `MPD_CLIENT` is executable in `PATH`
* Add `MPD_CLIENT` to `mpprc` configuration
* Use `MPD_CLIENT` in mpplus, default is `mpcplus`
* Install kitty terminfo entry in mppinit
* Add PipeWire service management
* Add PipeWire user configuration files
* Add url handling section to Kitty config, default to PulseAudio output in mpd.conf
* Improved tab bar titles, add section on URLs
* Use transparency only when needed, modify -A argument to take on|off like -T
* Remove blissify and bliss-analyze from build and packaging - now a separate package
* Disable album cover art if not using mpcplus or ncmpcpp
* Add client option to mpcplus-tmux and mpcplus-ueberzug - any MPD client can be used
* Always use tmux in cool-retro-term, do not quote command in cool-retro-term
* Improve Kitty tab bar, use 'Home' for tab title when in user home directory
* Move svm_models to mpplus-essentia package
* Add clock to Kitty tab bar
* Improve Kitty tab bar and theme
* Add kitty/tab.conf, modify Kitty startup session
* Use an external Essentia package install in mppinit
* Add curl to dependencies, check for required utilities in mppinit
* Add pkg/dist/get_latest package download script
* Improve mppinit package download/install
* Convenience scripts to retrieve release artifacts
* Add clone, build, and config for mmtc MPD client
* Add commands to add to MPD queue and select for queue
* Add scripts to clone and build mpq, pms, and songmem
* Add clone, build, and config for nncmpp

## MusicPlayerPlus-2.0.1r3 (2022-09-20)
* Add CentOS Linux build and packaging support
* Improved Arch Linux support
* Improved album cover art download and display
* Preserve existing user configurations where appropriate
* Add view service logs menu to mpplus
* Add `mpd-monitor` and `mpd-configure` commands and man pages
* Integrate `RoonCommandLine`, `MirrorCommand`, and `Asciiville` menus
* Add `-l music_dir` option to `mppinit`
    * To initialize a custom music library location in one step:
    * `mppinit -l /path/to/library`
* Bug fixes

## MusicPlayerPlus-2.0.1r2 (2022-08-20)
* Add Arch Linux build and packaging support
* Add support for Mopidy and Mopidy administration
* Add support for Navidrome and Navidrome administration
* Add new config file `~/.config/mpprc` for MusicPlayerPlus preferences
* Fixes for EWMH non-compliant window managers (e.g. DWM)
* Change default terminal emulator from gnome-terminal to kitty
* Add support for Kitty, custom Kitty config/themes/sessions
* Add Beets web plugin service
* Add mpplus menu to manage downloads
* Add new command 'listyt' to list YouTube video titles and urls
* Add Sphinx docs for Read the Docs MusicPlayerPlus documentation
* Add mppdl command and yt-dlp module for downloading audio from various sites
* Add mppcover command to display album cover art of currently playing song
* Additional python module dependencies installed during mppinit
* Messages in mppinit tailored to which acoustic analysis is performed
* Remove dependencies on gnome-terminal and tilix
* Add dependency on wmctrl and xrandr, remove dependency on dconf

## MusicPlayerPlus-2.0.1r1 (2022-08-08)

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
* Add blissify MPD library analysis and smart playlist generator
* Add bliss-analyze acoustic analysis tool

## MusicPlayerPlus-1.0.3r1 (2022-07-09)

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

## MusicPlayerPlus-1.0.2r1 (2022-04-14)

* Add `alsa_conf` command to configure ALSA sound system
* Add management of MPD services through `mpplus` command

## MusicPlayerPlus-1.0.1r3 (2022-04-12)

* Disable tmux recording when tmux is disabled
* Improve interactive menu entries
* If -s song argument is provided look for song in MPD music library as well
* Added interactive mode with -i command line option
* Added support for mpplus front-end to mppsplash and mppsplash-tmux
* Add ability to download cover art to mpplus command
* Add option to download_cover_art to specify alternate music directory
* Add -d option to mpplus to download album cover art

## MusicPlayerPlus-1.0.1r2 (2022-04-04)

* Use MPlayer to play media during ASCIImatics animations
* Use a signal handler in ASCIImatics animations to fade audio and cleanup
* Use a FIFO in ASCIImatics animations to communicate with MPlayer
* Added tmux session integration to `mpplus` command
* Re-enable visualizer in `mpcplus` MPD client build
* Cleanup tmux sessions, add ability to kill tmux sessions in `mpplus`

## MusicPlayerPlus-1.0.1r1 (2022-03-31)

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

## MusicPlayerPlus-1.0.0r1 (2022-03-26)

* Added Debian and RPM packaging (pkg/debian/ and pkg/rpm/)
* Added configure and compile of mpcplus to packaging scripts
* Moved mpcplus client source into subdirectory of repository

## MusicPlayerPlus-1.0.0r1 (2022-03-25)

* Changed name to MusicPlayerPlus

## mpcplus-0.10 (2022-03-25)

* Merged in packaging, utilities, doc, and config from MusicPlayerPlus

## mpcplus-0.10 (2022-03-24)

* See mpcplus/CHANGELOG.md for history of changes to mpcplus MPD client
