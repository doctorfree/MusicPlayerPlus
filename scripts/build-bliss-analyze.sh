#!/bin/bash
#
# Repo: https://github.com/doctorfree/bliss-analyze
#
# Fork of Repo: https://github.com/CDrummond/bliss-analyse
#
# sudo apt install -y clang libavcodec-dev libavformat-dev \
#      libavutil-dev libavfilter-dev libavdevice-dev pkg-config
#
# Usage: ./build-bliss-analyze.sh [-i]
# Where -i indicates install bliss-analyze after configuring and compiling

usage() {
    printf "\nUsage: ./build-bliss-analyze.sh [-u]"
    printf "\nWhere:"
    printf "\n\t-u displays this usage message and exits\n"
    exit 1
}

PROJ=bliss-analyze
while getopts "u" flag; do
    case $flag in
        u)
            usage
            ;;
    esac
done
shift $(( OPTIND - 1 ))

[ -d ${PROJ} ] || git clone https://github.com/doctorfree/bliss-analyze

[ -x ${PROJ}/target/release/bliss-analyze ] && {
    echo "${PROJ}/target/release/bliss-analyze already built"
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
        echo "Cargo is required to build bliss-analyze. Exiting."
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

platform=
[ -f /etc/os-release ] && . /etc/os-release
[ "${ID_LIKE}" == "debian" ] && platform=debian
[ "${ID}" == "arch" ] && platform=arch
have_dpkg=`type -p dpkg`
[ "${have_dpkg}" ] && arch=`dpkg --print-architecture`
if [ "${arch}" == "armhf" ]
then
  cargo build --release --features=ffmpeg-next/rpi
else
  if [ "${platform}" == "debian" ]
  then
    cargo build --release
  else
    cargo build --release
  fi
fi
