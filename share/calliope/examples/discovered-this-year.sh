#!/bin/bash
set -e

[ -f ${HOME}/.venv/bin/activate ] && source ${HOME}/.venv/bin/activate

# Artists which you discovered in the last year.
#
# You may want to add `--min-listens=3` to filter out things you only played
# once or twice.

cpe lastfm-history artists --first-play-since='1 year ago'
