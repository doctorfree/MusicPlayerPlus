#!/bin/bash
set -e
# Music that you've listened to but isn't in your local collection.

cpe_local_database=${cpe_local_database-cpe tracker}

cpe diff <(cpe lastfm-history tracks --min-listens 4) <($cpe_local_database tracks)
