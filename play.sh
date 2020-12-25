#!/bin/sh

MEDIA=$1
touch "$MEDIA"
parole "$MEDIA" &
