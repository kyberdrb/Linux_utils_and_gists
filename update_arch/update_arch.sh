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

  pikaur --sync --refresh --refresh --noconfirm archlinux-keyring chaotic-keyring
  sudo pacman-key --populate

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
