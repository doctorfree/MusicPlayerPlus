[MusicPlayerPlus](https://github.com/doctorfree/MusicPlayerPlus#readme) is an open source suite of character-based/console utilities, services, and tools to ease the installation, configuration, integration, and management of a music library, music server(s), music player, spectrum visualizer, music downloads, and more.

This major new release of MusicPlayerPlus adds support for many new features and components including:

* A Python virtual environment is used to provide support for Ubuntu 24.04 and others
* MusicPlayerPlus package is now architecture independent
* Auto-generation of Obsidian markdown vault from Discogs collection
* Auto-generation of Obsidian markdown vault from local music library
* Auto-generation of Discogs collection from Obsidian markdown vaults
* Modular installation and configuration of supporting components
* Support for Arch-like platforms (e.g. Manjaro)
* PipeWire service management and configuration
* Integration of the [Beets media library management system](https://beets.io/)
* Support for the [Mopidy Music Server](https://mopidy.com/) and extensions
* Support for the [Navidrome Streaming Music Server](https://www.navidrome.org/)
* Several supported Operating System platforms:
    * Arch Linux build and packaging support (NEW)
    * CentOS Linux build and packaging support (NEW)
    * Debian format packaging (tested on Ubuntu 20.04 - 22.04 and Raspbian bullseye)
    * RPM format packaging (tested on Fedora 35, CentOS 8)
* Support for Kitty as default terminal emualator
    * Custom Kitty configuration, themes, and sessions
* Support for album cover art display in tabbed terminals
* Support for YAMS Last.fm scrobbler activation
* Automated download of Soundcloud favorites
* Automated download of Bandcamp collections
* Automated download of YouTube playlist audio
* Automated download of audio from many other sites
* Preserve existing user configurations where appropriate
* Add `mpd-monitor` and `mpd-configure` commands and man pages
* Integrate `RoonCommandLine`, `MirrorCommand`, and `Asciiville` menus
* Add `-l music_dir` option to `mppinit`
    * To initialize a custom music library location in one step:
    * `mppinit -l /path/to/library`
* Many more improvements and features (See [Changelog](#changelog) below)

## Installation

Download the [latest Debian or RPM package format release](https://github.com/doctorfree/MusicPlayerPlus/releases) for your platform.

Install the package on Debian based systems by executing the command:

```bash
sudo apt install ./MusicPlayerPlus_3.0.2-1.deb
```

Install the package on RPM based systems by executing the command.

```bash
sudo dnf localinstall ./MusicPlayerPlus_3.0.2-1.rpm
```

### PKGBUILD Installation

To build an Arch Linux package from sources, see the
[Building MusicPlayerPlus from source](#building-musicplayerplus-from-source)
section below. On an Arch Linux system issue the following commands:

```
git clone https://github.com/doctorfree/MusicPlayerPlus.git
cd MusicPlayerPlus
./mkpkg
```

## Configuration

Execute the `mppinit` command (Required).

If the music library is located somewhere other than `$HOME/Music` or `$HOME/music` then rather than `mppinit`, execute the command `mppinit -l /path/to/library`.

If the `mppinit` MusicPlayerPlus initialization did not correctly detect the music library location then edit `~/.config/mpprc`, set the `MUSIC_DIR` correctly, and run `mppinit sync`.

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
sudo dnf remove MusicPlayerPlus
```

Removal of the package on Arch Linux based systems can be accomplished by issuing the command:

```bash
sudo pacman -Rs musicplayerplus
```

## Building MusicPlayerPlus from source

MusicPlayerPlus can be packaged and installed from the source code repository. This should be done as a normal user with `sudo` privileges:

```
# Retrieve the source code from the repository
git clone https://github.com/doctorfree/MusicPlayerPlus.git
# Enter the MusicPlayerPlus source directory
cd MusicPlayerPlus
# Create an installation package
./mkpkg
# Install MusicPlayerPlus and its dependencies
./Install
```

The `mkpkg` script detects the platform and creates an installable package in the package format native to that platform. After successfully building the MusicPlayerPlus installation package, the resulting installable package will be found in the `./releases/<version>/` directory.

## Changelog

View the full changelog for this release at https://github.com/doctorfree/MusicPlayerPlus/blob/v3.0.2r1/CHANGELOG.md

See [CHANGELOG.md](https://github.com/doctorfree/MusicPlayerPlus/blob/master/CHANGELOG.md) for a full list of changes in every MusicPlayerPlus release
