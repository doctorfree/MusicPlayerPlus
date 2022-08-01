#!/bin/bash
#
# logtime.sh - append a calculated total execution time
#              for a specified process to a given log file

BEETSLOGDIR="${HOME}/.config/beets/logs"

usage() {
  printf "\nUsage: logtime.sh [-d description] [-l logfile] [-p pid]"
  printf " [-s start_seconds] [-u]"
  printf "\nWhere:"
  printf "\n\t-d 'description' sets the descriptive text to 'description'"
  printf "\n\t-l 'logfile' appends calculated elapsed time to 'logfile'"
  printf "\n\t-p 'pid' waits for process ID 'pid' to exit"
  printf "\n\t-s 'start_seconds' provides the time, in seconds of process start"
  printf "\n\t-u displays this usage message and exits\n"
  exit 1
}

DES="Process"
LOG=
PID=
START_SECONDS=
while getopts "d:l:p:s:u" flag; do
    case $flag in
        d)
            DES="$OPTARG"
            ;;
        l)
            LOG="$OPTARG"
            BEETSLOGDIR=`dirname "${LOG}"`
            ;;
        p)
            PID="$OPTARG"
            ;;
        s)
            START_SECONDS="$OPTARG"
            ;;
        u)
            usage
            ;;
    esac
done

[ "${PID}" ] || {
  echo "No process ID specified on command line."
  echo "Exiting."
  usage
}
[ "${START_SECONDS}" ] || START_SECONDS=$(date +%s)

[ "${LOG}" ] || LOG="${BEETSLOGDIR}/process.log"
[ -d "${BEETSLOGDIR}" ] || mkdir -p "${BEETSLOGDIR}"

tail --pid=${PID} -f /dev/null

FINISH_SECONDS=$(date +%s)
ELAPSECS=$(( FINISH_SECONDS - START_SECONDS ))
ELAPSED=`eval "echo total elapsed time: $(date -ud "@$ELAPSECS" +'$((%s/3600/24)) days %H hr %M min %S sec')"`
printf "\n# ${DES} ${ELAPSED}\n" >> ${LOG}

exit 0
