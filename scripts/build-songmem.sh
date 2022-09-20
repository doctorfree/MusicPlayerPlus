#!/bin/bash
#

if [ -x clone-songmem.sh ]
then
  ./clone-songmem.sh
else
  git clone https://github.com/codesoap/songmem.git
fi

cd songmem

go install ./...
