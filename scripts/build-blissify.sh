#!/bin/bash
#
# Repo: https://github.com/doctorfree/blissify
#
# Fork of Repo: https://github.com/Polochon-street/blissify-rs
#
# Ubuntu 18.04 or higher:
# sudo apt install libsqlite3-dev libavformat-dev libavfilter-dev \
#                  libswresample3-dev libavcodec-dev libswscale5-dev \
#                  libavdevice-dev libavutil-dev
#
# Usage: ./build-blissify.sh [-i]
# Where -i indicates install blissify after configuring and compiling

usage() {
    printf "\nUsage: ./build-blissify.sh [-u]"
    printf "\nWhere:"
    printf "\n\t-u displays this usage message and exits\n"
    exit 1
}

PROJ=blissify
while getopts "u" flag; do
    case $flag in
        u)
            usage
            ;;
    esac
done
shift $(( OPTIND - 1 ))

[ -d ${PROJ} ] || git clone https://github.com/doctorfree/blissify

[ -x ${PROJ}/target/release/blissify ] && {
    echo "${PROJ}/target/release/blissify already built"
    exit 0
}

have_cargo=`type -p cargo`
[ "${have_cargo}" ] || {
    [ -f ~/.cargo/env ] && source ~/.cargo/env
    have_cargo=`type -p cargo`
    [ "${have_cargo}" ] || {
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        [ -f ~/.cargo/env ] && source ~/.cargo/env
    }
    have_cargo=`type -p cargo`
    [ "${have_cargo}" ] || {
        echo "The cargo tool cannot be located."
        echo "Cargo is required to build blissify. Exiting."
        exit 1
    }
}

cd ${PROJ}

PKGPATH=`pkg-config --variable pc_path pkg-config`
[ -d /usr/lib/ffmpeg4.4/pkgconfig ] && {
  PKGPATH="/usr/lib/ffmpeg4.4/pkgconfig:${PKGPATH}"
}
[ -d /usr/lib64/compat-ffmpeg4/pkgconfig ] && {
  PKGPATH="/usr/lib64/compat-ffmpeg4/pkgconfig:${PKGPATH}"
}
export PKG_CONFIG_PATH="${PKGPATH}:/usr/lib/pkgconfig"

arch=
have_dpkg=`type -p dpkg`
[ "${have_dpkg}" ] && arch=`dpkg --print-architecture`
if [ "${arch}" == "armhf" ]
then
  cargo build --release --features=ffmpeg-next/rpi
else
  cargo build --release
fi
