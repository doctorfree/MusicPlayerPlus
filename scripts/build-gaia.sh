#!/bin/bash
#
# Repo: https://github.com/doctorfree/MusicPlayerPlus
#
# Fork of Repo: https://github.com/MTG/gaia
#
# To build and install gaia from source see the following
#
# Dependencies include:
#   build-essential libqt5-dev libyaml-dev
#   swig python-dev pkg-config libeigen3-dev
#
# On RPM bases systems like Fedora Linux, dependencies include:
#   libyaml-devel swig python-devel pkg-config eigen3-devel
#   libsamplerate-devel qt5-qtbase-devel
#
# Go into its source code directory and start by configuring the build:
#
# ./waf configure [--with-python-bindings] [--with-asserts]
#
# Usage: ./build-gaia.sh [-i]
# Where -i indicates install gaia after configuring and compiling

usage() {
    printf "\nUsage: ./build-gaia.sh [-Ci] [-p prefix] [-u]"
    printf "\nWhere:"
    printf "\n\t-C indicates run autogen, and configure and exit"
    printf "\n\t-i indicates configure, build, and install"
    printf "\n\t-p prefix specifies installation prefix (default /usr)"
    printf "\n\t-u displays this usage message and exits\n"
    printf "\nNo arguments: configure, build\n"
    exit 1
}

PROJ=gaia
CONFIGURE_ONLY=
INSTALL=
PREFIX=
while getopts "Cip:u" flag; do
    case $flag in
        C)
            CONFIGURE_ONLY=1
            ;;
        i)
            INSTALL=1
            ;;
        p)
            PREFIX="$OPTARG"
            ;;
        u)
            usage
            ;;
    esac
done
shift $(( OPTIND - 1 ))

prefix="--prefix=/usr"
[ "${PREFIX}" ] && prefix="--prefix=${PREFIX}"

[ -d ${PROJ} ] || {
    git clone https://github.com/MTG/gaia.git
}

cd ${PROJ}
git switch qt5

# Prior to configure, determine architecture and set CXXFLAGS
arch=`uname -m`
[ "${arch}" == "armv7l" ] && {
    # Remove -msse2 from CXXFLAGS
    cat wscript | sed -e "s/'-O2', '-msse2'/'-O2'/" > /tmp/wsc$$
    cp /tmp/wsc$$ wscript
    rm -f /tmp/wsc$$
}

./waf configure ${prefix} --with-python-bindings --with-asserts

[ "${CONFIGURE_ONLY}" ] && exit 0

./waf

if [ "${INSTALL}" ]
then
    sudo ./waf install
fi

