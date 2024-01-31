# Dispatching/Executing Batch script from Shell script
# launcher script - in shell

#!/bin/sh

set -x

SCRIPT_DIR="$(dirname "$(readlink --canonicalize "$0")")"
SCRIPT_DIR_WIN_STYLE="$(${SCRIPT_DIR}/convert_unix_path_to_win.sh "${SCRIPT_DIR}")"
DRIVE_LETTER="$1"
DIRECTORY="$2"
OPTIONS="$3"

# notice the space at the end before ending quote - needed to make the 'start' command functional/executable
start cmd.exe "/c ${SCRIPT_DIR_WIN_STYLE}\CATM_copy_reports-simplified.bat ${DRIVE_LETTER} ${DIRECTORY} ${OPTIONS} "
