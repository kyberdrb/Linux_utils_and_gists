#!/bin/sh

# for example "archive.7z.001"
SPLIT_ARCHIVE_NAME_FIRST_PART="$1"

SPLIT_ARCHIVE_NAME_WITHOUT_PART_NUMBER="${SPLIT_ARCHIVE_NAME_FIRST_PART%.*}"

find . -mindepth 1 -name "${SPLIT_ARCHIVE_NAME_WITHOUT_PART_NUMBER}.*" -exec sh -c "sha256sum "{}" | tee --append "${SPLIT_ARCHIVE_NAME_WITHOUT_PART_NUMBER}.sha256sums"" \;

# Sources:
# - https://duckduckgo.com/?q=bash+variable+substitution+longest+shortest+match+start+end+beginning+%25+%23&ia=web
# - https://www.thegeekstuff.com/2010/07/bash-string-manipulation/
# - https://duckduckgo.com/?q=shell+variable+substitution+shortest+longest+match+%22%25.*%22&ia=web
# - https://wiki.bash-hackers.org/syntax/pe#substring_removal
# - https://wiki.bash-hackers.org/syntax/pe
# - https://duckduckgo.com/?q=bash+substring+removal&ia=web
