#!/bin/bash
set -e
# Music which you haven't listened to this year.
#
# We filter out things that you never listened to much (less than 5 times
# total).

cpe_local_database=${cpe_local_database-cpe tracker}
duration=${duration-1hour}

cpe lastfm-history tracks --last-play-before='1 year ago' --min-listens=5 | \
    cpe shuffle - | head -n 100 | \
    $cpe_local_database resolve-content - | \
    cpe select --constraint=type:playlist-duration,vmin:$duration,vmax:$duration - | \
    cpe export -
