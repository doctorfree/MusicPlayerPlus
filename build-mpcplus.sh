#!/bin/bash
#
# Repo: https://github.com/doctorfree/MusicPlayerPlus
#
# Fork of Repo: https://github.com/ncmpcpp/ncmpcpp
# Original Project: https://rybczak.net/ncmpcpp/
#
# To install original ncmpcpp:
# sudo apt install ncmpcpp
#
# To build and install mpcplus from source see the following
#
# Dependencies include:
# sudo apt install libboost
# sudo apt install libboost-all-dev
# sudo apt install libmpdclient-dev
# sudo apt install libcurl4-openssl-dev
# sudo apt install libfftw3-dev
# sudo apt install libtag1-dev
#
# Configure options include:
# --enable-outputs        Enable outputs screen [default=no]
# --enable-visualizer     Enable music visualizer screen [default=no]
# --enable-clock          Enable clock screen [default=no]
#
# Usage: ./build-mpcplus.sh [-i]
# Where -i indicates install mpcplus after configuring and compiling

usage() {
    printf "\nUsage: ./build-mpcplus.sh [-aCiv] [-p prefix] [-u]"
    printf "\nWhere:"
    printf "\n\t-a indicates run autogen script and exit"
    printf "\n\t-C indicates run autogen, and configure and exit"
    printf "\n\t-i indicates configure, build, and install"
    printf "\n\t-v indicates configure with visualizer"
    printf "\n\t-p prefix specifies installation prefix (default /usr)"
    printf "\n\t-u displays this usage message and exits\n"
    printf "\nNo arguments: configure with prefix=/usr, no visualizer, build\n"
    exit 1
}

PROJ=mpcplus
CONFIGURE_ONLY=
AUTOGEN_ONLY=
INSTALL=
PREFIX=
VISUAL="--disable-visualizer"
while getopts "aCip:uv" flag; do
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
        v)
            VISUAL="--enable-visualizer --with-fftw"
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

[ -x ${PROJ}/src/mpcplus ] && {
    echo "${PROJ}/src/mpcplus already built"
    exit 0
}

cd ${PROJ}
[ -x ./configure ] || ./autogen.sh
[ "${AUTOGEN_ONLY}" ] && exit 0

prefix="--prefix=/usr"
[ "${PREFIX}" ] && prefix="--prefix=${PREFIX}"
./configure ${prefix} \
            --enable-outputs \
            --enable-clock \
            ${VISUAL} \
            --with-taglib
[ "${CONFIGURE_ONLY}" ] && exit 0

make

[ "${INSTALL}" ] && sudo make install
