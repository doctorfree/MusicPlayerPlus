#!/bin/bash
#

if [ -x clone-pms.sh ]
then
  ./clone-pms.sh
else
  git clone https://github.com/ambientsound/pms.git
fi

cd pms

# To build the deprecated C++ client:
# git switch 0.42.x
# cmake .
# make
# sudo make install

# To build the current Go client:
make
