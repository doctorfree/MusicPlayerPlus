#!/bin/bash
#

if [ -x clone-mpq.sh ]
then
  ./clone-mpq.sh
else
  git clone https://github.com/codesoap/mpq.git
fi

cd mpq

go install
