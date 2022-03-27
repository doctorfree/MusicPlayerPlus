# MusicPlayerPlus version 1.0.0 release 1

## Installation
Install the package on Debian based systems by executing the command
```bash
sudo apt install ./MusicPlayerPlus_1.0.0-1.amd64.deb
```

Install the package on RPM based systems by executing the command
```bash
sudo yum localinstall ./MusicPlayerPlus-1.0.0-1.x86_64.rpm
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
