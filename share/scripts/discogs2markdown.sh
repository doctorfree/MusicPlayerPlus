#!/bin/bash
#
# discogs2markdown - automatically generate Obsidian vault markdown
#                    from a Discogs user collection
#
# Get the Discogs username, Discogs API token, and Discogs vault folder
[ -f "${HOME}/.config/mpprc" ] && . "${HOME}/.config/mpprc"

usage() {
  printf "\nUsage: discogs2markdown [-l] [-n] [-r] [-U] [-t token] [-u user] [-h]"
  printf "\nWhere:"
  printf "\n\t-l indicates use local music library rather than Discogs collection"
  printf "\n\t-n indicates perform a dry run, don't do anything"
  printf "\n\t-r indicates remove intermediate JSON created during previous run"
  printf "\n\t-U indicates perform an update of the Discogs collection"
  printf "\n\t-t 'token' specifies the Discogs API token"
  printf "\n\t-u 'user' specifies the Discogs username"
  printf "\n\t-h displays this usage message and exits\n\n"
  exit 1
}

cleanarg=
updarg=
userarg=
tokenarg=
uselocal=
vaultarg=
folderarg=
dryrun=
upload=
while getopts "alnrUf:t:u:v:h" flag; do
    case $flag in
        a)
            upload=1
            ;;
        f)
            folderarg="-f ${OPTARG}"
            ;;
        l)
            uselocal=1
            ;;
        n)
            dryrun="-n"
            ;;
        r)
            cleanarg="-r"
            ;;
        U)
            updarg="-U"
            ;;
        t)
            tokenarg="-t ${OPTARG}"
            ;;
        u)
            userarg="-u ${OPTARG}"
            ;;
        v)
            vaultarg="-v ${OPTARG}"
            ;;
        h)
            usage
            ;;
    esac
done
shift $(( OPTIND - 1 ))

[ "${DISCOGS_DIR}" ] || DISCOGS_DIR="${HOME}/Documents/Obsidian/Discogs"
DISCOGS_DIR="${DISCOGS_DIR/#\~/$HOME}"

if [ -f "${DISCOGS_DIR}/Dataview_Queries.md" ]
then
  [ -d "${DISCOGS_DIR}/.git" ] && {
    cd "${DISCOGS_DIR}"
    git pull --quiet --rebase=merges
  }
else
  PARENT=`dirname "${DISCOGS_DIR}"`
  [ -d "${PARENT}" ] || mkdir -p "${PARENT}"
  git clone --quiet \
    https://github.com/doctorfree/Obsidian-Custom-Discogs.git \
    "${DISCOGS_DIR}" > /dev/null
fi

if [ -d "${DISCOGS_DIR}" ]
then
  cd "${DISCOGS_DIR}"
else
  echo "ERROR: ${DISCOGS_DIR} does not exist or is not a directory."
  exit 1
fi
if [ -x Setup ]
then
  if [ "${uselocal}" ]
  then
    MUSIC_DIR="${MUSIC_DIR/#\~/$HOME}"
    ./Setup ${cleanarg} ${dryrun} ${updarg} ${userarg} ${tokenarg} -L "${MUSIC_DIR}"
  else
    if [ "${upload}" ]
    then
      ./Setup -A ${dryrun} ${folderarg} ${userarg} ${tokenarg} ${vaultarg}
    else
      ./Setup ${cleanarg} ${dryrun} ${updarg} ${userarg} ${tokenarg}
    fi
  fi
  echo ""
  echo "See README.md and Process.md in ${DISCOGS_DIR}"
  echo "for info on the additional features available there."
  echo ""
else
  echo "ERROR: Missing 'Setup' script. Check ${DISCOGS_DIR}"
  exit 1
fi
