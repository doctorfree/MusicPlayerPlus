---
title: MPCPLUS-TMUX
section: 1
header: User Manual
footer: mpcplus-tmux 1.0.0
date: March 26, 2022
---
# NAME
mpcplus-tmux - runs mpcplus, a visualizer, and displays album art in a tmux session

# SYNOPSIS
**mpcplus-tmux** [-a] [-p script] [-r] [-u]

**NOTE:** `mpcplus-tmux` can be run by invoking `mpplus [-a] [-p script] [-R]`

# DESCRIPTION
The *mpcplus-tmux* command opens several panes in a terminal window,
executing the mpcplus MPD client in one pane, a visualizer in another pane,
and displaying album cover art in another pane. The album cover art
automatically updates when another album is selected in the MPD client pane.
The visualizer pane displays, by default, the cava spectrum visualizer.
Alternately, the visualizer pane can display a Python ASCIImatics visualization.

# COMMAND LINE OPTIONS
**-a**
: Indicates display album cover art

**-p script**
: Specifies a python script to run in the visualizer pane. Available scripts are "julia", "plasma", and "mpplus".

**-r**
: Indicates record tmux session with asciinema (album cover art not recorded)

**-u**
: Displays this usage message and exits

**Defaults:**
: cover art disabled, python art disabled, recording disabled

# EXAMPLES
**mpcplus-tmux**
: Without options, *mpcplus-tmux* displays the mpcplus MPD client and cava spectrum visualizer in a tmux session. 

**mpcplus-tmux -a**
: With the -a option, *mpcplus-tmux* displays the mpcplus MPD client, cava spectrum visualizer, and album cover art in a tmux session. 

**mpcplus-tmux -p plasma**
: With the -p plasma option, *mpcplus-tmux* displays the mpcplus MPD client and plasma ASCIImatics display in a tmux session. 

**mpcplus-tmux -r**
: With the -r option, *mpcplus-tmux* displays the mpcplus MPD client and cava spectrum visualizer in a tmux session and records the session using asciinema. Recordings are stored in the user's `$HOME/Videos/` folder.

# TMUX USAGE

start new:

    tmux

start new with session name:

    tmux new -s myname

attach:

    tmux a  #  (or at, or attach)

attach to named:

    tmux a -t myname

list sessions:

    tmux ls

kill session:

    tmux kill-session -t myname

Kill all the tmux sessions:

    tmux ls | grep : | cut -d. -f1 | awk '{print substr($1, 0, length($1)-1)}' | xargs kill

In tmux, hit the prefix `ctrl+b` (my modified prefix is ctrl+a) and then:

## List all shortcuts
to see all the shortcuts keys in tmux simply use the `bind-key ?` in my case that would be `CTRL-B ?`

## Sessions

    :new<CR>  new session
    s  list sessions
    $  name session

## Windows (tabs)

    c  create window
    w  list windows
    n  next window
    p  previous window
    f  find window
    ,  name window
    &  kill window

## Panes (splits) 

    %  vertical split
    "  horizontal split
    
    o  swap panes
    q  show pane numbers
    x  kill pane
    +  break pane into window (e.g. to select text by mouse to copy)
    -  restore pane from window
    ⍽  space - toggle between layouts
    <prefix> q (Show pane numbers, when the numbers show up type the key to goto that pane)
    <prefix> { (Move the current pane left)
    <prefix> } (Move the current pane right)
    <prefix> z toggle pane zoom

## Sync Panes 

You can do this by switching to the appropriate window, typing your Tmux prefix (commonly Ctrl-B or Ctrl-A) and then a colon to bring up a Tmux command line, and typing:

```
:setw synchronize-panes
```

