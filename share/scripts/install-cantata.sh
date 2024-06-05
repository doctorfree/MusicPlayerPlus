#!/bin/bash
#

export PATH="$HOME/.local/bin:$PATH"

have_flat=$(type -p flatpak)
have_apt=$(type -p apt)
have_aptget=$(type -p apt-get)
have_dnf=$(type -p dnf)
have_yum=$(type -p yum)
have_pacman=$(type -p pacman)

[ "${have_flat}" ] || {
  if [ "${have_apt}" ] || [ "${have_aptget}" ]; then
    if [ "${have_apt}" ]; then
      sudo apt install flatpak -q -y
    else
      sudo apt-get install flatpak -q -y
    fi
  else
    if [ "${have_dnf}" ] || [ "${have_yum}" ]; then
      if [ "${have_dnf}" ]; then
        sudo dnf --assumeyes --quiet install "$1"
      else
        sudo yum --assumeyes --quiet install "$1"
      fi
    else
      if [ "${have_pacman}" ]; then
        sudo pacman -S flatpak
      else
        printf "\nUnsupported platform\n"
        exit 1
      fi
    fi
  fi
}
have_flat=$(type -p flatpak)
[ "${have_flat}" ] || {
  printf "\nCannot locate flatpak. Exiting.\n"
  exit 1
}

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install flathub dog.unix.cantata.Cantata

have_can=$(type -p cantata)
[ "${have_can}" ] || {
  [ -d ${HOME}/.local ] || mkdir -p ${HOME}/.local
  [ -d ${HOME}/.local/bin ] || mkdir -p ${HOME}/.local/bin
  echo "#!/bin/bash" > ${HOME}/.local/bin/cantata
  echo "" >> ${HOME}/.local/bin/cantata
  echo "flatpak run dog.unix.cantata.Cantata" >> ${HOME}/.local/bin/cantata
  chmod 755 ${HOME}/.local/bin/cantata
}
