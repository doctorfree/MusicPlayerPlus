Changes in this release include:

* Use MPlayer to play media during ASCIImatics animations
* Use a signal handler in ASCIImatics animations to fade audio and cleanup
* Use a FIFO in ASCIImatics animations to communicate with MPlayer
* Added tmux session integration to `mpplus` command
* Re-enable visualizer in `mpcplus` MPD client build
* Cleanup tmux sessions, add ability to kill tmux sessions in `mpplus`

Changes in previous release include:

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
sudo apt install ./MusicPlayerPlus_1.0.1-2.amd64.deb
```

Install the package on RPM based systems by executing the command
```bash
sudo yum localinstall ./MusicPlayerPlus-1.0.1-2.x86_64.rpm
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
