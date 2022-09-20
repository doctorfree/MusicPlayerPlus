#!/bin/bash
#
if [ -d mmtc ]
then
  echo "The mmtc directory already exists. Skipping clone of mmtc."
else
  git clone https://github.com/figsoda/mmtc.git
fi
