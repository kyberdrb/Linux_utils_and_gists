#!/bin/sh

# Usage:
#   ./download_m4s_stream.sh "<SECTION_DIRECTORY_NAME>" "<VIDEO_NAME>" <FULL_URL_OF_MASTER_JSON_BASE64_SEGMENT_FOR_VIDEO>
# e. g.
#   ./download_m4s_stream.sh "03-Energy Management" "1-Energy Management - Group Class" https://168vod-adaptive.akamaized.net/exp=1607608951~acl=%2F199631567%2F%2A~hmac=d593507c60556eba80a7db50f8650611b5ed6d6742dba4524689ba987dde891a/199631567/sep/video/712908508,712908510,712908507,712908509/master.json?base64_init=1

# create video directory
SECTION_DIRECTORY="$1"
SECTION_DIRECTORY="${SECTION_DIRECTORY// /_}"

# escaping the forward slash is not necessary;
# it distinguishes dividers and actual character being replaced 
SECTION_DIRECTORY="${SECTION_DIRECTORY//\//}"

echo $SECTION_DIRECTORY
VIDEO_NAME="$2"
echo $VIDEO_NAME
VIDEO_NAME="${VIDEO_NAME// /_}"
echo $VIDEO_NAME
SECTION_NUMBER=$(echo "$SECTION_DIRECTORY" | cut -d'-' -f1)
VIDEO_DIRECTORY="$SECTION_DIRECTORY/${SECTION_NUMBER}-$VIDEO_NAME"
echo $VIDEO_DIRECTORY
mkdir -p "$VIDEO_DIRECTORY"

# go to video directory
cd "$VIDEO_DIRECTORY"

# download m4s stream downloader
VIMEO_DOWNLOADER_FILE=vimeo-downloader.js
curl https://gist.githubusercontent.com/aik099/69f221d100b87cb29f4fb6c29d72838e/raw/95ece80eab1a27d6d6d2ea68c57c07fff6a77826/vimeo-downloader.js -o $VIMEO_DOWNLOADER_FILE

# download m4s video
REQUEST_URL_FROM_MASTER_JSON="$3"

# strip suffix
REQUEST_URL_FROM_MASTER_JSON=${REQUEST_URL_FROM_MASTER_JSON%?base64_init=1}
node vimeo-downloader.js "$REQUEST_URL_FROM_MASTER_JSON"

# rename video to its name
COMPLETE_VIDEO_NAME=${SECTION_NUMBER}-${VIDEO_NAME}
mv *.mp4 ${COMPLETE_VIDEO_NAME}.mp4

# cleanUp
rm $VIMEO_DOWNLOADER_FILE

# Sources: TODO move to README.md
# https://gist.github.com/aik099/69f221d100b87cb29f4fb6c29d72838e
# https://stackoverflow.com/questions/8748831/when-do-we-need-curly-braces-around-shell-variables/8748880#8748880
# https://unix.stackexchange.com/questions/223182/how-to-replace-spaces-in-all-file-names-with-underscore-in-linux-using-shell-scr/223185#223185
# https://tldp.org/LDP/abs/html/parameter-substitution.html
# https://stackoverflow.com/questions/428109/extract-substring-in-bash/428118#428118
# https://stackoverflow.com/questions/16623835/remove-a-fixed-prefix-suffix-from-a-string-in-bash/16623897#16623897
# https://www.tutorialkart.com/bash-shell-scripting/bash-array/

