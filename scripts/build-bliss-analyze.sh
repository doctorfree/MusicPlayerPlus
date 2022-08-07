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
    echo "The cargo tool cannot be located."
    echo "Cargo is required to build bliss-analyze. Exiting."
    exit 1
}

cd ${PROJ}

cargo build --release
