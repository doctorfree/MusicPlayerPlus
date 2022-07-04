# MPD Per-User Configuration

MPD can be configured per-user. Running it as a normal user has the benefits of:

- Regrouping into one single directory ~/.config/mpd/ (or any other directory under $HOME) all the MPD configuration files.
- Avoiding unforeseen directory and file permission errors.

The MPD music and playlist directories are configured here in the file
`~/.config/mpd/mpd.conf`. These are initially set to `~/.config/mpd/music`
and `~/.config/mpd/playlists`. Edit `mpd.conf` to customize these locations.
