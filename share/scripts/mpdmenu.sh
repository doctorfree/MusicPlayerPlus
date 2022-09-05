#!/bin/bash
#
# Simple dmenu frontend for MPD
#
# See https://github.com/cdown/mpdmenu
#
# Arguments:
#
# Pass mpdmenu arguments first, followed by any dmenu arguments.
# They are separated by `::`. For example:
#
#   mpdmenu -p :: -sb '#000000'
#
# `-l` is library mode (default), which descends artists and albums.
# `-p` is playlist mode, which selects a track from the current playlist.
#

all_name='[ALL]'
mode=library

d_artist() {
    mpc list artist | sort -f | dmenu -p artist "${dmenu_args[@]}"
}

d_album() {
    local artist="$1"
    local albums

    mapfile -t albums < <(mpc list album artist "$artist")
    if (( ${#albums[@]} > 1 )) ; then
        {
            printf '%s\n' "$all_name"
            printf '%s\n' "${albums[@]}" | sort -f
        } | dmenu -p album "${dmenu_args[@]}"
    else
        # We only have one album, so just use that.
        printf '%s\n' "${albums[0]}"
    fi
}

d_playlist() {
    local format="%position% %title%"
    local extra_format="(%artist% - %album%)"
    local track
    local num_extras

    # If all tracks are from the same artist and album, no need to display that
    num_extras=$(mpc playlist -f "$extra_format" | sort | uniq | wc -l)
    (( num_extras == 1 )) || format+=" $extra_format"

    track=$(mpc playlist -f "$format" | dmenu -p track "${dmenu_args[@]}")
    printf '%s' "${track%% *}"
}

i=2

for arg do
    if [[ $arg == :: ]]; then
        dmenu_args=( "${@:$i}" )
        break
    fi

    case "$arg" in
        -l) mode=library ;;
        -p) mode=playlist ;;
    esac

    let i++
done

case "$mode" in
    library)
        artist=$(d_artist)
        [[ $artist ]] || exit 1

        album=$(d_album "$artist")
        [[ $album ]] || exit 2

        mpc clear
        if [[ $album == "$all_name" ]]; then
            mpc find artist "$artist" | sort | mpc add
        else
            mpc find artist "$artist" album "$album" | sort | mpc add
        fi

        mpc play >/dev/null
    ;;
    playlist)
        mpc play "$(d_playlist)" >/dev/null
    ;;
esac
