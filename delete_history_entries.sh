#!/bin/sh

#set -x

echo "Usage: source $(basename $0) <TO> [FROM]"
echo "e.g."
echo "    source $(basename $0) 400"
echo "    source $(basename $0) 400 395"
echo ""
echo "Verification:"
echo "    history | tac | less"
echo "    history | tac | head --lines=1"
echo ""

TO="${1}"

if [ -z "${TO}" ]
then
  echo "Parameter 'TO' has to be defined."
  exit 1
fi

FROM="${2:-${TO}}"

NUMBER_OF_ENTRIES=$(( TO - FROM + 1))

for history_entry_index in $(seq 1 ${NUMBER_OF_ENTRIES})
do
  #echo "${FROM}"
  history -d ${FROM}
done

#set +x

echo "Verify deletion with command"
echo "    history | tac | less"

