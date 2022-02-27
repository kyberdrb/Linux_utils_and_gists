#!/bin/sh

ORIGINAL_FILE_NAME="$1"

CLEANSED_FILE_NAME="$(printf "%s" "${ORIGINAL_FILE_NAME}" | sed 's/:/_-_/g' | sed 's/@/-/g' | tr -d '<>"/\|?*(),""“”+*;&£$€¥\!' | tr -d "'" | sed 's/ /_/g' | sed 's/__*/_/g' | sed 's/--*/-/g' | tr -d '\r\n')"

printf "%s" "${CLEANSED_FILE_NAME}" | xclip -selection clipboard
printf "%s\n" "${CLEANSED_FILE_NAME}"

printf "\n"
printf "%s\n" "The cleansed file name has been copied into clipboard."
printf "%s\n" "Use 'Ctrl + Shift + V to paste into terminal."

# Sources:
# - https://www.ed.ac.uk/records-management/guidance/records/practical-guidance/naming-conventions/non-ascii-characters
# - https://duckduckgo.com/?q=find+non+alphanumeric+characters+linux+-0&ia=web
# - https://stackoverflow.com/questions/22939323/sed-command-to-replace-multiple-spaces-into-single-spaces/22939416#22939416

