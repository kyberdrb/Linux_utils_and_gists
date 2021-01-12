#!/bin/bash

set_up_pikaur() {
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

  echo "'pikaur' package installed - Arch User Repository Package Helper present"
  echo
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
  # https://bbs.archlinux.org/viewtopic.php?pid=1837082#p1837082

  sudo rm -R /etc/pacman.d/gnupg/
  sudo rm -R /root/.gnupg/

  echo
  echo "========================="
  echo "Initialize pacman keyring"
  echo "========================="
  echo

  sudo pacman-key --init

  echo
  echo "================"
  echo "Refresh GPG keys"
  echo "================"
  echo

  sudo gpg --refresh-keys
  sudo pacman-key --populate archlinux

  echo
  echo "==================================="
  echo "Add GPG key for liquorix repository"
  echo "==================================="
  echo

  sudo pacman-key --keyserver hkps.pool.sks-keyservers.net --recv-keys 9AE4078033F8024D
  sudo pacman-key --lsign-key 9AE4078033F8024D
  sudo gpg --keyserver hkps.pool.sks-keyservers.net --recv-keys 9AE4078033F8024D
  gpg --lsign-key 9AE4078033F8024D

  echo
  echo "==================================="
  echo "Add GPG key for ck repository - graysky"
  echo "==================================="
  echo
   
  echo pacman recv
  sudo pacman-key --recv-keys 5EE46C4C --keyserver hkp://pool.sks-keyservers.net
  echo pacman sign
  sudo pacman-key --lsign-key 5EE46C4C
  echo gpg recv
  sudo gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 5EE46C4C
  echo gpg sign
  sudo gpg --quick-lsign-key 5EE46C4C

  # Add GPG key for post-factum repository
  sudo pacman-key --recv-keys 95C357D2AF5DA89D
  sudo pacman-key --lsign-key 95C357D2AF5DA89D
  gpg --recv-keys 95C357D2AF5DA89D
  gpg --lsign-key 95C357D2AF5DA89D

  # Add GPG key for chaotic-repo: Pedro Henrique Lara Campos - pedrohlc
  sudo pacman-key --recv-keys 3056513887B78AEB
  sudo pacman-key --lsign-key 3056513887B78AEB
  gpg --recv-keys 3056513887B78AEB
  gpg --lsign-key 3056513887B78AEB 

  echo
  echo "==============="
  echo "Uprade keyrings"
  echo "==============="
  echo

  pikaur --sync --refresh --refresh --noconfirm archlinux-keyring
  pikaur --sync --refresh --refresh --noconfirm chaotic-keyring

  # In case of emergency, refresh keys in keyring - it can take several minutes
  #sudo pacman-key --refresh-keys
}

remount_boot_partition_as_writable() {
  local current_working_dir="$(pwd)"
  local script_dir="$(dirname $(readlink -f $0))"

  cd "$script_dir"

  ./utils/remount_boot_part_as_writable.sh

  cd "$current_working_dir"
}

upgrade_packages() {
  echo
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
  echo "**************************************************************************"
  echo
  echo Please, reboot to apply updates for kernel, firmware, graphics drivers or other drivers and services requiring service restart or system reboot.
  echo
  echo "**************************************************************************"
  echo
}

main() {
  set_up_pikaur
  update_pacman_mirror_servers
  update_arch_linux_keyring
  remount_boot_partition_as_writable
  upgrade_packages
  clean_up
  finalize
}

main
