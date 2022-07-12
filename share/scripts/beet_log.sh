#!/bin/bash

LOG="${HOME}/.config/beets/beet_log.txt"
DATE=`date`

[ -f ${LOG} ] || touch ${LOG}
echo ${DATE} >> ${LOG}
echo $* >> ${LOG}
