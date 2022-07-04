#!/usr/bin/env python

## sample python 3.x script to use alsa-capabilities from within python.
## needs `./get-interfaces-for-python.sh` which in turn sources
## `../alsa-capabilities.
##
## start it with:
## python get-interfaces.py

import subprocess, os.path, re, sys
from signal import signal, SIGPIPE, SIG_DFL

## limit the type of interfaces returned
limittype = 'usb'

## name of custom bash script, that sources `alsa-capabilities' which
## returns a string consiting of one line per interface, each with the
## format `Interface X on Y (hw:a,b)'
helperscriptname = 'get-interfaces-for-python.sh'
script = os.path.join(os.path.dirname(os.path.abspath(__file__)), helperscriptname)
if os.path.exists(script):
    print("ok 2: %s" % script)
else:
    sys.exit("error: could not find script \`%s' (tried \`%s')" % (helperscriptname, script))

## call the script, trapping std_err and storing std_out to `aif_output'
script_output = subprocess.check_output( 'LIMIT_INTERFACE_TYPE="%s" %s' % (limittype, script), \
                                      shell=True, 
                                      stderr=None, \
                                      preexec_fn = lambda: signal(SIGPIPE, SIG_DFL))

## create an empty list for holding interfaces with pairs of `('hw:a,b', 'Interface X on Y')'
interfaces_list = []

lenoflabel = 0 

## process each line of output (eg each interface)
for interface in script_output.splitlines():
    ## split the line on `()'
    interface_split = re.split(b'[()]', interface)
    ## store the label (eg. `Interface X on Y')
    interface_label = interface_split[0].strip()
    lenoflabel = len(interface_label) if len(interface_label) > lenoflabel else lenoflabel
    ## store the index (ef. `hw:a,b')
    interface_index =  interface_split[1]
    ## append the pair to the list
    interfaces_list.append((interface_index, interface_label))

## sample output
print("Found the following audio interfaces of type `%s':\n" % limittype)
print("hwaddr  label                       ")
print("%s  %s" % ('='*len('hwaddr'), '='*lenoflabel))
for aif in interfaces_list:
    print( "%s  %s" % (aif[0].rjust(len('hwaddr')), aif[1]))

