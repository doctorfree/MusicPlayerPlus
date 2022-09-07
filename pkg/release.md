[MusicPlayerPlus](https://github.com/doctorfree/MusicPlayerPlus#readme) is an open source suite of character-based/console utilities, services, and tools to ease the installation, configuration, integration, and management of a music library, music server(s), music player, spectrum visualizer, music downloads, and more.

This major new release of MusicPlayerPlus adds support for many new features and components including:

* Integration of the [Beets media library management system](https://beets.io/)
* Support for the [Mopidy Music Server](https://mopidy.com/) and extensions
* Support for the [Navidrome Streaming Music Server](https://www.navidrome.org/)
* Several supported Operating System platforms:
    * Arch Linux build and packaging support (NEW)
    * Debian format packaging (tested on Ubuntu 20.04 and Raspbian bullseye)
    * RPM format packaging (tested on Fedora 35)
* Support for Kitty as default terminal emualator
    * Custom Kitty configuration, themes, and sessions
* Support for YAMS Last.fm scrobbler activation
* Automated download of Soundcloud favorites
* Automated download of Bandcamp collections
* Automated download of YouTube playlist audio
* Automated download of audio from many other sites
* Many more improvements and features (See [Changelog](#changelog) below)

## Installation

Download the [latest Debian, Arch, or RPM package format release](https://github.com/doctorfree/MusicPlayerPlus/releases) for your platform.

Install the package on Debian based systems by executing the command:

```bash
sudo apt install ./MusicPlayerPlus_2.0.1-2.amd64.deb
```

or, on a Raspberry Pi:

```bash
sudo apt install ./MusicPlayerPlus_2.0.1-2.armhf.deb
```

Install the package on Arch Linux based systems by executing the command:

```bash
sudo pacman -U ./MusicPlayerPlus_2.0.1-2-x86_64.pkg.tar.zst
```

Install the package on RPM based systems by executing the command:

```bash
sudo yum localinstall ./MusicPlayerPlus_2.0.1-2.x86_64.rpm
```

### PKGBUILD Installation

To install on a Raspberry Pi running Arch Linux, MusicPlayerPlus must be built from sources using the Arch PKGBUILD files provided in `MusicPlayerPlus-pkgbuild-2.0.1-2.tar.gz`. This process can be performed on any `x86_64` or `armv7h ` architecture system running Arch Linux. An `x86_64` architecture precompiled package is supplied (see above). To rebuild this package from sources, extract `MusicPlayerPlus-pkgbuild-2.0.1-2.tar.gz` and use the `makepkg` command to download the sources, build the binaries, and create the installation package:

```
tar xzf MusicPlayerPlus-pkgbuild-2.0.1-2.tar.gz
cd musicplayerplus
makepkg --force --log --cleanbuild --noconfirm --syncdeps
```

**[Note:]** The full MusicPlayerPlus build from sources can be time consuming. Use a pre-built package if one is available for your platform.

To create an installable package from the latest development sources rather
than the stable release packages, clone the MusicPlayerPlus repository and
use the `mkpkg` script to create a package for your platform:

```
git clone https://github.com/doctorfree/MusicPlayerPlus.git
cd MusicPlayerPlus
./mkpkg
```

The `mkpkg` script detects the platform and creates an installable package in the package format native to that platform. After successfully building the MusicPlayerPlus components, the resulting installable package will be found in the `./releases/<version>/` directory.

## Configuration

Execute the `mppinit` command (Required).

Edit `~/.config/mpd/mpd.conf` and set the `music_directory`.

If you change the `music_directory` setting in `~/.config/mpd/mpd.conf` then run `mppinit sync`.

To enable the Beets media library management system (Optional):

* Run `mppinit bandcamp` to download Bandcamp collections (Optional)
* Run `mppinit soundcloud` to download Soundcloud favorites (Optional)
* Run `mppinit import` to import the music library into Beets (Required)
* Run `mppinit metadata` to organize and improve library metadata (Optional)

To install, configure, and activate the Mopidy music server:

* Run `mppinit mopidy`

To install, configure, and activate the Navidrome streaming music server:

* Run `mppinit navidrome`

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

Removal of the package on Arch Linux based systems can be accomplished by issuing the command:

```bash
sudo pacman -Rs musicplayerplus
```

## Changelog

Changes in version 2.0.1 release 2 include:

* Arch Linux build and packaging support
* Integration of the Beets media library management system
* Add support for Mopidy and Mopidy administration
* Add support for Navidrome and Navidrome administration
* Add new config file `~/.config/mpprc` for MusicPlayerPlus preferences
* Fixes for EWMH non-compliant window managers (e.g. DWM)
* Add support for Kitty as default terminal emualator
    * Custom Kitty configuration, themes, and sessions
* Add Beets web plugin service
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
* Add mpplus menu to manage downloads
* Add new command 'listyt' to list YouTube video titles and urls
* Add Sphinx docs for Read the Docs MusicPlayerPlus documentation
* Add mppdl command and yt-dlp module for downloading audio from various sites
* Add mppcover command to display album cover art of currently playing song
* Only install Bliss utils if they compile successfully
* Additional python module dependencies installed during mppinit
* Messages in mppinit tailored to which acoustic analysis is performed
* Remove dependencies on gnome-terminal and tilix
* Add dependency on wmctrl and xrandr, remove dependency on dconf

See [CHANGELOG.md](https://github.com/doctorfree/MusicPlayerPlus/blob/master/CHANGELOG.md) for a full list of changes in every MusicPlayerPlus release
