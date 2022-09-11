#!/bin/bash
#
# install-dev-env.sh - install or remove the build dependencies

debian=
arch=
[ -f /etc/os-release ] && . /etc/os-release
[ "${ID_LIKE}" == "debian" ] && debian=1
[ "${ID}" == "arch" ] && arch=1
[ "${debian}" ] || [ -f /etc/debian_version ] && debian=1

if [ "${debian}" ]
then
  PKGS="build-essential libeigen3-dev libfftw3-dev clang ffmpeg \
        libavcodec-dev libavformat-dev libavutil-dev libswresample-dev \
        libsamplerate0-dev libtag1-dev libchromaprint-dev libmpdclient-dev \
        autotools-dev autoconf libtool libboost-all-dev fftw-dev \
        libiniparser-dev libyaml-dev swig python3-dev pkg-config \
        libncurses-dev libasound2-dev libreadline-dev libpulse-dev \
        libcurl4-openssl-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
        libavfilter-dev libavdevice-dev libsqlite3-dev pandoc zip"
  if [ "$1" == "-r" ]
  then
    sudo apt remove ${PKGS}
  else
    sudo apt install ${PKGS}
  fi
else
  if [ "${arch}" ]
  then
    PKGS="base-devel eigen fftw clang ffmpeg4.4 libsamplerate taglib \
          chromaprint libmpdclient boost boost-libs iniparser libyaml swig \
          alsa-lib ncurses readline libpulse libcurl-compat sqlite qt5-base \
          qt5-tools python python-numpy python-six pandoc sndio zip cargo"
    RUN_PKGS="mpd inotify-tools figlet cool-retro-term \
          fzf mpc python-pip mplayer dconf"
    if [ "$1" == "-r" ]
    then
      sudo pacman -Rs ${RUN_PKGS}
    else
      sudo pacman -S --needed ${PKGS} ${RUN_PKGS}
    fi
  else
    PKGS="alsa-lib-devel ncurses-devel fftw3-devel qt5-qtbase-devel \
        pulseaudio-libs-devel libtool automake iniparser-devel \
        SDL2-devel eigen3-devel libyaml-devel clang-devel swig \
        libchromaprint-devel python-devel python3-devel python3-yaml \
        python3-six sqlite-devel pandoc zip"
    if [ "$1" == "-r" ]
    then
      sudo dnf remove ffmpeg-devel
      sudo dnf remove ${PKGS}
      sudo dnf remove gcc-c++
      sudo dnf groupremove "Development Tools" "Development Libraries"
    else
      sudo dnf -y groupinstall "Development Tools" "Development Libraries"
      sudo dnf -y install gcc-c++
      sudo dnf -y install ${PKGS}
      FEDVER=`rpm -E %fedora`
      FUSION="https://download1.rpmfusion.org"
      FREE="free/fedora"
      NONFREE="nonfree/fedora"
      RELRPM="rpmfusion-free-release-${FEDVER}.noarch.rpm"
      NONRPM="rpmfusion-nonfree-release-${FEDVER}.noarch.rpm"
      sudo dnf -y install ${FUSION}/${FREE}/${RELRPM}
      sudo dnf -y install ${FUSION}/${NONFREE}/${NONRPM}
      sudo dnf -y install ffmpeg-devel
    fi
  fi
fi

# Cargo is a build dependency on Arch
[ "${arch}" ] || {
  have_cargo=`type -p cargo`
  if [ "$1" == "-r" ]
  then
    [ "${have_cargo}" ] && rustup self uninstall
  else
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
  fi
}
