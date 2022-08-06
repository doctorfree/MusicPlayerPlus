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
    echo "The cargo tool cannot be located."
    echo "Cargo is required to build blissify. Exiting."
    exit 1
}

cd ${PROJ}

cargo build -r