You can optionally add on or off to specify which state you want; otherwise the option is simply toggled. This option is specific to one window, so it won’t change the way your other sessions or windows operate. When you’re done, toggle it off again by repeating the command. [tip source](http://blog.sanctum.geek.nz/sync-tmux-panes/)


## Resizing Panes

You can also resize panes if you don’t like the layout defaults. I personally rarely need to do this, though it’s handy to know how. Here is the basic syntax to resize panes:

    PREFIX : resize-pane -D (Resizes the current pane down)
    PREFIX : resize-pane -U (Resizes the current pane upward)
    PREFIX : resize-pane -L (Resizes the current pane left)
    PREFIX : resize-pane -R (Resizes the current pane right)
    PREFIX : resize-pane -D 20 (Resizes the current pane down by 20 cells)
    PREFIX : resize-pane -U 20 (Resizes the current pane upward by 20 cells)
    PREFIX : resize-pane -L 20 (Resizes the current pane left by 20 cells)
    PREFIX : resize-pane -R 20 (Resizes the current pane right by 20 cells)
    PREFIX : resize-pane -t 2 20 (Resizes the pane with the id of 2 down by 20 cells)
    PREFIX : resize-pane -t -L 20 (Resizes the pane with the id of 2 left by 20 cells)
    
    
## Copy mode:

Pressing `PREFIX [` places us in Copy mode. We can then use our movement keys to move our cursor around the screen. By default, the arrow keys work. we set our configuration file to use Vim keys for moving between windows and resizing panes so we wouldn’t have to take our hands off the home row. tmux has a vi mode for working with the buffer as well. To enable it, add this line to .tmux.conf:

    setw -g mode-keys vi

With this option set, we can use h, j, k, and l to move around our buffer.

To get out of Copy mode, we just press the ENTER key. Moving around one character at a time isn’t very efficient. Since we enabled vi mode, we can also use some other visible shortcuts to move around the buffer.

For example, we can use "w" to jump to the next word and "b" to jump back one word. And we can use "f", followed by any character, to jump to that character on the same line, and "F" to jump backwards on the line.

       Function                vi             emacs
       Back to indentation     ^              M-m
       Clear selection         Escape         C-g
       Copy selection          Enter          M-w
       Cursor down             j              Down
       Cursor left             h              Left
       Cursor right            l              Right
       Cursor to bottom line   L
       Cursor to middle line   M              M-r
       Cursor to top line      H              M-R
       Cursor up               k              Up
       Delete entire line      d              C-u
       Delete to end of line   D              C-k
       End of line             $              C-e
       Goto line               :              g
       Half page down          C-d            M-Down
       Half page up            C-u            M-Up
       Next page               C-f            Page down
       Next word               w              M-f
       Paste buffer            p              C-y
       Previous page           C-b            Page up
       Previous word           b              M-b
       Quit mode               q              Escape
       Scroll down             C-Down or J    C-Down
       Scroll up               C-Up or K      C-Up
       Search again            n              n
       Search backward         ?              C-r
       Search forward          /              C-s
       Start of line           0              C-a
       Start selection         Space          C-Space
       Transpose chars                        C-t

## Misc

    d  detach
    t  big clock
    ?  list shortcuts
    :  prompt

## Configurations Options:

    # Mouse support - set to on if you want to use the mouse
    * setw -g mode-mouse off
    * set -g mouse-select-pane off
    * set -g mouse-resize-pane off
    * set -g mouse-select-window off

    # Set the default terminal mode to 256color mode
    set -g default-terminal "screen-256color"

    # enable activity alerts
    setw -g monitor-activity on
    set -g visual-activity on

    # Center the window list
    set -g status-justify centre

    # Maximize and restore a pane
    unbind Up bind Up new-window -d -n tmp \; swap-pane -s tmp.1 \; select-window -t tmp
    unbind Down
    bind Down last-window \; swap-pane -s tmp.1 \; kill-window -t tmp

## TMUX Cheat Sheet References

* https://tmuxcheatsheet.com/
* https://gist.github.com/MohamedAlaa/2961058

# AUTHORS
Written by Ronald Record github@ronrecord.com

# LICENSING
MPCPLUS-TMUX is distributed under an Open Source license.
See the file LICENSE in the MPCPLUS-TMUX source distribution
for information on terms &amp; conditions for accessing and
otherwise using MPCPLUS-TMUX and for a DISCLAIMER OF ALL WARRANTIES.

# BUGS
Submit bug reports online at:

https://github.com/doctorfree/MusicPlayerPlus/issues

# SEE ALSO
**mpcplus**(1), **mpcpluskeys**(1)

Full documentation and sources at:

https://github.com/doctorfree/MusicPlayerPlus

