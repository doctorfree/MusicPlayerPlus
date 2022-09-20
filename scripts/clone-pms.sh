#!/bin/bash
#
if [ -d pms ]
then
  echo "The pms directory already exists. Skipping clone of pms."
else
  git clone https://github.com/ambientsound/pms.git
fi
