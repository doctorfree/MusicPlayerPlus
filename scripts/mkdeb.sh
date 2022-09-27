#!/bin/bash
PKG="musicplayerplus"
SRC_NAME="MusicPlayerPlus"
PKG_NAME="MusicPlayerPlus"
DEBFULLNAME="Ronald Record"
DEBEMAIL="ronaldrecord@gmail.com"
DESTDIR="usr"
SRC=${HOME}/src
ARCH=amd64
SUDO=sudo
GCI=

dpkg=`type -p dpkg-deb`
[ "${dpkg}" ] || {
    echo "Debian packaging tools do not appear to be installed on this system"
    echo "Are you on the appropriate Linux system with packaging requirements ?"
    echo "Exiting"
    exit 1
}
dpkg_arch=`dpkg --print-architecture`
[ "${dpkg_arch}" == "${ARCH}" ] || ARCH=${dpkg_arch}

[ -f "${SRC}/${SRC_NAME}/VERSION" ] || {
  [ -f "/builds/doctorfree/${SRC_NAME}/VERSION" ] || {
    echo "$SRC/$SRC_NAME/VERSION does not exist. Exiting."
    exit 1
  }
  SRC="/builds/doctorfree"
  GCI=1
# SUDO=
}

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

${SUDO} rm -rf dist
mkdir dist

