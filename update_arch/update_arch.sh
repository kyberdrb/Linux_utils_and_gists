#!/bin/bash

request_sudo_password() {
  sudo ls -d
}

set_up_pikaur() {
  PIKAUR_INSTALLED=$(pacman --query | grep pikaur)
  if [[ -z $PIKAUR_INSTALLED ]]; then 
    rm -rf /tmp/pikaur-git
    mkdir /tmp/pikaur-git
    curl https://aur.archlinux.org/cgit/aur.git/snapshot/pikaur-git.tar.gz --output /tmp/pikaur-git.tar.gz
    tar -xvzf /tmp/pikaur-git.tar.gz --directory /tmp/pikaur-git
    cd /tmp/pikaur-git/pikaur-git
    makepkg --ignorearch --clean --syncdeps --noconfirm
    PIKAUR_PACKAGE_NAME=$(ls -- *.tar*)
    sudo pacman --upgrade "$PIKAUR_PACKAGE_NAME" --noconfirm
    rm -rf /tmp/pikaur-git
  fi

  echo "'pikaur' package installed:"
  echo 'Arch User Repository (AUR) Package Helper present'
  echo
}

update_repo_of_this_script() {
  local git_pull_status=$(git -C "$(dirname $(readlink -f ~/update_arch.sh))" pull)

  echo "$git_pull_status" | grep --invert-match "Already up to date."

  test $? -eq 0

  local is_local_repo_behind="$?"
  if [[ is_local_repo_behind -eq 0 ]]; then
    echo "Repository updated."
    echo "Please, run the script again."
    exit 1
  fi

  echo "Local repo already up to date."
}

update_pacman_mirror_servers() {
  local current_working_dir="$(pwd)"
  local script_dir="$(dirname $(readlink -f $0))"

  cd "$script_dir"

  ./utils/update_pacman_mirror_servers.sh

  cd "$current_working_dir"
}

update_arch_linux_keyring() {
  echo
  echo "Update Arch Linux keyring to avoid PGP signature errors"
  echo

  echo
  echo "================"
  echo "Cleanup GPG keys"
  echo "================"
  echo
  echo Source:
  echo   https://bbs.archlinux.org/viewtopic.php?pid=1837082#p1837082
  echo

  sudo rm -R /etc/pacman.d/gnupg/
  sudo rm -R /root/.gnupg/
  rm -rf ~/.gnupg/

  echo
  echo "========================="
  echo "Initialize pacman keyring"
  echo "========================="
  echo

  sudo pacman-key --init
  echo "keyserver hkp://keyserver.ubuntu.com" | sudo tee --append "/etc/pacman.d/gnupg/gpg.conf"


  echo
  echo "====================================================="
  echo "Add GPG keys for custom repositories and AUR packages"
  echo "====================================================="
  echo

  sudo pacman-key --populate archlinux
  sudo gpg --refresh-keys

  echo
  echo "+----------------------------------+"
  echo "| Add GPG key for seblu repository |"
  echo "+----------------------------------+"
  echo

  sudo pacman-key --recv-keys 76F3EB6DA1C5F938AD642DC438DCEEBE387A1EEE
  sudo pacman-key --lsign-key 76F3EB6DA1C5F938AD642DC438DCEEBE387A1EEE

  echo
  echo "====================================="
  echo "Add GPG key for 'liquorix' repository"
  echo "====================================="
  echo

  sudo pacman-key --recv-keys 9AE4078033F8024D
  sudo pacman-key --lsign-key 9AE4078033F8024D

  echo
  echo "========================================="
  echo "Add GPG key for 'ck' repository - graysky"
  echo "========================================="
  echo
   
  sudo pacman-key --recv-keys 5EE46C4C --keyserver hkp://pool.sks-keyservers.net
  sudo pacman-key --lsign-key 5EE46C4C

  echo
  echo "========================================"
  echo "Add GPG key for 'post-factum' repository"
  echo "========================================"
  echo

  sudo pacman-key --keyserver hkp://pool.sks-keyservers.net --recv-keys 95C357D2AF5DA89D
  sudo pacman-key --lsign-key 95C357D2AF5DA89D
 
  echo
  echo "====================================="
  echo "Add GPG key for 'chaotic' repository:"
  echo "Pedro Henrique Lara Campos - pedrohlc"
  echo "====================================="
  echo

  sudo pacman-key --keyserver hkp://pool.sks-keyservers.net --recv-keys 3056513887B78AEB
  sudo pacman-key --lsign-key 3056513887B78AEB

  echo
  echo "======================================================================"
  echo "Add GPG key for Pedram Pourang - tsujan"
  echo "Required when building 'compton-conf' AUR package"
  echo '  see (https://aur.archlinux.org/packages/compton-conf/#pinned-742136)'
  echo "======================================================================"
  echo

  gpg --recv-keys BE793007AD22DF7E
  gpg --lsign-key BE793007AD22DF7E

  echo
  echo "==========================================================="
  echo "Uprade keyrings and additional mirrorlists for repositories"
  echo "==========================================================="
  echo

  pikaur --sync --refresh --refresh --verbose

  pikaur --sync --refresh --noconfirm --verbose archlinux-keyring

  echo 
  echo "'chaotic-mirrorlist' adds separate mirrorlist file in"
  echo " /etc/pacman.d/chaotic-mirrorlist"
  echo

  pikaur --sync --refresh --noconfirm --verbose chaotic-mirrorlist

  echo
  echo "For chaotic-aur repo setup, see page"
  echo " https://lonewolf.pedrohlc.com/chaotic-aur/"
  echo

  pikaur --sync --refresh --noconfirm --verbose chaotic-keyring 
}

