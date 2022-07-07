# tmuxp configuration files

Configuration files for [tmuxp].

**[NOTE:]** Many of these were retrieved from the repository at
https://github.com/tony/tmuxp-config.git and are for reference
when creating `tmuxp` configuration files. Included here also are
*MusicPlayerPlus* `tmuxp` configuration files, e.g. `mpcplus.yaml`.

If a `tmuxp` configuration file (YAML or JSON format) is placed here
then an invocation of `tmuxp` will find it here and there is no need
to supply the `tmuxp` configuration file path on the command line.

For example, to start a tmux session using `mpcplus.yaml` with
`tmuxp` it is only necessary to issue the command:

```
tmuxp load mpcplus
```

What follows are the original repository's README instructions and
are included here for reference.

Instructions:

1.  Install [tmux].

2.  [Install tmuxp].

3.  Fork / clone this repo to `~/.dot-config`:

    ``` {.sh}
    # if forked, change the URL below to your repo
    $ git clone https://github.com/tony/tmuxp-config.git ~/.tmuxp
    ```

4.  Type `tmuxp load ~/.tmuxp/<config>.yaml`.

  [tmuxp]: https://github.com/tony/tmuxp
  [tmux]: http://tmux.sourceforge.net/
  [Install tmuxp]: http://tmuxp.readthedocs.org/en/latest/quickstart.html

## License

MIT
