#!/bin/bash
set -e

# Generate a random playlist from local music collection that lasts for
# $duration.

cpe_local_database=${cpe_local_database-cpe tracker}
duration=${duration-1hour}

$cpe_local_database tracks | \
    cpe shuffle - | \
    cpe select - --constraint=type:playlist-duration,vmin:$duration,vmax:$duration | \
    cpe export -
