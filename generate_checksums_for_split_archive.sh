#!/bin/sh

# for example "archive.7z.001"
SPLIT_ARCHIVE_NAME_FIRST_PART="$1"

SPLIT_ARCHIVE_NAME_WITHOUT_PART_NUMBER="${SPLIT_ARCHIVE_NAME_FIRST_PART%.*}"

find . -mindepth 1 -name "${SPLIT_ARCHIVE_NAME_WITHOUT_PART_NUMBER}.*" -exec sh -c "sha256sum "{}" | tee --append "${SPLIT_ARCHIVE_NAME_WITHOUT_PART_NUMBER}.sha256sums"" \;
