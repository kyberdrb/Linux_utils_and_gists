#!/bin/sh

#set -x

# Example
# $ echo "E:\\Computer Maintenance\\something\\" | tr --delete ':' | sed 's/^/\//g' | sed 's:\\:/:g'
# /E/Computer Maintenance/something/
# $ echo "E:\\Computer Maintenance\\something\\" | cut --delimiter='\' --fields=1 | tr --delete ':' | tr [:upper:] [:lower:]
# e
# $ echo "E:\\Computer Maintenance\\something\\" | cut --delimiter='\' --fields=1 --complement | sed 's:\\:/:g'
# Computer Maintenance/something/

# Example usage
# $ ./convert_win_path_to_unix.sh 'E:\Computer Maintenance\something\'
# "/e/Computer Maintenance/something/"
#
# $ ./convert_win_path_to_unix.sh "E:\\Computer Maintenance\\something\\"
# "/e/Computer Maintenance/something/"

PATH_WINDOWS_STYLE="$1"

DRIVE_LETTER="$(printf "%s" "${PATH_WINDOWS_STYLE}" | cut --delimiter='\' --fields=1 | tr --delete ':' | tr [:upper:] [:lower:])"
REST_OF_PATH="$(printf "%s" "${PATH_WINDOWS_STYLE}" | cut --delimiter='\' --fields=1 --complement | sed 's:\\:/:g')"
COMPLETE_PATH="\"/${DRIVE_LETTER}/${REST_OF_PATH}\""

echo "${COMPLETE_PATH}"
