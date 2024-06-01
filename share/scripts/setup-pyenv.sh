#!/bin/bash
#
# setup-pyenv - setup a pyenv Python virtual environment
#
# Supported platforms: macOS and Linux
# Supported login shells: Bash and Zsh
# Requires Homebrew on macOS, apt on Debian based Linux, dnf on RPM based Linux
#
# Written 22-Mar-2024 by Ronald Joe Record <ronaldrecord@gmail.com>

# Set the Python version to install in the virtual environment
PYVER="3.11"

have_brew=$(type -p brew)
have_apt=$(type -p apt)
have_dnf=$(type -p dnf)
# Set the Python executable name
PYTHON=
have_python3=$(type -p python3)
if [ "${have_python3}" ]; then
  PYTHON=python3
else
  have_python=$(type -p python)
  [ "${have_python}" ] && PYTHON=python
fi

if [[ $EUID -eq 0 ]]
then
  SUDO=
else
  SUDO=sudo
fi

plat_install() {
  if [ "${have_brew}" ]; then
    brew install $1
  else
    if [ "${have_apt}" ]; then
      ${SUDO} apt install $1 -q -y
    else
      [ "${have_dnf}" ] && ${SUDO} dnf install $1 -y
    fi
  fi
}

reminder=
[ -d ${HOME}/.pyenv ] && {
  echo "Moving existing $HOME/.pyenv to $HOME/.pyenv$$"
  mv ${HOME}/.pyenv ${HOME}/.pyenv$$
  reminder=1
  echo "Remove $HOME/.pyenv$$ after setup completes"
  printf "\nPress <Enter> to continue ... "
  read -r yn
  printf "\n"
}

if [ "${have_brew}" ]; then
  brew install pyenv
else
  have_curl=$(type -p curl)
  [ "${have_curl}" ] || plat_install curl
  curl --silent https://pyenv.run | bash
fi

if [ -n "$($SHELL -c 'echo $ZSH_VERSION')" ]; then
  SHINIT="${HOME}"/.zshrc
elif [ -n "$($SHELL -c 'echo $BASH_VERSION')" ]; then
  if [ -f "${HOME}"/.bashrc ]; then
    SHINIT="${HOME}"/.bashrc
  else
    SHINIT="${HOME}"/.bash_profile
  fi
else
  echo "WARNING: cannot determine login shell. Using $HOME/.zshrc"
  echo "Manual edit to shell initialization file may be needed."
  SHINIT="${HOME}"/.zshrc
fi
grep PYENV_ROOT ${SHINIT} > /dev/null || {
  echo '[ -d $HOME/.pyenv ] && export PYENV_ROOT="$HOME/.pyenv"' >> ${SHINIT}
  echo '[ -d $HOME/.pyenv/bin ] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ${SHINIT}
  echo -e 'if command -v pyenv > /dev/null; then\n  eval "$(pyenv init --path)"\nfi' >> ${SHINIT}
}
[ -d $HOME/.pyenv ] && export PYENV_ROOT="$HOME/.pyenv"
[ -d $HOME/.pyenv/bin ] && export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv > /dev/null; then
  eval "$(pyenv init --path)"
fi

[ "${have_brew}" ] || {
  if [ "${have_apt}" ]; then
    ${SUDO} apt install \
            build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev \
            libsqlite3-dev libncursesw5-dev xz-utils tk-dev libxml2-dev \
            libxmlsec1-dev libffi-dev liblzma-dev -q -y
  else
    [ "${have_dnf}" ] && {
      ${SUDO} dnf groupinstall "Development Tools" -y
      ${SUDO} dnf install \
              zlib-devel bzip2 bzip2-devel readline-devel sqlite \
              sqlite-devel openssl-devel xz xz-devel libffi-devel findutils -y
    }
  fi
}

have_pyenv=$(type -p pyenv)
if [ "${have_pyenv}" ]; then
  pyenv install ${PYVER}
  pyenv global ${PYVER}
else
  echo "WARNING: pyenv not found. Check the pyenv installation and ${SHINIT}"
fi

[ "${have_brew}" ] && brew install pyenv-virtualenv
plat_install pipx
have_pipx=$(type -p pipx)
[ "${have_pipx}" ] || ${PYTHON} -m pip install --user pipx

have_pipx=$(type -p pipx)
if [ "${have_pipx}" ]; then
  pipx ensurepath
else
  echo "WARNING: pipx not found. Check the pipx installation and PATH"
fi

echo ""
echo "-----------------------------------------------------------"
echo "Python virtual environment setup in $HOME/.pyenv"
echo "Logout and login or run 'source ${SHINIT}'"
echo "Run 'pyenv install --list' to list available Python versions"
have_pyenv=$(type -p pyenv)
[ "${have_pyenv}" ] && {
  echo "Installed version(s) of Python:"
  pyenv versions
}
echo "-----------------------------------------------------------"
[ "${reminder}" ] && {
  echo "Check and remove $HOME/.pyenv$$"
}
