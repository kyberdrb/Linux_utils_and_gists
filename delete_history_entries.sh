#!/bin/sh

set -x

#history | tac | head --lines=1 | sed 's/^\s*//g' | cut --delimiter=' ' --fields=1

TO="${1}"

if [ -z "${TO}" ]
then
  echo "Parameter 'TO' has to be defined."
    echo ""
    echo "Usage: source $(basename $0) <TO> [FROM]"
    echo "e.g."
    echo "    source $(basename $0) 400"
    echo "    source $(basename $0) 400 395"
    echo ""
  exit 1
fi

FROM="${2:-${TO}}"

NUMBER_OF_ENTRIES=$(( TO - FROM + 1))

for history_entry_index in $(seq 1 ${NUMBER_OF_ENTRIES})
do
  #echo "${FROM}"
  history -d ${FROM}

  if [ $? -ne 0 ]
  then
    echo "Usage: source $(basename $0) <TO> [FROM]"
    echo "e.g."
    echo "    source $(basename $0) 400"
    echo "    source $(basename $0) 400 395"
    echo ""
    exit 1
  fi

done

set +x

echo "Verify deletion with command"
echo "    history | tac | less"
echo "    history | tac | head --lines=1"

# Sources:
#- https://www.howtogeek.com/884039/how-to-use-bash-if-statements-with-examples/
#- https://duckduckgo.com/?q=for+loop+bash&ia=web
#- https://unix.stackexchange.com/questions/594841/how-do-i-assign-a-value-to-a-bash-variable-if-that-variable-is-null-unassigned-f/594845#594845
#- https://duckduckgo.com/?q=history+position+out+of+range&ia=web
#- https://stackoverflow.com/questions/61994226/how-to-delete-history-in-a-range-in-linux-bash
#- https://superuser.com/questions/649859/history-position-out-of-range-when-calling-history-from-bash-script
#- https://superuser.com/questions/176783/what-is-the-difference-between-executing-a-bash-script-vs-sourcing-it/176788#176788

