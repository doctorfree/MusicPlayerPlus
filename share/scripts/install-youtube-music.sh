#!/bin/bash
#
# Install youtube-music client
#
# https://github.com/th-ch/youtube-music/releases/download/v3.3.10/youtube-music_3.3.10_amd64.deb
# https://github.com/th-ch/youtube-music/releases/download/v3.3.10/youtube-music-3.3.10.x86_64.rpm

set_download_url() {
  API_URL="https://api.github.com/repos/${OWNER}/${PROJECT}/releases/latest"
  [ "${have_curl}" ] && [ "${have_jq}" ] && {
    DL_URL=$(curl --silent ${AUTH_HEADER} "${API_URL}" \
      | jq --raw-output '.assets | .[]?.browser_download_url' \
      | grep "${arch}\.${pkg}$")
  }
}

get_release() {
  DL_URL=
  set_download_url
  echo "${DL_URL}" | awk -F '/' '{ print $8 }'
}

install_package() {
  if [ "${pkg}" == "deb" ]; then
    if [ "${have_apt}" ]; then
      sudo apt install "$1" -q -y
    else
      sudo apt-get install "$1" -q -y
    fi
  else
    if [ "${have_dnf}" ]; then
      sudo dnf --assumeyes --quiet install "$1"
    else
      sudo yum --assumeyes --quiet install "$1"
    fi
  fi
}

install_youtube_music() {
  DL_URL=
  set_download_url
  [ "${DL_URL}" ] && {
    [ "${have_wget}" ] && {
      printf "\nDownloading youtube-music release asset ..."
      TEMP_ASS="$(mktemp --suffix=.${pkg})"
      wget --quiet -O "${TEMP_ASS}" "${DL_URL}" > /dev/null 2>&1
      chmod 644 "${TEMP_ASS}"
      install_package "${TEMP_ASS}"
      rm -f "${TEMP_ASS}"
      printf " done\n"
    }
  }
}

remove_youtube_music() {
  if [ "${pkg}" == "deb" ]; then
    if [ "${have_apt}" ]; then
      sudo apt remove youtube-music -q -y
    else
      sudo apt-get remove youtube-music -q -y
    fi
  else
    if [ "${have_dnf}" ]; then
      sudo dnf --assumeyes --quiet remove youtube-music
    else
      sudo yum --assumeyes --quiet remove youtube-music
    fi
  fi
}

# Use a Github API token if one is set
[ "${GITHUB_TOKEN}" ] || {
  [ "${GH_API_TOKEN}" ] && export GITHUB_TOKEN="${GH_API_TOKEN}"
  [ "${GITHUB_TOKEN}" ] || {
    [ "${GH_TOKEN}" ] && export GITHUB_TOKEN="${GH_TOKEN}"
  }
}
if [ "${GITHUB_TOKEN}" ]; then
  AUTH_HEADER="-H \"Authorization: Bearer ${GITHUB_TOKEN}\""
else
  AUTH_HEADER=
fi

have_curl=$(type -p curl)
have_jq=$(type -p jq)
have_wget=$(type -p wget)
have_apt=$(type -p apt)
have_aptget=$(type -p apt-get)
have_dnf=$(type -p dnf)
have_yum=$(type -p yum)

arch=amd64
if [ "${have_apt}" ] || [ "${have_aptget}" ]; then
  pkg="deb"
else
  if [ "${have_dnf}" ] || [ "${have_yum}" ]; then
    pkg="rpm"
  else
    pkg=
  fi
fi
[ "${pkg}" == "rpm" ] && arch=x86_64

OWNER=th-ch
PROJECT=youtube-music

[ "$1" == "remove" ] && {
  remove_youtube_music
  exit 0
}

[ "$1" == "version" ] && {
  get_release
  exit 0
}

arm=
mach=$(uname -m)
[ "${mach}" == "arm64" ] && arm=1
[ "${arm}" ] && {
  echo "Arm architecture not yet supported. Exiting."
  exit 1
}
[ "${pkg}" ] || {
  echo "OS package format not yet supported. Exiting."
  exit 1
}

install_youtube_music
