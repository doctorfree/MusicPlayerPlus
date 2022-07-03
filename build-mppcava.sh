#!/bin/bash
#
# Repo: https://github.com/doctorfree/MusicPlayerPlus
#
# Fork of Repo: https://github.com/karlstav/cava
#
# Ubuntu 18.04 or higher:
# sudo apt install libfftw3-dev libasound2-dev libncursesw5-dev \
#    libpulse-dev libtool automake libiniparser-dev libsdl2-2.0-0 libsdl2-dev
#
# Fedora:
# sudo dnf install alsa-lib-devel ncurses-devel fftw3-devel \
#    pulseaudio-libs-devel libtool iniparser-devel
#
# Usage: ./build-mppcava.sh [-i]
# Where -i indicates install mppcava after configuring and compiling

usage() {
    printf "\nUsage: ./build-mppcava.sh [-aCi] [-p prefix] [-u]"
    printf "\nWhere:"
    printf "\n\t-a indicates run autogen script and exit"
    printf "\n\t-C indicates run autogen, and configure and exit"
    printf "\n\t-i indicates configure, build, and install"
    printf "\n\t-p prefix specifies installation prefix (default /usr)"
    printf "\n\t-u displays this usage message and exits\n"
    printf "\nNo arguments: configure with prefix=/usr, no visualizer, build\n"
    exit 1
}

PROJ=mppcava
CONFIGURE_ONLY=
AUTOGEN_ONLY=
INSTALL=
PREFIX=
while getopts "aCip:u" flag; do
    case $flag in
        a)
            AUTOGEN_ONLY=1
            ;;
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

[ -d ${PROJ} ] || {
    echo "$PROJ does not exist or is not a directory."
    echo "Run: git clone https://github.com/doctorfree/MusicPlayerPlus"
    echo "Exiting"
    exit 1
}

cd ${PROJ}
[ -x ./configure ] || ./autogen.sh
[ "${AUTOGEN_ONLY}" ] && exit 0

prefix="--prefix=/usr"
[ "${PREFIX}" ] && prefix="--prefix=${PREFIX}"
./configure ${prefix}
[ "${CONFIGURE_ONLY}" ] && exit 0

make

[ "${INSTALL}" ] && sudo make install
