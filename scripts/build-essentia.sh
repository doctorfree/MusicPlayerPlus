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
# On RPM based systems like Fedora Linux, dependencies include:
#   fftw3-devel libtool automake iniparser-devel
#   SDL2-devel eigen3-devel libyaml-devel
#   ffmpeg-devel libchromaprint-devel python-devel
#   python3-devel python3-yaml python3-six
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
#
# MusicPlayerPlus Essentia builds disable Tensorflow by default.
# Use the "-t" option to this script to enable Tensorflow support.
# However:
#
# Note: TensorFlow binaries use AVX instructions which may not run on older CPUs
# The following GPU-enabled devices are supported:
#  - NVIDIA® GPU card with CUDA® architectures 3.5, 5.0, 6.0, 7.0, 7.5, 8.0
#    and higher. See the list of CUDA®-enabled GPU cards.
#  - For GPUs with unsupported CUDA® architectures, or to avoid JIT compilation
#    from PTX, or to use different versions of the NVIDIA® libraries,
#    see the Linux build from source guide.
#  - Packages do not contain PTX code except for the latest supported CUDA®
#    architecture; therefore, TensorFlow fails to load on older GPUs when
#    CUDA_FORCE_PTX_JIT=1 is set. (See Application Compatibility for details.)
#
# Note: The error message "Status: device kernel image is invalid" indicates
# that the TensorFlow package does not contain PTX for your architecture.
# You can enable compute capabilities by building TensorFlow from source.
#
# Note: GPU support is available for Ubuntu and Windows with CUDA®-enabled cards.

usage() {
  printf "\nUsage: ./build-essentia.sh [-Ci] [-d destdir] [-p prefix] [-t] [-u]"
  printf "\nWhere:"
  printf "\n\t-C indicates run configure and exit"
  printf "\n\t-d destdir specifies installation destination root (default /)"
  printf "\n\t-i indicates configure, build, and install"
  printf "\n\t-p prefix specifies installation prefix (default /usr)"
  printf "\n\t-t indicates configure with tensorflow support"
  printf "\n\t-u displays this usage message and exits\n"
  printf "\nNo arguments: configure, build\n"
  exit 1
}

PROJ=essentia
CONFIGURE_ONLY=
INSTALL=
PREFIX=
DESTDIR=
TENSOR=
while getopts "Cd:ip:tu" flag; do
    case $flag in
        C)
            CONFIGURE_ONLY=1
            ;;
        d)
            DESTDIR="${OPTARG}"
            ;;
        i)
            INSTALL=1
            ;;
        p)
            PREFIX="${OPTARG}"
            ;;
        t)
            TENSOR=1
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

destdir=
prefix="--prefix=/usr"
tensor=
[ "${DESTDIR}" ] && destdir="--destdir=${DESTDIR}"
[ "${PREFIX}" ] && prefix="--prefix=${PREFIX}"
[ "${TENSOR}" ] && tensor="--with-tensorflow"

[ "${INSTALL}" ] || {
  [ -x ${PROJ}/build/src/examples/essentia_streaming_extractor_music ] && {
    echo "Essentia binaries already built"
    exit 0
  }
}

PKGPATH=`pkg-config --variable pc_path pkg-config`
[ -d /usr/lib/ffmpeg4.4/pkgconfig ] && {
  PKGPATH="/usr/lib/ffmpeg4.4/pkgconfig:${PKGPATH}"
}
export PKG_CONFIG_PATH="${PKGPATH}:/usr/lib/pkgconfig"

cd ${PROJ}
python3 waf configure ${prefix} --build-static \
                                --with-python ${tensor} \
                                --with-gaia \
                                --with-example=streaming_extractor_music

[ "${CONFIGURE_ONLY}" ] && exit 0

python3 waf

if [ "${INSTALL}" ]
then
    python3 waf install ${destdir}
fi

