#!/bin/sh

set -x

# for example "archive.7z.001"
SPLIT_ARCHIVE_FIRST_PART_PATH="$1"
SPLIT_ARCHIVE_DIR="$(dirname "${SPLIT_ARCHIVE_FIRST_PART_PATH}")"
SPLIT_ARCHIVE_FIRST_PART_NAME="$(basename "${SPLIT_ARCHIVE_FIRST_PART_PATH}")"
SPLIT_ARCHIVE_BASENAME="${SPLIT_ARCHIVE_FIRST_PART_NAME%.*}"
SPLIT_ARCHIVE_CHECKSUM_FILE="${SPLIT_ARCHIVE_DIR}/${SPLIT_ARCHIVE_BASENAME}.sha256sums"

find "${SPLIT_ARCHIVE_DIR}" -mindepth 1 -name "${SPLIT_ARCHIVE_BASENAME}.*" -exec sh -c "sha256sum "{}" | tee --append "${SPLIT_ARCHIVE_CHECKSUM_FILE}"" \;

sort --reverse --output="${SPLIT_ARCHIVE_CHECKSUM_FILE}" "${SPLIT_ARCHIVE_CHECKSUM_FILE}"

# Sources:
# - https://duckduckgo.com/?q=bash+variable+substitution+longest+shortest+match+start+end+beginning+%25+%23&ia=web
# - https://www.thegeekstuff.com/2010/07/bash-string-manipulation/
# - https://duckduckgo.com/?q=shell+variable+substitution+shortest+longest+match+%22%25.*%22&ia=web
# - https://wiki.bash-hackers.org/syntax/pe#substring_removal
# - https://wiki.bash-hackers.org/syntax/pe
# - https://duckduckgo.com/?q=bash+substring+removal&ia=web
# - https://duckduckgo.com/?q=terminal+sort+file+in+place&ia=web
# - https://stackoverflow.com/questions/29244351/how-to-sort-a-file-in-place
# - https://stackoverflow.com/questions/29244351/how-to-sort-a-file-in-place/29244408#29244408

