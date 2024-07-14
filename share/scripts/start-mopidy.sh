#!/bin/bash

[ -f ${HOME}/.venv/bin/activate ] && source ${HOME}/.venv/bin/activate
mopidy --config ${HOME}/.config/mopidy/mopidy.conf
