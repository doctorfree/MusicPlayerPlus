#!/bin/bash
set -e

[ -f ${HOME}/.venv/bin/activate ] && source ${HOME}/.venv/bin/activate

# Albums in your online collection that are missing from your local collection.

ONLINE_ALBUMS="cpe bandcamp --user ssssam collection"
LOCAL_ALBUMS="cpe tracker albums"
#LOCAL_ALBUMS="cpe beets albums"

cpe diff --scope=album <($ONLINE_ALBUMS | cpe musicbrainz annotate -) <($LOCAL_ALBUMS)
