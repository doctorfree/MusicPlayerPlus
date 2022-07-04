README for configuration snippet files
======================================

This directory contains *configuration snippet files* for
`mpd-configure`, which contain configuration directives for mpd
grouped by function or domain to increase managebility.


Modifying (default) settings
----------------------------

Make sure the configuration value is specified in an enabled snippet
file (see below) while looking up the appropriate `VARIABLE
NAME` and its default value. The value marked with xxx is the default
value used by the script: `${VARNAME:-xxx}`.


```bash
grep "max_playlist_length" confs-enabled/*.conf
## returns:
confs-enabled/04_client-limits.conf:max_playlist_length    "${G_CLIENTLIMITS_MAXPLAYLISTLENGTH:-16777216}"

```

So, to change the default value for the `max_playlist_length` setting in the
resulting `mpd.conf` from `"16777216"` to `"1000"` , set the value of `G_CLIENTLIMITS_MAXPLAYLISTLENGTH` in `mpd-configure.conf` or on the command line.

```bash
# add the following line to `./mpd-configure.conf` and rerun the script
G_CLIENTLIMITS_MAXPLAYLISTLENGTH="1000"
bash mpd-configure > mpd.conf
```

Or, specify the value on the command line:

```bash
G_CLIENTLIMITS_MAXPLAYLISTLENGTH="1000" bash mpd-configure > mpd.conf
```

This way you may update the sources from upstream without losing your
preferences.


Enabling a configuration snippet file
-------------------------------------

Each file in `./confs-available/` may be enabled by symlinking it to
`../confs-enabled/` and (re-)running the `mpd-configure` script, eg:

```bash
cd mpd-configure                     # go to the root of the mpd-configure script
cd confs-enabled/                    # change to the directory with available configuration files
ln -s ../confs-available/afile.conf  # enable the settings in `somefile.conf`
cd -                                 # switch back to the 'root'
bash mpd-configure > mpd.conf        # create `mpd.conf` using all files in `./confs-enabled/*.conf
```


Disabling a configuration snippet file
--------------------------------------

Remove the symlink in `./confs-enabled/afile.conf` and rerun the script.


Adding custom files
-------------------

Any file with extension `.conf` placed in `./confs-enabled/` will be
used by the `mpd-configure` script. This way it is easy to extend the
scripts functionality and reach by providing additional confguration
snippet files.

By default, each uncommented and non-empty line in your custom file
will be copied to the resulting output, while variables in those files
will be expanded to their values.

Given a self made file `wildmidi.txt` in your home directory
(`/home/frits`) with the following contents:

```bash
decoder {
    plugin "wildmidi"
    config_file "${TIMIDITYCFG:-/etc/timidity/timidity.cfg}"
}
```

Enable it by copying or symlinking it to `confs-enabled/`:

```bash
cd mpd-configure                  ## or wherever you download the script
cp ~/wildmidi.txt confs-enabled/wildmidi.conf
```

Run the script:

```bash
TIMIDITYCFG="~/wildmidi.cfg" bash mpd-configure
```

Will produce:

```bash
# ... rest of config file
decoder {
    plugin "wildmidi"
    config_file "/home/frits/wildmidi.cfg}"
}
# ... rest of config file
```
