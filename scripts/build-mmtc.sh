#!/bin/bash
#

if [ -x clone-mmtc.sh ]
then
  ./clone-mmtc.sh
else
  git clone https://github.com/figsoda/mmtc.git
fi

cd mmtc

cargo build --release
