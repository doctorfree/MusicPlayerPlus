#!/usr/bin/env sh
#
# mpd_songmem.sh - registers when a song is played through mpd.
#                  start it after launching mpd(1)

while true
do
	song="$(mpc -f '%artist% - %title%' current --wait)"
	songmem --register "$song"
done
