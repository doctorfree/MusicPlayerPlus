#!/bin/bash
#
# install-dev-env.sh - install or remove the build dependencies

debian=
[ -f /etc/os-release ] && . /etc/os-release
[ "${ID_LIKE}" == "debian" ] && debian=1
[ "${debian}" ] || [ -f /etc/debian_version ] && debian=1

if [ "${debian}" ]
then
  PKGS="build-essential libeigen3-dev libfftw3-dev clang \
        libavcodec-dev libavformat-dev libavutil-dev libswresample-dev \
        libsamplerate0-dev libtag1-dev libchromaprint-dev libmpdclient-dev \
        autotools-dev autoconf libtool libboost-all-dev fftw-dev \
        libiniparser-dev libyaml-dev swig python3-dev pkg-config \
        libncurses-dev libasound2-dev libreadline-dev libpulse-dev \
        libcurl4-openssl-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
        libavfilter-dev libavdevice-dev libsqlite3-dev"
  if [ "$1" == "-r" ]
  then
    sudo apt remove ${PKGS}
  else
    sudo apt install ${PKGS}
  fi
else
  PKGS="alsa-lib-devel ncurses-devel fftw3-devel \
        pulseaudio-libs-devel libtool automake iniparser-devel \
        SDL2-devel eigen3-devel libyaml-devel clang-devel \
        ffmpeg-devel libchromaprint-devel python-devel \
        python3-devel python3-yaml python3-six sqlite-devel"
  if [ "$1" == "-r" ]
  then
    sudo dnf remove ${PKGS}
  else
    sudo dnf install ${PKGS}
  fi
fi
