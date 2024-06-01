#!/bin/bash
#
# python3.sh - identify Python 3 executable in PATH
#              and invoke it with script arguments 

function check_py_version
{
	# Full version number e.g. 2.7.1
	python_version="$(echo "$($1 -V 2>&1)" | sed -e "s/^.* \(.*\)$/\\1/g")"

	# Return (the first letter -lt "3")
	! [ "$(echo $python_version | head -c 1 )" -lt "3" ]
}

MESSAGE_EXIT_CODE=60
PYTHON_BINARY=""
POTENTIAL_BINARIES=( "python" "python3" "python3.6" "python3.5" "python3.7" "python3.4" "python3.3" "python3.8" "python3.2" "python3.1" )
PY3_SUPPORT=false

[ -f ${HOME}/.venv/bin/activate ] && source ${HOME}/.venv/bin/activate

for i in "${POTENTIAL_BINARIES[@]}"
do
	PYTHON_BINARY="$i"

	if  $(check_py_version ${PYTHON_BINARY}) ;
	then
		PY3_SUPPORT=true
		break
	fi
done

if [ ! ${PY3_SUPPORT} ]
then
	echo "[ERROR] Could not find python3 binary, please add it to your \$PATH before continuing"
	exit
fi

# If we made it here it means the user just wants to forward their
# args to the python script and execute it
${PYTHON_BINARY} $@
