#!/bin/sh

ZIP_ARCHIVE="$1"
EXTRACTION_DIR=${ZIP_ARCHIVE%.*}

7z x "${ZIP_ARCHIVE}" "-o${EXTRACTION_DIR}"