[ -d ${OUT_DIR} ] && rm -rf ${OUT_DIR}
mkdir ${OUT_DIR}
cp -a pkg/debian ${OUT_DIR}/DEBIAN
chmod 755 ${OUT_DIR} ${OUT_DIR}/DEBIAN ${OUT_DIR}/DEBIAN/*

echo "Package: ${PKG}
Version: ${PKG_VER}-${PKG_REL}
Section: sound
Priority: optional
Architecture: ${ARCH}
Depends: alsa-utils, bc, coreutils, curl, flac, jq, libboost-all-dev (>= 1.71.0), libcurl4 (>= 7.68.0), libmpdclient2 (>= 2.9), libncursesw6 (>= 6), libreadline8 (>= 6.0), libtag1v5 (>= 1.11), libtinfo6 (>= 6), mediainfo, mpd (>= 0.21.20), tmux, ffmpeg, inotify-tools, figlet, fzf, mpc, python3-dev, python3-pip, mplayer, libchromaprint-dev, dconf-cli, uuid-runtime, libeigen3-dev, libfftw3-dev, libsamplerate0, libiniparser-dev, libyaml-dev, libasound2, libpulse-dev, libcurl4-openssl-dev, libsqlite3-0 (>= 3.6.0), libavformat58 (>= 7:4.1), libavfilter7 (>= 7:4.0), libswresample3 (>= 7:4.0), libavcodec58 (>= 7:4.2), libswscale5 (>= 7:4.0), libavdevice58 (>= 7:4.0), libavutil56 (>= 7:4.0), wget, wmctrl, x11-utils, x11-xserver-utils
Maintainer: ${DEBFULLNAME} <${DEBEMAIL}>
Installed-Size: 35000
Build-Depends: debhelper (>= 11)
Provides: mpd-client
Suggests: desktop-file-utils
Homepage: https://github.com/doctorfree/MusicPlayerPlus
Description: Music Player Plus
 Music server, player, and services management system" > ${OUT_DIR}/DEBIAN/control

chmod 644 ${OUT_DIR}/DEBIAN/control

for dir in "${DESTDIR}" "${DESTDIR}/share" "${DESTDIR}/share/man" \
           "${DESTDIR}/share/applications" "${DESTDIR}/share/doc" \
           "${DESTDIR}/share/doc/${PKG}" "${DESTDIR}/share/${PKG}" \
           "${DESTDIR}/share/consolefonts" "${DESTDIR}/share/${PKG}/mpcplus"
do
    [ -d ${OUT_DIR}/${dir} ] || ${SUDO} mkdir ${OUT_DIR}/${dir}
    ${SUDO} chown root:root ${OUT_DIR}/${dir}
done

for dir in bin
do
    [ -d ${OUT_DIR}/${DESTDIR}/${dir} ] && ${SUDO} rm -rf ${OUT_DIR}/${DESTDIR}/${dir}
done

${SUDO} cp -a bin ${OUT_DIR}/${DESTDIR}/bin
${SUDO} cp mppcava/mppcava ${OUT_DIR}/${DESTDIR}/bin/mppcava
${SUDO} cp mppcava/mppcava.psf ${OUT_DIR}/${DESTDIR}/share/consolefonts

${SUDO} cp *.desktop "${OUT_DIR}/${DESTDIR}/share/applications"
${SUDO} cp copyright ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp LICENSE ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp NOTICE ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp AUTHORS ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp CHANGELOG.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} cp README.md ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}
${SUDO} pandoc -f gfm README.md | ${SUDO} tee ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/README.html > /dev/null
${SUDO} gzip -9 ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/CHANGELOG.md

${SUDO} cp -a share/alsa-capabilities ${OUT_DIR}/${DESTDIR}/share/doc/${PKG}/alsa-capabilities

${SUDO} cp asound.conf.tmpl ${OUT_DIR}/${DESTDIR}/share/${PKG}
${SUDO} cp config/default_cover.png ${OUT_DIR}/${DESTDIR}/share/${PKG}/mpcplus
${SUDO} cp config/fzmp.conf ${OUT_DIR}/${DESTDIR}/share/${PKG}/mpcplus

${SUDO} cp -a share/scripts ${OUT_DIR}/${DESTDIR}/share/${PKG}/scripts
${SUDO} cp -a share/calliope ${OUT_DIR}/${DESTDIR}/share/${PKG}/calliope

${SUDO} cp config/xterm-24bit.src ${OUT_DIR}/${DESTDIR}/share/${PKG}
${SUDO} cp config/tmux.conf ${OUT_DIR}/${DESTDIR}/share/${PKG}

${SUDO} cp config/mpprc ${OUT_DIR}/${DESTDIR}/share/${PKG}

${SUDO} cp -a config/beets "${OUT_DIR}/${DESTDIR}/share/${PKG}/beets"
${SUDO} cp -a beets "${OUT_DIR}/${DESTDIR}/share/${PKG}/beets/plugins"
${SUDO} cp config/calliope/* "${OUT_DIR}/${DESTDIR}/share/${PKG}/calliope"
${SUDO} cp -a config/kitty "${OUT_DIR}/${DESTDIR}/share/${PKG}/kitty"
${SUDO} cp -a config/mopidy "${OUT_DIR}/${DESTDIR}/share/${PKG}/mopidy"
${SUDO} cp -a config/mpd "${OUT_DIR}/${DESTDIR}/share/${PKG}/mpd"
${SUDO} cp -a config/mppcava "${OUT_DIR}/${DESTDIR}/share/${PKG}/mppcava"
${SUDO} cp mppcava/example_files/config ${OUT_DIR}/${DESTDIR}/share/${PKG}/mppcava/template.conf
${SUDO} cp -a config/navidrome "${OUT_DIR}/${DESTDIR}/share/${PKG}/navidrome"
${SUDO} cp -a config/tmuxp ${OUT_DIR}/${DESTDIR}/share/${PKG}/tmuxp
${SUDO} cp -a config/ueberzug ${OUT_DIR}/${DESTDIR}/share/${PKG}/mpcplus/ueberzug
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

cd dist
echo "Building ${PKG_NAME}_${PKG_VER} Debian package"
${SUDO} dpkg --build ${PKG_NAME}_${PKG_VER} ${PKG_NAME}_${PKG_VER}-${PKG_REL}.${ARCH}.deb
cd ${PKG_NAME}_${PKG_VER}
echo "Creating compressed tar archive of ${PKG_NAME} ${PKG_VER} distribution"
tar cf - usr | gzip -9 > ../${PKG_NAME}_${PKG_VER}-${PKG_REL}.tgz

have_zip=`type -p zip`
[ "${have_zip}" ] || {
  ${SUDO} apt-get update
  ${SUDO} apt-get install zip -y
}
echo "Creating zip archive of ${PKG_NAME} ${PKG_VER} distribution"
zip -q -r ../${PKG_NAME}_${PKG_VER}-${PKG_REL}.zip usr

cd ..
[ "${GCI}" ] || {
    [ -d ../releases ] || mkdir ../releases
    [ -d ../releases/${PKG_VER} ] || mkdir ../releases/${PKG_VER}
    ${SUDO} cp *.deb *.tgz *.zip ../releases/${PKG_VER}
}
