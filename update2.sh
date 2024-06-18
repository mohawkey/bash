#!/bin/bash

# --------------------------------------------------------------------------------
# ROOT
# --------------------------------------------------------------------------------

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# --------------------------------------------------------------------------------
# FUNCTION
# --------------------------------------------------------------------------------

function Question() {

  input=" "
  space=$((65 - ${#1} ))

  until [[ ${input^^} == "Y"  ||  ${input^^} == "N" ||  $input == "" ]]; do
    printf '%s%*s%s' "$1" "$space" "" "[$2] "
    read -s -n 1 input
    printf "\n"
  done

  if [[ $input == "" ]]; then
    input=$2
  fi

  result=${input^^}
}

apt_update() {
  apt update
}

apt_upgrade() {
  apt upgrade -y
}

snap_refresh() {
  snap refresh
}

apt_cleanup() {
  apt purge --autoremove
}

snap_cleanup() {
  snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do sudo snap remove "$snapname" --revision="$revision"; done
}

# ----------------------------------------------------------------------------------------------------
# PROGRAM
# ----------------------------------------------------------------------------------------------------

Question "APT: Update list of available packages" "Y"
if [[ $result == "Y" ]]; then
  apt_update  

  Question "APT: Upgrade the system by installing and upgrading packages" "Y"
  if [[ $result == "Y" ]]; then
    apt_upgrade
  fi

fi

Question "SNAP: Update all installed snaps" "Y"
if [[ $result == "Y" ]]; then
  snap_refresh
fi

Question "APT: Cleanup" "N"
if [[ $result == "Y" ]]; then
  apt_cleanup
fi

Question "SNAP: Cleanup disabled snaps" "Y"
if [[ $result == "Y" ]]; then
  snap_cleanup
fi
