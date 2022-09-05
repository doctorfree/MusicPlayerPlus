#!/bin/bash

all_name='[ALL]'
mode=spotify

d_artist() {
    mpc list artist | sort -f | dmenu -p artist ${dmenu_args[@]}
}

d_album() {
    local artist="$1"
    local albums

    mapfile -t albums < <(mpc list album artist "$artist")
    if (( ${#albums[@]} > 1 )) ; then
        {
            printf '%s\n' "$all_name"
            printf '%s\n' "${albums[@]}" | sort -f
        } | dmenu -p album ${dmenu_args[@]}
    else
        # We only have one album, so just use that.
        printf '%s\n' "${albums[0]}"
    fi
}

d_playlist() {
    local format="%position% - %title% - %album% - %artist%"
    local track
    track=$(mpc playlist -f "$format" | dmenu -p track ${dmenu_args[@]})
    printf '%s' "${track%% *}"
}

" Get Spotify account playlist selection from lsplaylists. "
d_spotify_playlist() {
	local playlist
	playlist=$(mpc lsplaylists | dmenu -p Playlist: ${dmenu_args[@]})
	printf '%s' "${playlist}"
}

" Track selection. Only available after actually selecting a playlist.
  TODO: error message when no playlist was started "
d_spotify_track() {
	local format="%position% - %title% - %artist%"
	local track
	track=$(mpc playlist -f "$format"| dmenu -p Track ${dmenu_args[@]})
	printf '%s' "${track%% *}"
}

" This is the main menu "
d_spotify_swap_menu() {
	local view
	view=$(echo -e "playlist\ntrack\nsearch\npause\nplay\nskip\nstop\nprev" | dmenu -p "Main Menu" ${dmenu_args[@]})
	printf '%s' "${view}"
}


" This is the menu for searching spotify.
  The odd formatting of %file% is just to easilly cut the query to pass it to mpc "
d_spotify_search() {
	" Get type of query for easier spotify query results, passing the type into mpc search "
	local typeOfQuery=$(echo -e "album\ntrack\nartist" | dmenu -p "Search type" ${dmenu_args[@]})
	local searchQuery=$(echo | dmenu -p Search ${dmenu_args[@]})
	if [[ "$typeOfQuery" == *"album"* ]]; then
		format="%album% - %artist% - .%file%."
		result=$(mpc search -f "$format" album "$searchQuery" | dmenu -l 5 -p Search ${dmenu_args[@]})
	elif [[ "$typeOfQuery" == *"title"* ]]; then
			format="%title% - %artist% - .%file%."
			result=$(mpc search -f "$format" any "$searchQuery" | dmenu -l 5 -p Search ${dmenu_args[@]})
	else 
		format="%title% - %artist% - .%file%."
		result=$(mpc search -f "$format" title "$searchQuery" | dmenu -l 5 -p Search ${dmenu_args[@]})
	fi
	printf '%s' "${result}"
}

i=2
for arg do
    if [[ $arg == :: ]]; then
	    dmenu_args="${@:i}"
        break
    fi

    case "$arg" in
        -l) mode=library ;;
        -p) mode=playlist ;;
        -s) mode=spotify ;;
    esac

    let i++
done

case "$mode" in
    spotify)
	menuSelection="$(d_spotify_swap_menu)"
	if [[ "$menuSelection" == "playlist" ]]; then
		" Cache selection, preventing interrupting song while selecting new playlist"
		selectedtrack=$(d_spotify_playlist)
		if [[ "$selectedtrack" != "" ]]; then 
			mpc clear
			mpc load "$selectedtrack"
			mpc play 1
		fi
	elif [[ "$menuSelection" == "track" ]]; then
		selectedtrack=$(d_spotify_track)
		if [[ "$selectedtrack" != "" ]]; then 
			mpc play "$selectedtrack"
		fi
	elif [[ "$menuSelection" == "search" ]]; then
		searchquery=$(d_spotify_search)
		if [[ "$searchquery" != "" ]]; then 
			raw=$(echo $searchquery | cut -d . -f2)
			mpc clear
			mpc add "$raw"
			mpc play
		fi
	elif [[ "$menuSelection" == "play" ]]; then
		mpc play
	elif [[ "$menuSelection" == "pause" ]]; then
		mpc pause
	elif [[ "$menuSelection" == "skip" ]]; then
		mpc next
	elif [[ "$menuSelection" == "prev" ]]; then
		mpc prev
	elif [[ "$menuSelection" == "stop" ]]; then
		mpc stop
	fi
	;;
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

        mpc play >/dev/null 2>&1
    ;;
    playlist)
        mpc play "$(d_playlist)"
    ;;
esac
