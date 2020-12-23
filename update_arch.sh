#!/bin/bash

PIKAUR_INSTALLED=$(pacman -Q | grep pikaur)
if [[ -z $PIKAUR_INSTALLED ]]; then 
    rm -rf /tmp/pikaur-git
    mkdir /tmp/pikaur-git
    curl https://aur.archlinux.org/cgit/aur.git/snapshot/pikaur-git.tar.gz --output /tmp/pikaur-git.tar.gz
    tar -xvzf /tmp/pikaur-git.tar.gz --directory /tmp/pikaur-git
    cd /tmp/pikaur-git/pikaur-git
    makepkg --ignorearch --clean --syncdeps --noconfirm
    PIKAUR_PACKAGE_NAME=$(ls *.tar*)
    sudo pacman -U $PIKAUR_PACKAGE_NAME --noconfirm
    rm -rf /tmp/pikaur-git
fi

#echo "Searching for fastest mirrors..."
#echo

#reflector \
#    --verbose
#    --country 'Slovakia' \
#    --country 'Czechia' \
#    --country 'Poland' \
#    --country 'Hungary' \
#    --country 'Ukraine' \
#    --country 'Austria'\
#    --country 'Germany' \
#    --protocol http --protocol https \
#    --sort rate | sudo tee /etc/pacman.d/mirrorlist > /dev/null 2>&1

#echo
#echo "-------------------------------------------------------"
#echo

#echo "Downloading fastest mirrors"
#echo
#
#sudo curl "https://www.archlinux.org/mirrorlist/?country=AT&country=CZ&country=DE&country=HU&country=PL&country=SK&country=UA&protocol=http&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on" -o /etc/pacman.d/mirrorlist
#
#echo "Make servers usable"
#echo
#
#sudo sed -i 's/#Server/Server/g' /etc/pacman.d/mirrorlist

echo
echo "-------------------------------------------------------"

echo
echo "Downloading current status of Arch Linux mirror servers"
echo

curl "https://www.archlinux.org/mirrors/status/" -o ~/Arch_Linux-Mirrors-Status.html

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

#cat ~/Arch_Linux-Mirrors-Status-Successful_Mirrors_Table_Only.html | sed 's/^[\ \t]*//g' | grep -i -e '<td>\|<tr>' | tr -d '\n\r' | sed 's/<\/TR[^>]*>/\n/Ig' | sed 's/<\/\?\(TABLE\|TR\)[^>]*>//Ig' | sed 's/^<T[DH][^>]*>\|<\/\?T[DH][^>]*>$//Ig' | sed 's/<\/T[DH][^>]*><T[DH][^>]*>/,/Ig' > ~/mirrorlist.csv

#cat ~/Arch_Linux-Mirrors-Status-Successful_Mirrors_Table_Only.html | sed '/<a href/d' | sed 's/^[\ \t]*//g' | grep -i -e '<td>\|<tr>' | sed 's/<tr>//Ig' | sed '/^$/d' | sed 's/<\/td>/,/Ig' | sed 's/<td>//Ig' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' | sed 's/<\/tr>/\n/Ig' | sed 's/,$//g' > ~/mirrorlist.csv

cat ~/Arch_Linux-Mirrors-Status-Successful_Mirrors_Table_Only.html | sed '/<a href/d' | sed 's/^[\ \t]*//g' | grep -i -e '<td>\|<tr>' | sed 's/<tr>//Ig' | sed '/^$/d' | sed 's/<\/td>/,/Ig' | sed 's/<td>//Ig' | tr --delete '\n' | sed 's/<\/tr>/\n/Ig' | sed 's/,$//g' > ~/mirrorlist.csv

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

BACKUP_TIME_AND_DATE=$(date "+%Y_%M_%d-%H_%M_%S")
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-${BACKUP_TIME_AND_DATE}.bak

echo "Backed up mirrorlist file is located at"
echo "/etc/pacman.d/mirrorlist-${BACKUP_TIME_AND_DATE}.bak"

echo "Moving new 'mirrorlist' to the pacman directory to apply changes"

sudo mv ~/mirrorlist /etc/pacman.d/mirrorlist

echo "Cleaning up"

rm ~/mirrorlist.csv
rm ~/Arch_Linux-Mirrors-Status-Successful_Mirrors_Table_Only.html
rm ~/Arch_Linux-Mirrors-Status.html

# Sources:
# https://www.archlinux.org/mirrors/status/
# https://linuxize.com/post/how-to-read-a-file-line-by-line-in-bash/
# https://stackoverflow.com/questions/14093452/grep-only-the-first-match-and-stop/14093511#14093511
# https://stackoverflow.com/questions/1403087/how-can-i-convert-an-html-table-to-csv/10189130#10189130
# https://stackoverflow.com/questions/1403087/how-can-i-convert-an-html-table-to-csv/10189130#10189130
# https://kifarunix.com/delete-lines-matching-a-specific-pattern-in-a-file-using-sed/
# https://www.2daygeek.com/remove-delete-empty-lines-in-a-file-in-linux/
# https://stackoverflow.com/questions/1251999/how-can-i-replace-a-newline-n-using-sed/1252010#1252010
# https://phoenixnap.com/kb/grep-multiple-strings

echo

echo "Update Arch Linux keyring to avoid PGP signature errors"
echo

pikaur --sync --refresh --refresh --noconfirm archlinux-keyring 
sudo pacman-key --populate
sudo pacman-key --refresh-keys

echo  "Finding EFI boot partition"
echo

BOOT_PARTITION=$(sudo fdisk -l | grep EFI | cut -d' ' -f1)
echo $BOOT_PARTITION

echo "Finding EFI boot partition mount point"
echo

BOOT_PARTITION_MOUNT_POINT=$(mount -v | grep /dev/sda1 | cut -d' ' -f3)
echo $BOOT_PARTITION_MOUNT_POINT
echo

echo "Checking partition stats before remounting"
echo

mount -v | grep $BOOT_PARTITION
echo

echo "Remounting EFI boot partition to the same boot point as writable"
echo

sudo mount -o remount,rw $BOOT_PARTITION $BOOT_PARTITION_MOUNT_POINT

echo "Checking partition stats after remounting"
echo

mount -v | grep $BOOT_PARTITION

echo "Updating and upgrading packages"
echo
    
pikaur \
    --sync \
    --refresh --refresh \
    --sysupgrade --sysupgrade \
    --noedit \
    --nodiff \
    --overwrite /usr/lib/p11-kit-trust.so \
    --overwrite /usr/bin/fwupdate \
    --overwrite /usr/share/man/man1/fwupdate.1.gz \

echo
echo "Removing leftovers"
echo

rm -rf ~/.libvirt

echo "Finalizing upgrade"

echo
echo "**************************************************************************"
echo
echo Please, reboot to apply updates for kernel, firmware, graphics drivers or other drivers and services requiring service restart or system reboot.
echo
echo "**************************************************************************"
echo

