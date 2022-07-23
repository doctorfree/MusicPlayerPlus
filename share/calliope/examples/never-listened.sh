#!/bin/bash
set -e
# A playlist of music that you've never listened to.

cpe diff <(cpe tracker tracks) <(cpe lastfm-history tracks) | cpe export -
