#!/bin/bash

update_pacman_mirror_servers() {
    echo "Searching for fastest mirrors..."
    echo

    echo
    echo "-------------------------------------------------------"

    echo
    echo "Downloading current status of Arch Linux mirror servers"
    echo

    # The easy way ^_^ that sometimes fails
    # reflector --latest 50 --protocol http,https,rsync --verbose --country Slovakia --country Czechia --country Poland --country Hungary --country Ukraine --country Austria --country Germany | sudo tee /etc/pacman.d/mirrorlist

    # The hard way `_´ that always works ºOº &) :D :)
    curl -L "https://www.archlinux.org/mirrors/status/" -o ~/Arch_Linux-Mirrors-Status.html

    echo "Finding the table with the fully synced mirrors"
    echo "Calculating table boundaries"

    SUCCESSFUL_MIRRORS_TABLE_BEGINNING_LINE=$(cat ~/Arch_Linux-Mirrors-Status.html | grep -n -m 1 successful_mirrors | cut -d':' -f1)

    SUCCESSFUL_MIRRORS_TABLE_ENDING_LINE=$(cat ~/Arch_Linux-Mirrors-Status.html | grep -n -m 2 "/table" | tail -n 1 | cut -d':' -f1)

    ALL_LINES_COUNT=$(cat ~/Arch_Linux-Mirrors-Status.html | wc -l)
    TAIL_LIMIT=$(( ALL_LINES_COUNT - SUCCESSFUL_MIRRORS_TABLE_BEGINNING_LINE + 1 ))
    HEAD_LIMIT=$(( SUCCESSFUL_MIRRORS_TABLE_ENDING_LINE - SUCCESSFUL_MIRRORS_TABLE_BEGINNING_LINE + 1 ))

    echo "Cropping only the table with successful mirrors"

    cat ~/Arch_Linux-Mirrors-Status.html | tail -n $TAIL_LIMIT | head -n $HEAD_LIMIT > ~/Arch_Linux-Mirrors-Status-Successful_Mirrors_Table_Only.html

    echo "Transforming HTML table to CSV format"

    cat ~/Arch_Linux-Mirrors-Status-Successful_Mirrors_Table_Only.html | sed '/<a href/d' | sed 's/^[\ \t]*//g' | grep -i -e "<td\|<tr>" | sed 's/<tr>//Ig'| sed '/^$/d' | sed 's/<\/td>/,/Ig' | sed 's/<td>//Ig' | sed 's/span /\n/Ig' | sed 's/<\/span> /\n/Ig' | sed '/^<td class/d' | sed '/^class/d' | tr --delete '\n' | sed 's/<\/tr>/\n/Ig' | sed 's/,$//g' | grep "Slovakia\|Czechia\|Poland\|Hungary\|Ukraine\|Austria\|\Germany" > ~/mirrorlist.csv

    echo "Extracting only the first column - the URLs of the servers - from the CSV file"
    echo

    while IFS= read -r line
    do
      echo "$line" | cut -d',' -f1 | tee --append ~/mirrorlist
    done < ~/mirrorlist.csv

    echo
    echo "Making the 'mirrorlist' file a valid and usable for pacman"

    echo "Adding prefix for each server"

    sed -i 's/^/Server = /g' ~/mirrorlist

    echo "Adding suffix for each server"

    sed -i 's/$/\$repo\/os\/\$arch/g' ~/mirrorlist

    echo
    echo "The final 'mirrorlist'"
    echo

    cat ~/mirrorlist

    echo

    echo "Backing up current mirrorlist"

    BACKUP_TIME_AND_DATE=$(date "+%Y_%m_%d-%H_%M_%S")
    sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-${BACKUP_TIME_AND_DATE}.bak

    echo "Backed up mirrorlist file is located at"
    echo "/etc/pacman.d/mirrorlist-${BACKUP_TIME_AND_DATE}.bak"

    echo "Moving new 'mirrorlist' to the pacman directory to apply changes"

    sudo mv ~/mirrorlist /etc/pacman.d/mirrorlist

    echo "Cleaning up"

    rm ~/mirrorlist.csv
    rm ~/Arch_Linux-Mirrors-Status-Successful_Mirrors_Table_Only.html
    rm ~/Arch_Linux-Mirrors-Status.html

}

main() {
  update_pacman_mirror_servers
}

main
