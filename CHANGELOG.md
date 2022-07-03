# Changelog

All notable changes to this project will be documented in this file.

# MusicPlayerPlus-1.0.2r2 (2022-07-04)
* Add option to specify alternate spectrum visualizer
* Create terminal profiles in mpcinit
* Use gnome-terminal for default rather than xfce4-terminal
* Add fzmp command and fzf dependency
* Add command line option to invoke fzmp
* Add support for fzmp to interactive menu in mpplus
* Add man page for fzmp
* Rename asciijulia to mppjulia to avoid conflict with Asciiville package
* Rename asciiplasma to mppplasma to avoid conflict with Asciiville package
* Rename asciimpplus to mpprocks to avoid conflict with Asciiville package
* Added asciinema dependency
* Add support for Raspberry Pi

# MusicPlayerPlus-1.0.2r1 (2022-04-14)
* Add `alsa_conf` command to configure ALSA sound system
* Add management of MPD services through `mpplus` command

# MusicPlayerPlus-1.0.1r3 (2022-04-12)
* Disable tmux recording when tmux is disabled
* Improve interactive menu entries
* If -s song argument is provided look for song in MPD music library as well
* Added interactive mode with -i command line option
* Added support for mpplus front-end to mppsplash and mppsplash-tmux
* Add ability to download cover art to mpplus command
* Add option to download_cover_art to specify alternate music directory
* Add -d option to mpplus to download album cover art

# MusicPlayerPlus-1.0.1r2 (2022-04-04)
* Use MPlayer to play media during ASCIImatics animations
* Use a signal handler in ASCIImatics animations to fade audio and cleanup
* Use a FIFO in ASCIImatics animations to communicate with MPlayer
* Added tmux session integration to `mpplus` command
* Re-enable visualizer in `mpcplus` MPD client build
* Cleanup tmux sessions, add ability to kill tmux sessions in `mpplus`

# MusicPlayerPlus-1.0.1r1 (2022-03-31)
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

# MusicPlayerPlus-1.0.0r1 (2022-03-26)
* Added Debian and RPM packaging (pkg/debian/ and pkg/rpm/)
* Added configure and compile of mpcplus to packaging scripts
* Moved mpcplus client source into subdirectory of repository

# MusicPlayerPlus-1.0.0r1 (2022-03-25)
* Changed name to MusicPlayerPlus

# mpcplus-0.10 (2022-03-25)
* Merged in packaging, utilities, doc, and config from MusicPlayerPlus

# mpcplus-0.10 (2022-03-24)
* See mpcplus/CHANGELOG.md for history of changes to mpcplus MPD client

