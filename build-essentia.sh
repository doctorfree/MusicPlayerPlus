#!/bin/bash
#
# Repo: https://github.com/doctorfree/MusicPlayerPlus
#
# Fork of Repo: https://github.com/MTG/essentia
#
# To build and install essentia from source see the following
#
# Dependencies include:
#   build-essential libeigen3-dev libyaml-dev libfftw3-dev libavcodec-dev
#   libavformat-dev libavutil-dev libswresample-dev libsamplerate0-dev
#   libtag1-dev libchromaprint-dev python3-dev python3-numpy-dev
#   python3-numpy python3-yaml python3-six
#
# Go into its source code directory and start by configuring the build:
#
# python3 waf configure --build-static --with-python --with-cpptests \
#                       --with-examples --with-vamp
#
# Use these (optional) flags:
#   --with-python to build with Python bindings,
#   --with-examples to build command line extractors based on the library,
#   --with-vamp to build Vamp plugin wrapper,
#   --with-gaia to build with Gaia support,
#   --with-tensorflow to build with TensorFlow support,
#   --mode=debug to build in debug mode,
#   --with-cpptests to build cpptests
#
# Usage: ./build-essentia.sh [-i]
# Where -i indicates install essentia after configuring and compiling

usage() {
    printf "\nUsage: ./build-essentia.sh [-Ci] [-p prefix] [-u]"
    printf "\nWhere:"
    printf "\n\t-C indicates run configure and exit"
    printf "\n\t-i indicates configure, build, and install"
    printf "\n\t-p prefix specifies installation prefix (default /usr)"
    printf "\n\t-u displays this usage message and exits\n"
    printf "\nNo arguments: configure, build\n"
    exit 1
}

PROJ=essentia
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
            PREFIX="${OPTARG}"
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

prefix="--prefix=/usr"
[ "${PREFIX}" ] && prefix="--prefix=${PREFIX}"

cd ${PROJ}
python3 waf configure ${prefix} --build-static --with-python --with-cpptests \
                      --with-examples --with-vamp

[ "${CONFIGURE_ONLY}" ] && exit 0

python3 waf

[ "${INSTALL}" ] && python3 waf install

