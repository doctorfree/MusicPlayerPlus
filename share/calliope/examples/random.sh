#!/bin/bash
set -e

[ -f ${HOME}/.venv/bin/activate ] && source ${HOME}/.venv/bin/activate

# Generate a random playlist from local music collection that lasts for
# $duration.

cpe_local_database=${cpe_local_database-cpe tracker}
duration=${duration-1hour}

$cpe_local_database tracks | \
    cpe shuffle - | \
    cpe select - --constraint=type:playlist-duration,vmin:$duration,vmax:$duration | \
    cpe export -
