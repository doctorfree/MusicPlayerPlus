#!/bin/bash
#
if [ -d nncmpp ]
then
  echo "The nncmpp directory already exists. Skipping clone of nncmpp."
else
  git clone --recursive https://git.janouch.name/p/nncmpp.git
fi
