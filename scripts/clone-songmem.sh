#!/bin/bash
#
if [ -d songmem ]
then
  echo "The songmem directory already exists. Skipping clone of songmem."
else
  git clone https://github.com/codesoap/songmem.git
fi
