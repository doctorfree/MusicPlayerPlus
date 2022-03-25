#!/bin/bash
#

HERE=`pwd`
[ -d archive ] || mkdir archive
cd /usr/local
sudo tar cf - bin/mpcplus \
              share/applications/mpcplus.desktop \
              share/applications/musicplayerplus.desktop \
              share/doc/mpcplus \
              share/menu/mpcplus \
              share/man/man1/mpcplus.1 | \
sudo gzip > ${HERE}/archive/mpcplus-dist.tar.gz
