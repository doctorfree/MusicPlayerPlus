#!/usr/bin/env bash
#
# install-spotify-player - install the command line Spotify player

export PATH=/opt/homebrew/bin:${HOME}/.local/bin:${PATH}
SED="sed"
have_gsed=$(type -p gsed)
[ "${have_gsed}" ] && SED="gsed"

[ "$1" == "remove" ] && {
  printf "\nRemoving spotify_player ..."
  rm -rf ${HOME}/.config/spotify-player
  rm -rf ${HOME}/.cache/spotify-player
  rm -f ${HOME}/.cargo/bin/spotify_player
  printf " done\n"
  exit 0
}

if command -v spotify_player >/dev/null 2>&1; then
  printf "\n\tUsing existing spotify_player installation.\n"
  exit 0
fi

printf "\nA Premium Spotify account is required for Spotify Player."
printf "\nDo you wish to continue with installation of Spotify Player?\n"
while true; do
  read -r -p "Continue with installation ? (y/n) " yn
  case $yn in
    [Yy]*)
      break
      ;;
    [Nn]*)
      printf "\nAborting installation of Spotify Player\n"
      exit 0
      ;;
    *)
      printf "\nPlease answer yes or no.\n"
      ;;
  esac
done

auth_spotify() {
  printf "\n\nAuthenticating with Spotify"
  printf "\nYou can find your Spotify username in Account -> Edit profile in Spotify\n\n"
  spotify_player authenticate
}

have_brew=
platform=$(uname -s)
[ "${platform}" == "Darwin" ] && have_brew=$(type -p brew)
have_curl=$(type -p curl)
[ "${have_brew}" ] && {
  brew update --quiet >/dev/null 2>&1
  printf "\n\tInstalling spotify_player with Homebrew, please be patient ..."
  brew install --quiet "spotify_player" >/dev/null 2>&1
  have_spot=$(type -p spotify_player)
  [ "${have_spot}" ] && {
    printf " done\n"
    auth_spotify
    exit 0
  }
  printf " fail\n"
}
if command -v "cargo" >/dev/null 2>&1; then
  if [ "${have_brew}" ]; then
    printf "\n\tUpdating rust, please be patient ..."
    brew upgrade --quiet "rust" >/dev/null 2>&1
    printf " done\n"
  else
    have_rust=$(type -p rustup)
    [ "${have_rust}" ] && {
      printf "\n\tUpdating rustc, please be patient ..."
      rustup update >/dev/null 2>&1
      printf " done\n"
    }
  fi
else
  printf "\n\tInstalling cargo ..."
  if [ "${have_brew}" ]; then
    brew install --quiet "rust" >/dev/null 2>&1
  # [ $? -eq 0 ] || brew link --overwrite --quiet "rust" >/dev/null 2>&1
  else
    [ "${have_curl}" ] || {
      printf "\n\tCargo installation requires either Homebrew or curl."
      printf "\n\tExiting without installing spotify_player.\n"
      exit 1
    }
    RUST_URL="https://sh.rustup.rs"
    curl -fsSL "${RUST_URL}" >/tmp/rust-$$.sh
    [ $? -eq 0 ] || {
      rm -f /tmp/rust-$$.sh
      curl -kfsSL "${RUST_URL}" >/tmp/rust-$$.sh
      [ -f /tmp/rust-$$.sh ] && {
        cat /tmp/rust-$$.sh | ${SED} -e "s/--show-error/--insecure --show-error/" >/tmp/ins$$
        cp /tmp/ins$$ /tmp/rust-$$.sh
        rm -f /tmp/ins$$
      }
    }
    [ -f /tmp/rust-$$.sh ] && sh /tmp/rust-$$.sh -y >/dev/null 2>&1
    rm -f /tmp/rust-$$.sh
  fi
  printf " done"
fi
if ! command -v "cargo" >/dev/null 2>&1; then
  [ -x "${HOME}"/.cargo/bin/cargo ] && {
    export PATH="$HOME/.cargo/bin:$PATH"
  }
fi

if ! command -v spotify_player >/dev/null 2>&1; then
  if command -v "cargo" >/dev/null 2>&1; then
    printf "\n\tInstalling spotify_player with cargo, please be patient ..."
    cargo install spotify_player --features fzf,image,sixel,notify >/dev/null 2>&1
    printf " done\n"
    if command -v spotify_player >/dev/null 2>&1; then
      auth_spotify
    fi
  else
    printf "\n\tCannot locate cargo. Skipping installation of spotify_player.\n"
    exit 1
  fi
else
  printf "\n\tUsing existing spotify_player installation.\n"
fi

exit 0
