#!/bin/sh

echo "$1" | sed 's/:/_-_/g' | sed 's/@/-/g' | tr -d '<>"/\|?*(),""“”!' | tr -d "'" | sed 's/ /_/g' | sed 's/__/_/g' | tr -d '\r\n' | xclip -selection clipboard

