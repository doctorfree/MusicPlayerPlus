#!/bin/bash
PKG="musicplayerplus"
SRC_NAME="MusicPlayerPlus"
PKG_NAME="MusicPlayerPlus"
FULLNAME="Ronald Record"
EMAIL="ronaldrecord@gmail.com"
DESTDIR="usr"
SRC=${HOME}/src
ARCH=x86_64
SUDO=sudo
GCI=
build=1
package=1

[ "$1" == "build" ] && {
  build=1
  package=
}
[ "$1" == "package" ] && {
  build=
  package=1
}

[ "${package}" ] && {
  have_makepkg=`type -p makepkg`
  [ "${have_makepkg}" ] || {
    echo "Arch Linux packaging tools do not appear to be installed"
    echo "Are you on the appropriate Linux system with packaging requirements ?"
    echo "Exiting"
    exit 1
  }
}
arch_arch=`uname -m`
[ "${arch_arch}" == "${ARCH}" ] || ARCH=${arch_arch}

[ -f "${SRC}/${SRC_NAME}/VERSION" ] || {
  [ -f "/builds/doctorfree/${SRC_NAME}/VERSION" ] || {
    echo "$SRC/$SRC_NAME/VERSION does not exist. Exiting."
    exit 1
  }
  SRC="/builds/doctorfree"
  GCI=1
# SUDO=
}

export SRC SRC_NAME PKG_NAME PKG_VER
. "${SRC}/${SRC_NAME}/VERSION"
PKG_VER=${VERSION}
PKG_REL=${RELEASE}

umask 0022

# Subdirectory in which to create the distribution files
OUT_DIR="dist/${PKG_NAME}_${PKG_VER}"

[ -d "${SRC}/${SRC_NAME}" ] || {
    echo "$SRC/$SRC_NAME does not exist or is not a directory. Exiting."
    exit 1
}

cd "${SRC}/${SRC_NAME}"

[ "${build}" ] && {
  # Build mpcplus
  if [ -x scripts/build-mpcplus.sh ]
  then
    scripts/build-mpcplus.sh -v
  else
    cd mpcplus
    make clean
    make distclean
    [ -x ./configure ] || ./autogen.sh > /dev/null
    ./configure --prefix=/usr \
                --enable-outputs \
                --enable-clock \
                --enable-visualizer \
                --with-fftw \
                --with-taglib > configure$$.out
    make > make$$.out
    cd ..
  fi

  # Build mppcava
  if [ -x scripts/build-mppcava.sh ]
  then
    scripts/build-mppcava.sh
  else
    cd mppcava
    make clean
    make distclean
    [ -x ./configure ] || ./autogen.sh > /dev/null
    ./configure --prefix=/usr > configure$$.out
    make > make$$.out
    cd ..
  fi

  # Build bliss-analyze
  if [ -x scripts/build-bliss-analyze.sh ]
  then
    scripts/build-bliss-analyze.sh
  else
    PROJ=bliss-analyze
    [ -d ${PROJ} ] || git clone https://github.com/doctorfree/bliss-analyze
    [ -x ${PROJ}/target/release/bliss-analyze ] || {
      have_cargo=`type -p cargo`
      [ "${have_cargo}" ] || {
        echo "The cargo tool cannot be located."
        echo "Cargo is required to build bliss-analyze. Exiting."
        exit 1
      }
      cd ${PROJ}
      cargo build -r
      cd ..
    }
  fi

  # Build blissify
  if [ -x scripts/build-blissify.sh ]
  then
    scripts/build-blissify.sh
  else
    PROJ=blissify
    [ -d ${PROJ} ] || git clone https://github.com/doctorfree/blissify
    [ -x ${PROJ}/target/release/blissify ] || {
      have_cargo=`type -p cargo`
      [ "${have_cargo}" ] || {
        echo "The cargo tool cannot be located."
        echo "Cargo is required to build blissify. Exiting."
        exit 1
      }
      cd ${PROJ}
      cargo build -r
      cd ..
    }
  fi

  # Build essentia
  if [ -x scripts/build-essentia.sh ]
  then
    scripts/build-essentia.sh
  else
    cd essentia
    python3 waf configure --prefix=/usr --build-static --with-python --with-examples
    python3 waf
    cd ..
  fi
}

