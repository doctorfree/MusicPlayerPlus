# MusicPlayerPlus tmuxp configuration files

MusicPlayerPlus configuration files for `tmuxp`.

These tmuxp configuration files are copied into the user's
`~/.config/tmuxp/` folder by the MusicPlayerPlus initialization
utility `mpcinit`.

If a `tmuxp` configuration file (YAML or JSON format) is located
in `~/.config/tmuxp/` then an invocation of `tmuxp` will find it
and there is no need to supply the `tmuxp` configuration file path
or configuration filename suffix on the command line.

For example, to start a tmux session using `~/.config/tmuxp/mpcplus.yaml`
with `tmuxp` it is only necessary to issue the command:

```
tmuxp load mpcplus
```
