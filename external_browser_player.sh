#!/bin/sh

VIDEO_URL=$1
VIDEO_ID_WITH_SECONDS=$(echo $VIDEO_URL | rev | cut -d '/' -f1)
VIDEO_ID_WITHOUT_SECONDS=$(echo $VIDEO_ID_WITH_SECONDS | cut -d'#' -f2 | rev)

echo "Playing video with ID: $VIDEO_ID_WITHOUT_SECONDS"

STREAM_URL=$(curl --silent https://www.rtvs.sk/json/archive5f.json?id=$VIDEO_ID_WITHOUT_SECONDS | grep -m 1 src | cut -d'"' -f4)

echo "Stream URL: $STREAM_URL"

mpv --hwdec=auto $STREAM_URL

