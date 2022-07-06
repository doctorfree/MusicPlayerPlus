#!/bin/sh
# ENV variables accepted:
# PYBOOTSTRAP_DIR: directory of your configs
if [ "$ZSH_EVAL_CONTEXT" = "toplevel" ] \
    || ([ -n $BASH_VERSION ] && [ $0 != "$BASH_SOURCE" ] ) \
    ; then
    sourced=on
else
    sourced=off
fi

if [ -n "$ZSH_VERSION" ]; then
    setopt shwordsplit
fi

# In case quitting from script while sourcing
_quit() {
    if [ "$sourced" = "on" ]; then 
        return $1
    else
        exit $1
    fi
}

# TODO: bootstrap bootstrap, check for pip, install pystrap

# this step is needed because only shell can source into an environment.
#project_config_dir="$( python bootstrap_env.py $@ --get-project-config)"

my_needed_commands="git python"

missing_counter=0
for needed_command in $my_needed_commands; do
  if ! command -v "$needed_command" >/dev/null 2>&1; then
    echo "Command not found in PATH: $needed_command\n" >&2
    missing_counter=$(( missing_counter += 1 ))
  fi
done

if [ $missing_counter -gt 0 ]; then
  echo "Minimum $missing_counter commands are missing in PATH, aborting.\n" >&2
  _quit 1
fi

if env | grep -q ^VIRTUAL_ENV=
then
    in_virtualenv="in_virtualenv"
fi

if [ -n "$in_virtualenv" ]; then 
    echo "You are already in a virtualenv";
    _quit 1
fi

if command -v virtualenv > /dev/null 2>&1
then
    has_virtualenv="has_virtualenv"
fi

if env | grep -q ^PYENV_ROOT=
then
    has_pyenv="has_pyenv"
fi


if env | grep -q ^PYENV_VIRTUALENV_INIT=
then
    has_pyenv_virtualenv="has_pyenv_virtualenv"
fi

if env | grep -q ^VIRTUALENVWRAPPER_SCRIPT=
then
    has_virtualenvwrapper="has_virtualenvwrapper"
fi

# user outside of virtualenv without virtualenv installed.
if [ ! -n "$in_virtualenv" ] && [ ! -n "$has_virtualenv" ]; then
    cat <<EOF
You must install virtualenv, see:
https://virtualenv.pypa.io/en/latest/installation.html
EOF
    _quit 1
fi

_detect_manager() {
    if [ -n "$has_pyenv" ]; then # has pyenv
        if [ -n "$has_pyenv_virtualenv" ]; then # has virtualenv extension for pyenv
            if [ -n "$has_pyenv_virtualenvwrapper" ]; then  # confusing you? pyenv-virtualenvwrapper
                echo "virtualenvwrapper"
            else
                echo "pyenv-virtualenv"
            fi
        else  
            echo "virtualenv"
        fi
    else
        if [ -n "$has_virtualenvwrapper" ]; then
            echo "virtualenvwrapper"
        elif [ -n "$has_virtualenv" ]; then
            echo "virtualenv"
        else
            echo "No virtualenv found in paths."
            _quit 1
        fi
    fi
}


_virtualenv_project() {
    if [ ! -d "$HOME/.virtualenvs/$project_name" ]; then
        if [ ! -d "$HOME/.virtualenvs" ]; then
            mkdir "$HOME/.virtualenvs"
        fi
        virtualenv "$HOME/.virtualenvs/$project_name"
    fi

    _virtualenv_activate
}

_virtualenv_activate() {
    if [ "$sourced" = "on" ]; then
        if [ -d "$HOME/.virtualenvs/$project_name" ]; then
            source "$HOME/.virtualenvs/$project_name/bin/activate"
        else
            echo "virtualenv $project_name does not exist"
            _quit 1
        fi 
    fi

}

# todo, create a force command to overwrite
_virtualenvwrapper_project() {
    if ! $(lsvirtualenv | grep -q "^$project_name"); then
        mkvirtualenv "$project_name"
    fi
    _virtualenvwrapper_activate
}

_virtualenvwrapper_activate() {
    if [ "$sourced" = "on" ]; then
        if $(lsvirtualenv | grep -q "^$project_name"); then
            workon "$project_name"
        else
            echo "virtualenv $project_name does not exist"
            _quit 1
        fi 
    fi
}

_pyenv_virtualenv_project() {
   if ! $(pyenv virtualenvs $project_name | grep -q "  $project_name "); then
       pyenv virtualenv "$project_name"
   fi
   _pyenv_virtualenv_activate
}

_pyenv_virtualenv_activate() {
    if [ "$sourced" = "on" ]; then
        if $(pyenv virtualenvs $project_name | grep -q "  $project_name "); then
            pyenv activate "$project_name"
        else
            echo "virtualenv $project_name does not exist"
            _quit 1
        fi
    fi
}

_print_message() {
    cat <<EOF
usage: $0 [-v] [-m manager] [-c install_command] [project_name]

        -v  verbose / debug mode

        -m  (optional) virtualenv|pyenv-virtualenv|virtualenvwrapper
            will do the best to autodetect your virtual environment manager.

        -c  commands (if any) to install / prepare python environment
            e.g. -c "python setup.py install", "pip install -e .",
            "pip install -r requirements.txt"

        -t  run but don't create / attempt to source any virtualenvs

        project_name can be any valid directory name.
EOF
}

vflag=off
install_command=off
OPTIND=1
while getopts "hvtp:m:c:" opt
do
    case "$opt" in
      h)
          _print_message
          _quit 0
          ;;
      v)  vflag=on;;
      t)  sourced=off;;
      m)  
          manager="$OPTARG"
          if  [ "$manager" != "virtualenv" ] && 
              [ "$manager" != "virtualenvwrapper" ] && 
              [ "$manager" != "pyenv-virtualenv" ]; then
              echo "Incorrect manager, must specify virtualenv, virtualenvwrapper or pyenv-virtualenv"
              _quit 1
          fi
          ;;
      c)  install_command="$OPTARG";;
      \?)		# unknown flag
         _print_message 
         _quit 1;;
    esac
done
shift `expr $OPTIND - 1`

project_name=$@

if [ "$vflag" = "on" ]; then
    set -x
    set -v
    echo "project_name: $project_name"
    echo "install_command: $install_command"
    echo "manager: $manager"
fi

if [ -z "$project_name" ]; then
    echo "Please enter at least a project_name."
    _print_message
    _quit 1
fi



if [ -z "$manager" ]; then  # no manager found, let's autodetect
    manager=$(_detect_manager)
fi


if [ "$manager" = "pyenv-virtualenv" ]; then
    VIRTUALENV_PATH="$PYENV_ROOT/versions"
    _pyenv_virtualenv_project
elif [ "$manager" = "virtualenvwrapper" ]; then
    VIRTUALENV_PATH="$WORKON_HOME"
    _virtualenvwrapper_project
elif [ "$manager" = "virtualenv" ]; then
    VIRTUALENV_PATH="$HOME/.virtualenvs"
    _virtualenv_project
fi

VIRTUALENV_PROJECT_PATH="$VIRTUALENV_PATH/$project_name"
VIRTUALENV_PROJECT_BIN_PATH="$VIRTUALENV_PROJECT_PATH/bin"

if [ "$install_command" != "off" ]; then
    eval "$VIRTUALENV_PROJECT_BIN_PATH/$install_command"
fi
