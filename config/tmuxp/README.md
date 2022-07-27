# MusicPlayerPlus tmuxp configuration files

MusicPlayerPlus configuration files for `tmuxp`.

These tmuxp configuration files are copied into the user's
`~/.config/tmuxp/` folder by the MusicPlayerPlus initialization
utility `mppinit`.

If a `tmuxp` configuration file (YAML or JSON format) is located
in `~/.config/tmuxp/` then an invocation of `tmuxp` will find it
and there is no need to supply the `tmuxp` configuration file path
or configuration filename suffix on the command line.

For example, to start a tmux session using `~/.config/tmuxp/mpcplus.yaml`
with `tmuxp` it is only necessary to issue the command:

```
tmuxp load mpcplus
```

## Configuration files

The following `tmuxp` configuration files are included with MusicPlayerPlus:

- **[fzmp-env.yaml](fzmp-env.yaml)** - run the MusicPlayerPlus Fuzzy Finder and Spectrum Visualizer in a Tmux session using environment variables for session and command ssettings:

```
SESSION=fzmp FZFCOMM="fzmp -a" VIZCOMM=mppcava MAIN_PANE_HEIGHT=16 tmuxp load fzmp-env
```

- **[fzmp-tmux.yaml](fzmp-tmux.yaml)** - run the MusicPlayerPlus Fuzzy Finder and Spectrum Visualizer without gradient colors in a Tmux session:

```
tmuxp load fzmp-tmux
```

- **[fzmp.yaml](fzmp.yaml)** - run the MusicPlayerPlus Fuzzy Finder and Spectrum Visualizer with gradient colors in a Tmux session:

```
tmuxp load fzmp
```

- **[mpcplus-env.yaml](mpcplus-env.yaml)** - run the MusicPlayerPlus MPD client `mpcplus`, Fuzzy Finder, and Spectrum Visualizer in a Tmux session using environment variables for session and command ssettings:

```
SESSION=mpcplus FZFCOMM="fzmp -a" MAIN_PANE_HEIGHT=16 VIZCOMM=mppcava tmuxp load mpcplus-env
```

- **[mpcplus-tmux.yaml](mpcplus-tmux.yaml)** - run the MusicPlayerPlus MPD client `mpcplus`, Fuzzy Finder, and Spectrum Visualizer without gradient colors in a Tmux session. This tmuxp config is used by the `mpcplus-tmux` command:

```
tmuxp load mpcplus-tmux
```

- **[mpcplus.yaml](mpcplus.yaml)** - run the MusicPlayerPlus MPD client `mpcplus`, Fuzzy Finder, and Spectrum Visualizer with gradient colors in a Tmux session:

```
tmuxp load mpcplus
```

- **[mppsplash-env.yaml](mppsplash-env.yaml)** - run the MusicPlayerPlus Splash animation in a Tmux session using environment variables for session and command ssettings. This tmuxp config is used by the `mppsplash-tmux` command:

```
SESSION=mppsplash SPLASHCOMM=mppsplash tmuxp load mppsplash-env
```

- **[mppsplash.yaml](mppsplash.yaml)** - run the MusicPlayerPlus Splash animation in a Tmux session:

```
tmuxp load mppsplash
```
