#!/bin/sh
#
# Verifies what is about to be committed.  Called by "git commit" with
# no arguments. Exits with non-zero status and an appropriate message.

stash_name="pre-commit-$(LC_ALL=C date +%s)"
git stash save -q --keep-index "${stash_name}"

# run shellcheck on alsa-capabilities
if ! make check >/dev/null 2>&1; then
    echo "error shellchecking alsa-capabilities"
    git stash pop -q
    exit 1
fi

# cleanup stashes
stashes=$(git stash list)
if [ "${stashes}" -eq "${stash_name}" ]; then
    git stash pop -q
fi

## END TIP



