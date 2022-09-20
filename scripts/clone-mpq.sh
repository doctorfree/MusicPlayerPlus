#!/bin/bash
#
if [ -d mpq ]
then
  echo "The mpq directory already exists. Skipping clone of mpq."
else
  git clone https://github.com/codesoap/mpq.git
fi