remount_boot_partition_as_writable() {
  local current_working_dir="$(pwd)"
  local script_dir="$(dirname $(readlink -f $0))"

  cd "$script_dir"

  ./utils/remount_boot_part_as_writable.sh

  cd "$current_working_dir"
}

install_script_dependencies() {
  echo
  echo "=============================="
  echo "Installing script dependencies"
  echo "=============================="

  echo
  echo "--------------------------"
  echo "Install dependent packages"
  echo "--------------------------"
  echo 

  pikaur --sync --refresh --refresh --needed --noconfirm \
    pikaur powerpill reflector rsync
}

upgrade_packages() {
  echo
  echo "==============================="
  echo "Updating and upgrading packages"
  echo "==============================="
  echo 

  echo
  echo "------------------------"
  echo "Clear 'pacman' databases"
  echo "------------------------"
  echo 

  sudo rm -rf /var/lib/pacman/sync/*

  echo
  echo "Pacman configuration file '/etc/pacman.conf'"
  echo "had been patched for 'powerpill' to resolve error messages"
  echo "according to"
  echo " https://wiki.archlinux.org/index.php/Powerpill#Troubleshooting"
  echo "and"
  echo " https://bbs.archlinux.org/viewtopic.php?pid=1254940#p1254940"
  echo

  sudo powerpill \
      --sync \
      --refresh --refresh \
      --sysupgrade --sysupgrade \
      --verbose \
      --noconfirm

  echo
  echo "==================================================="
  echo "Updating and upgrading packages AUR packages"
  echo "and official packages that haven't been updated yet"
  echo "to the latest version"
  echo "or haven't been updated at all"
  echo "==================================================="
  echo 

  pikaur \
      --sync \
      --refresh --refresh \
      --sysupgrade --sysupgrade \
      --verbose \
      --noedit \
      --nodiff \
      --noconfirm \
      --overwrite /usr/lib/p11-kit-trust.so \
      --overwrite /usr/bin/fwupdate \
      --overwrite /usr/share/man/man1/fwupdate.1.gz
}

clean_up() {
  echo
  echo "Removing leftovers"
  echo

  rm -rf ~/.libvirt
}

finalize() {
  echo "Finalizing upgrade"

  echo
  echo "=========================================="
  echo
  echo Please, reboot to apply updates 
  echo for kernel, firmware, graphics drivers 
  echo or other drivers and services 
  echo requiring service restart or system reboot.
  echo
  echo "=========================================="
  echo
}

main() {
  request_sudo_password
  set_up_pikaur
  update_repo_of_this_script
  update_pacman_mirror_servers
  update_arch_linux_keyring
  remount_boot_partition_as_writable
  install_script_dependencies
  upgrade_packages
  clean_up
  finalize
}

main

