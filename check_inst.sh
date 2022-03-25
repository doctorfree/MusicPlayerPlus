#!/bin/bash

PREFIX="/usr/local"
FILES="bin/mpcplus \
       share/applications/mpcplus.desktop \
       share/applications/musicplayerplus.desktop \
       share/doc/mpcplus/AUTHORS \
       share/doc/mpcplus/COPYING \
       share/doc/mpcplus/bindings \
       share/doc/mpcplus/changelog \
       share/doc/mpcplus/config \
       share/doc/mpcplus/copyright \
       share/doc/mpcplus/examples/bindings \
       share/doc/mpcplus/examples/config \
       share/man/man1/mpcplus.1 \
       share/menu/mpcplus"

for file in ${FILES}
do
    [ -f ${PREFIX}/${file} ] || echo "Missing $file"
done
