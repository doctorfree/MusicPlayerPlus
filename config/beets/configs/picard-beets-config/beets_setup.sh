#!/bin/bash

set -euo pipefail

# Beets
pip3 install beets

# Chromaprint
pip3 install pyacoustid
sudo apt install -y libchromaprint-tools ffmpeg

# Fetchart
pip3 install requests

# LastImport
pip3 install pylast
