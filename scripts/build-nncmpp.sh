#!/bin/bash
#
# Build dependencies:
#   CMake, pkg-config, asciidoctor or asciidoc, libunistring-dev,
#   libncursesw5-dev, libunibilium-dev, libxrender-dev, libxft-dev,
#   fontconfig, liberty (included), termo (included)
# Runtime dependencies:
#   ncursesw, libunistring, cURL
# Optional runtime dependencies:
#   fftw3, libpulse, x11, xft, Perl + cURL (lyrics)
# 
# git clone --recursive https://git.janouch.name/p/nncmpp.git
# mkdir nncmpp/build
# cd nncmpp/build
# cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug
# make
# 
# To install the application, you can do either the usual:
# 
# make install
# 
# Or you can try telling CMake to make a package for you. For Debian it is:
# 
# cpack -G DEB
# dpkg -i nncmpp-*.deb

rm -rf nncmpp
if [ -x clone-nncmpp.sh ]
then
  ./clone-nncmpp.sh
else
  git clone --recursive https://git.janouch.name/p/nncmpp.git
fi
mkdir nncmpp/build
cd nncmpp/build
cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug
make