[ "${package}" ] && {
  ${SUDO} rm -rf dist
  mkdir dist

  [ -d ${OUT_DIR} ] && rm -rf ${OUT_DIR}
  mkdir ${OUT_DIR}
  chmod 755 ${OUT_DIR}
  cp pkg/aur/PKGBUILD dist/PKGBUILD

  for dir in "${DESTDIR}" "${DESTDIR}/share" "${DESTDIR}/share/man" \
           "${DESTDIR}/share/applications" "${DESTDIR}/share/doc" \
           "${DESTDIR}/share/doc/${PKG}" "${DESTDIR}/share/doc/${PKG}/mpcplus" \
           "${DESTDIR}/share/consolefonts" "${DESTDIR}/share/${PKG}" \
           "${DESTDIR}/share/licenses" \
           "${DESTDIR}/share/licenses/${PKG}" \
           "${DESTDIR}/share/${PKG}/mpcplus" \
           "${DESTDIR}/share/doc/${PKG}/blissify" \
           "${DESTDIR}/share/doc/${PKG}/bliss-analyze"
  do
    [ -d ${OUT_DIR}/${dir} ] || ${SUDO} mkdir ${OUT_DIR}/${dir}
    ${SUDO} chown root:root ${OUT_DIR}/${dir}
  done

  for dir in bin
  do
    [ -d ${OUT_DIR}/${DESTDIR}/${dir} ] && ${SUDO} rm -rf ${OUT_DIR}/${DESTDIR}/${dir}
  done

  ${SUDO} cp -a bin ${OUT_DIR}/${DESTDIR}/bin
  ${SUDO} cp mpcplus/src/mpcplus ${OUT_DIR}/${DESTDIR}/bin/mpcplus
  ${SUDO} cp mppcava/mppcava ${OUT_DIR}/${DESTDIR}/bin/mppcava
  ${SUDO} cp mppcava/mppcava.psf ${OUT_DIR}/${DESTDIR}/share/consolefonts
  [ -f blissify/target/release/blissify ] && {
    ${SUDO} cp blissify/target/release/blissify ${OUT_DIR}/${DESTDIR}/bin
  }
  [ -f bliss-analyze/target/release/bliss-analyze ] && {
    ${SUDO} cp bliss-analyze/target/release/bliss-analyze ${OUT_DIR}/${DESTDIR}/bin
  }
  ${SUDO} cp essentia/build/src/examples/essentia_streaming_extractor_music \
           ${OUT_DIR}/${DESTDIR}/bin
  #${SUDO} cp essentia/build/src/examples/essentia_streaming_extractor_music_svm \
  #         ${OUT_DIR}/${DESTDIR}/bin

  ${SUDO} cp *.desktop "${OUT_DIR}/${DESTDIR}/share/applications"
  ${SUDO} cp copyright ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
  ${SUDO} cp LICENSE ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
  ${SUDO} cp LICENSE ${OUT_DIR}/${DESTDIR}/share/licenses/${PKG}
  ${SUDO} cp NOTICE ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
  ${SUDO} cp CHANGELOG.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
  ${SUDO} cp README.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
  ${SUDO} pandoc -f gfm README.md | ${SUDO} tee ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/README.html > /dev/null
  ${SUDO} gzip -9 ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/CHANGELOG.md

  ${SUDO} cp mpcplus/AUTHORS ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/mpcplus
  ${SUDO} cp mpcplus/COPYING ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/mpcplus
  ${SUDO} cp mpcplus/CHANGELOG.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/mpcplus
  ${SUDO} cp mpcplus/README.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/mpcplus

  ${SUDO} cp blissify/CHANGELOG.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/blissify
  ${SUDO} cp blissify/README.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/blissify

  ${SUDO} cp bliss-analyze/ChangeLog ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/bliss-analyze
  ${SUDO} cp bliss-analyze/LICENSE ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/bliss-analyze
  ${SUDO} cp bliss-analyze/README.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/bliss-analyze

  ${SUDO} cp asound.conf.tmpl ${OUT_DIR}/${DESTDIR}/share/${PKG}
  ${SUDO} cp mpcplus/doc/config ${OUT_DIR}/${DESTDIR}/share/${PKG}/mpcplus
  ${SUDO} cp mpcplus/doc/bindings ${OUT_DIR}/${DESTDIR}/share/${PKG}/mpcplus
  ${SUDO} cp config/config-art.conf ${OUT_DIR}/${DESTDIR}/share/${PKG}/mpcplus
  ${SUDO} cp config/default_cover.png ${OUT_DIR}/${DESTDIR}/share/${PKG}/mpcplus
  ${SUDO} cp config/fzmp.conf ${OUT_DIR}/${DESTDIR}/share/${PKG}/mpcplus
  ${SUDO} cp share/mpcplus-cheat-sheet.txt ${OUT_DIR}/${DESTDIR}/share/${PKG}/mpcplus
  ${SUDO} cp share/mpcplus-cheat-sheet.md ${OUT_DIR}/${DESTDIR}/share/${PKG}/mpcplus

  ${SUDO} cp -a share/scripts ${OUT_DIR}/${DESTDIR}/share/${PKG}/scripts
  ${SUDO} cp -a share/svm_models ${OUT_DIR}/${DESTDIR}/share/${PKG}/svm_models
  ${SUDO} cp -a share/calliope ${OUT_DIR}/${DESTDIR}/share/${PKG}/calliope

  ${SUDO} cp config/xterm-24bit.src ${OUT_DIR}/${DESTDIR}/share/${PKG}
  ${SUDO} cp config/tmux.conf ${OUT_DIR}/${DESTDIR}/share/${PKG}

  ${SUDO} cp -a config/beets "${OUT_DIR}/${DESTDIR}/share/${PKG}/beets"
  ${SUDO} cp -a beets "${OUT_DIR}/${DESTDIR}/share/${PKG}/beets/plugins"
  ${SUDO} cp config/calliope/* "${OUT_DIR}/${DESTDIR}/share/${PKG}/calliope"
  ${SUDO} cp -a config/mpd "${OUT_DIR}/${DESTDIR}/share/${PKG}/mpd"
  ${SUDO} cp -a config/mppcava "${OUT_DIR}/${DESTDIR}/share/${PKG}/mppcava"
  ${SUDO} cp mppcava/example_files/config ${OUT_DIR}/${DESTDIR}/share/${PKG}/mppcava/template.conf
  ${SUDO} cp -a config/tmuxp ${OUT_DIR}/${DESTDIR}/share/${PKG}/tmuxp
  ${SUDO} cp -a config/yt-dlp "${OUT_DIR}/${DESTDIR}/share/${PKG}/yt-dlp"
  ${SUDO} cp -a music "${OUT_DIR}/${DESTDIR}/share/${PKG}/music"

  ${SUDO} cp -a man/man1 ${OUT_DIR}/${DESTDIR}/share/man/man1
  ${SUDO} cp -a man/man5 ${OUT_DIR}/${DESTDIR}/share/man/man5
  ${SUDO} cp -a share/menu "${OUT_DIR}/${DESTDIR}/share/menu"

  [ -f .gitignore ] && {
    while read ignore
    do
        ${SUDO} rm -f ${OUT_DIR}/${DESTDIR}/${ignore}
    done < .gitignore
  }

  ${SUDO} chmod 644 ${OUT_DIR}/${DESTDIR}/share/man/*/*
  ${SUDO} chmod 644 ${OUT_DIR}/${DESTDIR}/share/menu/*
  ${SUDO} chmod 755 ${OUT_DIR}/${DESTDIR}/bin/* \
                  ${OUT_DIR}/${DESTDIR}/bin \
                  ${OUT_DIR}/${DESTDIR}/share/man \
                  ${OUT_DIR}/${DESTDIR}/share/man/* \
                  ${OUT_DIR}/${DESTDIR}/share/${PKG}/scripts/*
  ${SUDO} chown -R root:root ${OUT_DIR}/${DESTDIR}

  echo "Building ${PKG_NAME}_${PKG_VER} AUR package"
  cd dist
# cd "${SRC}/${SRC_NAME}/pkg/aur"
# mv "${PKG_NAME}_${PKG_VER}" pkg
  export PKGDEST="${SRC}/${SRC_NAME}/dist"
  makepkg --repackage
  echo "Creating compressed tar archive of ${PKG_NAME} ${PKG_VER} distribution"
  cd pkg
  tar cf - usr | gzip -9 > ../${PKG_NAME}_${PKG_VER}-${PKG_REL}.tgz

  have_zip=`type -p zip`
  [ "${have_zip}" ] || ${SUDO} pacman -S zip
  echo "Creating zip archive of ${PKG_NAME} ${PKG_VER} distribution"
  zip -q -r ../${PKG_NAME}_${PKG_VER}-${PKG_REL}.zip usr

  cd ..
  [ "${GCI}" ] || {
    [ -d ../releases ] || mkdir ../releases
    [ -d ../releases/${PKG_VER} ] || mkdir ../releases/${PKG_VER}
    ${SUDO} cp *.tgz *.zip ../releases/${PKG_VER}
  }
}
