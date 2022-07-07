Changes in this release include:

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

## Installation
Install the package on Debian based systems by executing the command

```bash
sudo apt install ./MusicPlayerPlus_1.0.2-2.amd64.deb
```

or, on a Raspberry Pi:

```bash
sudo apt install ./MusicPlayerPlus_1.0.2-2.armhf.deb
```

Install the package on RPM based systems by executing the command
```bash
sudo yum localinstall ./MusicPlayerPlus-1.0.2-2.x86_64.rpm
```

## Configuration
Edit `/etc/mpd.conf` and set the `music_directory`.

Execute the `mpcinit` command.

Execute the `mpcplus` command and type `u` to initiate a database update.

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
