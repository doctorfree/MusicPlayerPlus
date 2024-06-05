#!/bin/bash
#
# Install ymuse MPD client
#
# https://github.com/yktoo/ymuse/releases/download/v0.22/ymuse_0.22_linux_amd64.tar.gz

set_download_url() {
  OWNER=yktoo
  PROJECT=ymuse
  API_URL="https://api.github.com/repos/${OWNER}/${PROJECT}/releases/latest"
  [ "${have_curl}" ] && [ "${have_jq}" ] && {
    DL_URL=$(curl --silent ${AUTH_HEADER} "${API_URL}" \
      | jq --raw-output '.assets | .[]?.browser_download_url' \
      | grep "linux_amd64\.tar\.gz$")
  }
}

get_ymuse_release() {
  DL_URL=
  set_download_url
  echo "${DL_URL}" | awk -F '/' '{ print $8 }'
}

install_ymuse() {
  DL_URL=
  set_download_url
  [ "${DL_URL}" ] && {
    [ "${have_wget}" ] && {
      printf "\nDownloading ymuse release asset ..."
      TEMP_ASS="$(mktemp --suffix=.tgz)"
      wget --quiet -O "${TEMP_ASS}" "${DL_URL}" > /dev/null 2>&1
      chmod 644 "${TEMP_ASS}"
      mkdir -p /tmp/muse$$
      tar -C /tmp/muse$$ -xzf "${TEMP_ASS}"
      [ -f /tmp/muse$$/*/ymuse ] && {
        [ -d ${HOME}/.local ] || mkdir -p ${HOME}/.local
        [ -d ${HOME}/.local/bin ] || mkdir -p ${HOME}/.local/bin
        rm -f ${HOME}/.local/bin/ymuse
        cp /tmp/muse$$/*/ymuse ${HOME}/.local/bin/ymuse
        chmod 755 ${HOME}/.local/bin/ymuse
      }
      [ -d /tmp/muse$$/*/resources ] && {
        [ -d ${HOME}/.local ] || mkdir -p ${HOME}/.local
        [ -d ${HOME}/.local/share ] || mkdir -p ${HOME}/.local/share
        [ -d ${HOME}/.local/share/icons ] || mkdir -p ${HOME}/.local/share/icons
        [ -d ${HOME}/Desktop ] || mkdir -p ${HOME}/Desktop
        cp -r /tmp/muse$$/*/resources/icons/* ${HOME}/.local/share/icons/
        cp /tmp/muse$$/*/resources/*.desktop ${HOME}/Desktop/
        update-icon-caches ${HOME}/.local/share/icons/hicolor/*
      }
      rm -f "${TEMP_ASS}"
      rm -rf /tmp/muse$$
      printf " done\n"
    }
  }
}

remove_ymuse() {
  rm -f ${HOME}/.local/bin/ymuse
  rm -f ${HOME}/.local/share/icons/hicolor/*/apps/com.yktoo.ymuse.png
  rm -f ${HOME}/Desktop/com.yktoo.ymuse.desktop
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

[ "$1" == "remove" ] && {
  remove_ymuse
  exit 0
}

[ "$1" == "version" ] && {
  get_ymuse_release
  exit 0
}

arm=
mach=$(uname -m)
[ "${mach}" == "arm64" ] && arm=1
[ "${arm}" ] && {
  echo "Arm architecture not yet supported. Exiting."
  exit 1
}

install_ymuse
