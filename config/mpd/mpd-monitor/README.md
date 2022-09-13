README for mpd-monitor
======================

`mpd-monitor` is a bash script which displays the properties of an
audio stream as played by Music Player Daemon (mpd).

[![asciicast](https://asciinema.org/a/266672.svg)](https://asciinema.org/a/266672)


Besides the common mpd meta values of the current stream, like title,
artist and source (url), it displays the detailed audio properties of
the source stream or file, the way mpd interprets it, and the way the
stream is handled by alsa (and thereforehanded over to the DAC).

For each component it displays whether the audio stream is bit-perfect.

Dependencies
------------

For communication with `mpd` and `alsa` only `bash` (>= 4) is
required; the monitor uses built-in file descriptors and
sockets.

The following (extra) packages are needed:

* `mediainfo`: for determining the audio properties of (source) files. 
   See: https://mediaarea.net/en/MediaInfo. 
* `ffprobe`: for determining the audio properties for streams. 
   See https://ffmpeg.org.
* `bc`: for (floating) calculations
* `numfmt` for conversion.


Controlling the output
----------------------

Currently the output is targeted towards consoles (terminals), using
the `output-terminal` helper script.

The main script uses the [*idle* mpd
protocol](https://www.musicpd.org/doc/html/protocol.html#querying-mpd-s-status)
, so (extra) system load is kept to a minimum. Command line arguments
for other types of output (like JSON) are foreseen, but not yet
implemented. One may however surpress the mpd meta data about the
track being played, by setting the `arg_terse` variable to a non-nill
value, eg:

```bash
arg_terse=true ./mpd-monitor
```

Extra debugging information can be obtained (to `stderr`) by setting
the `DEBUG` variable to non-nill, eg:

```bash
DEBUG=true ./mpd-monitor 2>/tmp/mpd-monitor.log
tail -f /tmp/mpd-monitor.log
```

Under the hood (Using the helper scripts standalone)
----------------------------------------------------

`mpd-monitor` is the wrapper script, which using functions defined in
the following helper scripts which perform the actual information
retrieval:

1. `get-file-info`
2. `get-mpd-info`
3. `get-alsa-info`

Each of these scripts can be used standalone, although their output is
directed to `stderr`. When used standalone, each of the helper scripts
need extra command line arguments. Normally these are set/gathered by
the wrapper `mpd-monitor` script by parsing the mpd configuration
file.

1. `get-file-info` needs the file (or stream url), ie:

    ```bash
	DEBUG=true ./get-file-info /mnt/media/somefile.flac
        DEBUG=true ./get-file-info "http://icecast.vrtcdn.be/stubru-high.mp3"
    ```

2. `get-mpd-info` extracts it's needed parameters via the local
   `mpd.conf` file. In case `music_directory` points to a remote share
   (using the `nfs://` or `smb://` prefixes) the script tries to
   retrieve the same share from `/etc/fstab`. When that isn't present
   it tries to mount that share to a local temporary directory.


    ```bash
	DEBUG=true ./get-mpd-info /mnt/fileserver/media/music
    ```

3. `get-alsa-info` needs the device (card) and (playback) interface
   number, ie the `x` and `y` of the alsa device with address
   `hw:x,y`, ie:

   ```bash
   DEBUG=true ./get-alsa-info 0 0
   ```

Todo
----

* The scripts can currently only be executed on the host running mpd;
  It would make sense to add the possibility to run it from a remote
  host through ssh.
* Currently, only terminal output is working; it would make sense to
  add machine parseable output, like JSON.
* I would like more detailed output, like the properties of the
  hardware being used, and the network and such.

See the `README.md` file in the `future` branch for drafts of those ideas.


