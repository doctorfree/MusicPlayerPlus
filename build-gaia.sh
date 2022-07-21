#!/bin/bash
#
# Repo: https://github.com/doctorfree/MusicPlayerPlus
#
# Fork of Repo: https://github.com/MTG/gaia
#
# To build and install gaia from source see the following
#
# Dependencies include:
#   build-essential libqt4-dev libyaml-dev
#   swig python-dev pkg-config libeigen3-dev
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
./waf configure ${prefix} --with-python-bindings --with-asserts

[ "${CONFIGURE_ONLY}" ] && exit 0

./waf

[ "${INSTALL}" ] && sudo ./waf install

