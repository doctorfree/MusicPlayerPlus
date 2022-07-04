---
layout: post
title: README for mpd-configure
---

README for mpd-configure
========================

The `mpd-configure` bash script creates a valid configuration file for
[mpd], optimised for bit perfect playback of any digital audio file,
including those of high resolution.

With default settings the script uses the first available alsa audio
interface by using its hardware address (in the form of `hw:x,y`), and
has automagic procedures for things like the music directory and
directory where files are stored, the number of items in the music
direcory and the UPNP name. When multiple audio interfaces are found,
the user is presented with a choice.

More information is available at the following pages:

- [audiophile-mpd]
- [detect-alsa-output-capabilities]


Basic usage
-----------

### Getting the script

The latest stable version of the script may be cloned from gitlab using `git`:
```bash
git clone https://gitlab.com/sonida/mpd-configure.git
```

Using git has the added benefit that updating the script to the latest
version is as easy as:

```bash
## cd /path/to/git-clone
git pull
```

Alternatively, [the tarball of the current stable
master](https://lacocina.nl/mpd-configure) can be downloaded and
unpacked in the current directory using `wget` and `tar`:

```bash
wget https://lacocina.nl/mpd-configure -O - | tar --strip-components=1 -zxf -
```


### Running the script

Run the script with default settings to display the contents of the
resulting mpd configuration file:

```bash
bash mpd-configure
```

### Storing the output of the script in a file

The output of the scripts can simply be redirected to a file (in this
example `mympd.conf`):

```bash
bash mpd-configure > mympd.conf
```

Although the same may be achieved by using the `-o` or `--output`
command line parameters or setting `CONF_MPD_CONFFILE` on the command
line. This has the benefit that the script detects if the target file
exists, in which case the user is prompted to overwrite it, while
making an automated *backup* of the original file:

```bash
bash mpd-configure -o "mympd.conf"
# or:
CONF_MPD_CONFFILE="mympd.conf" ./mpd-configure
```

### More advanced usage example

Additional setting are available using environment variables or using
the file [`./mpd-configure.conf`](./mpd-configure.conf) and
configuration snippet files in the
[`./confs-available/`](./confs-available) directory. 

For example to specify `CONF_MPD_MUSICDIR` which sets the
`music_directory` and saving the resulting mpd configuration file in
`mympd.conf`, use:

```bash
CONF_MPD_MUSICDIR="/srv/media/music" ./mpd-configure -o "/etc/mpd.conf"
```

By default `mpd-configure` prompts the user to overwrite the specified
file if it exists, and makes a backup of it.

### Fully automated usage example

A fully automated example which does not prompt the user (`-n`), uses the
first available USB Audio Class interface (`-l u`) and sets some paths, while
creating a backup of the original `/etc/mpd.conf` in case it exists:

```bash
CONF_MPD_MUSICDIR="/srv/media/music" CONF_MPD_HOMEDIR="/var/lib/mpd" \
bash mpd-configure -l u -n -o "/etc/mpd.conf"
```

To see all available command line options run the script with `-h` or `--help`:
```bash
bash mpd-configure -h
```

Also see
- [Detailed usage instructions](#detailed-usage-instructions) for
more information on the usage and available settings.
- [Usage a as systemd service](#usage-a-as-systemd-service)


About the alsa-capabilities helper script
-----------------------------------------

[`mpd-configure`](./mpd-configure) relies on the accompanying bash
script [`alsa-capabilities`](https://gitlab.com/sonida/alsa-capabilities) for getting
information about the available audio output interfaces from
alsa. 


About the mpd-monitor helper script
-----------------------------------

The `mpd-monitor` script in this project is replaced by a separate project on gitlab.

See: [mpd-monitor](https://gitlab.com/ronalde/mpd-monitor/)


Background
----------

I created this script to assist users in turning mpd in an audiophile
digital music player. See the article [How to turn Music Player Daemon
(mpd) into an audiophile music
player](https://lacocina.nl/audiophile-mpd).

It does this by creating a proper formatted `audio_output`
configuration snippet for mpd's [alsa audio output
plugin](http://www.musicpd.org/doc/user/config_audio_outputs.html)
using the sound cards hardware address and turning all options off
which might cause mpd to alter the incoming sound. For example:

````bash
## start processing `01_output-audio-alsa.conf'
audio_output {
        type             "alsa"
        name             "Peachtree 24/192 USB X - USB Audio"
        device           "hw:1,0"
        auto_resample    "no"
        auto_format      "no"
        auto_channels    "no"
}
replaygain                 "off"
mixer_type                 "none"
## done processing
````

Detailed usage instructions
---------------------------

After creating a mpd configuration file, `mpd` can be told to use this
configuration file with:

````bash
    mpd ./mpd.conf
````

To use the generated configuration file system wide, it can be copied
to the system wide mpd configuration file when you want to run `mpd`
as a system daemon:

````bash
    sudo bash mpd-configure -o "/etc/mpd.conf"
    sudo systemctl restart mpd
````

More complex usage
------------------

For debugging or testing purposes one may set the `INCLUDE_COMMENTS`
and/or `DEBUG` parameters through the `mpd-configure.conf` file or on
the command line, eg:

````bash
    DEBUG="True" INCLUDE_COMMENTS="True" bash mpd-configure
````    

In dynamic environments in which hardware may be altered each boot,
connected to whatever USB DAC, the script could be put in a logon script
or systemd service file.

## Usage a as systemd service

The script is fast and stable enough to function as a systemd
service. By setting `Before=mpd.service` and `Wants=mpd.service` in
the service file systemd makes sure mpd-configure is run before mpd is
started, and tries to start mpd.

- See: [./examples/systemd_mpd-configure.service](./examples/systemd_mpd-configure.service)


### Usage from within another bash or sh script

The bash script
[./examples/bash-example.sh](./examples/bash-example.sh)
demonstrates the way alsa-capabilities can be used from another bash
script.

This demo script returns the monitoring file of the file specified as
an argument:

````bash
bash examples/bash-example.sh hw:1,0
````

Result:
````bash
the audio card with alsa hardware address hw:1,0 can be monitored with:
/proc/asound/card1/stream0
````


### Usage from within python

Assuming your in the `mpd-configure` directory, run:
````bash
    python examples/get-interfaces.py
````

The python script
[./examples/get-interfaces.py](./examples/get-interfaces.py)
uses a helper bash script
([./examples/get-interfaces-for-python.sh](./examples/get-interfaces-for-python.sh)),
which in turn sources `alsa-capabilities`.


### LTSP-specific auto logon sample

For my LTPS-environments the script directory can be copied to the
home directory of the auto logon user specified in
`/var/lib/tftpboot/ltsp/i386/lts.conf`. It's `~/.profile` should be
edited to run the script and start `mpd` using the script generated
`~/.mpd/mpd.conf`, ie:

````bash
    systemctl stop mpd && \
    CONF_MPD_MUSICDIR="/srv/media/music" CONF_MPD_HOMEDIR="/var/lib/mpd" \
    bash ~/mpd-configure/mpd-configure -l usb -n -q --nobackup -o "~/.mpd/mpd.conf"  && \
    systemctl start mpd
````


Preferences
-----------

Preferences can be set in the file `mpd-configure.conf`. By default all
preferences are commented out.

The script uses configuration file snippets in the
[`./confs-available/`](./confs-available) directory. By symlinking
them to the [`./confs-enabled/`](./confs-enabled) directory, they will
be included by `mpd-configure` in the resulting mpd configuration
file. Any bash variable in those configuration snippets, will be
expanded to their calculated values by the script.


### General environment variables

`DEBUG`
Output values of variables and program flow to std_err for easier
debugging. Possible values:
- commented out: disabled (Default).
- `1` (or non-empty): enabled.


`INCLUDE_COMMENTS`
Include commented and empty lines from configuration snippet files in
the generated mpd configuration file:
- commentend out: disabled (Default).
- `1` (or non-empty): enabled


`CONF_MPD_CONFFILE`
Path to where the generated mpd configuration file will be
written. Possible values:
- commented out: don't write to a file (Default). One may redirect the
  output of the script using:

  bash mpd-configure > /path/to/mpd.conf

- `/path/to/mpd.conf`: use the path specified.


### Alsa and sound

`LIMIT_INTERFACE_TYPE`
A keyword which limits the type of alsa interfaces to be returned: 

Possible values:
- `usb`, `digital` or `analog`
- Comment it out (or leave it empty) to prevent filtering.

Default value:
- commented out (or empty ""): do not limit the interfaces that will be found.


`LIMIT_INTERFACE_FILTER`
The available output devices (after filtering with
`LIMIT_INTERFACE_TYPE` when applicable) may be further limited using a
regular expression (which thus is case sensentive) which should match
the output of:

    LANG=C aplay -l | grep ^card

If for example the output is like this:

    card 0: MID [HDA Intel MID], device 0: HDMI 0 [HDMI 0]
    card 1: receiv [Pink Faun USB 32/384 USB receiv], device 0: USB Audio [USB Audio]

... you could use one of the following values to match the *second* line
(which in this example matches the alsa `hw:1,1` interface, eg. the
second interface of the second sound card):

    "USB Audio"
    "[uU][sS][bB] \w+ "

but not

    "USB audio"


Possible values:
- empty or commented out: no filtering is applied
- `Some regular expression`: use the (first) interface which matches the regexp.

Default value:
- commented out (or empty ""): use the first available interface. 

Handling of pulseaudio
`OPT_DISABLE_PULSEAUDIO`
Disable pulseaudio by modifyin the current users' `~/.pulseaudio/client.conf`

Possible values:
- non-empty (`1` or "True") disables pulseaudio.
- Comment it out (or leave it empty) to prevent disabling of pulseaudio.


Default value:
- commented out (or empty ""): do not disable it.

`OPT_STOP_PULSEAUDIO`
Temporary disable and stop pulseaudio during detection of alsa
interfaces. After the script pulseaudio's client configuration and run
state will restored.

Possible values:
- non-empty (`1` or "True") temporary disables and stops pulseaudio.
- Comment it out (or leave it empty) to prevent temporary disabling
  and stopping of pulseaudio.

Default value:
- commented out (or empty ""): do not disable it.


See the configuration snippet files and accompanying `README` in
`./confs-available` for additional parameters and and explanation for
their functions.


Reference
---------

MPD specific:

- [How to turn Music Player Daemon (mpd) into an audiophile music
player](https://lacocina.nl/mpd-configure-audiophile).
- [What digital audio format does your USB DA-converter support and
  use?](https://lacocina.nl/detect-alsa-output-capabilities)
- [Music Player Daemon (MPD)](http://www.musicpd.org/)

LTSP specific:

- [How to setup a bit-perfect digital audio streaming client with free
  software (with LTSP and
  MPD)](https://lacocina.nl/how-to-setup-a-bit-perfect-digital-audio-streaming-client-with-free-software-with-ltsp-and-mpd)
- [Linux Terminal Server Project (LTSP)](http://www.ltsp.org/)


[audiophile-mpd]:  https://lacocina.nl/audiophile-mpd "mpd-configure: automatically turn Linux into an audiophile music player"
[detect-alsa-output-capabilities]: https://lacocina.nl/detect-alsa-output-capabilities "Alsa-capabilities shows which digital audio formats your USB DA-converter supports"

[mpd]: http://www.musicpd.org/ "Music Player Daemon (external website)"

