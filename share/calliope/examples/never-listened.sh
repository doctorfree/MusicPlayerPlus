#!/bin/bash
set -e

[ -f ${HOME}/.venv/bin/activate ] && source ${HOME}/.venv/bin/activate

# A playlist of music that you've never listened to.

cpe diff <(cpe tracker tracks) <(cpe lastfm-history tracks) | cpe export -
