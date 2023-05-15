#!/bin/bash

# /usr/local/sbin

# --------------------------------------------------------------------------------
# ROOT
# --------------------------------------------------------------------------------

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# --------------------------------------------------------------------------------
# FUNCTIONS
# --------------------------------------------------------------------------------


UpdateSystemAptitude () {
   aptitude update
   aptitude upgrade -y
   aptitude clean
   apt --purge autoremove
}

UpdateSystemSnap () {
   snap refresh
   snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do sudo snap remove "$snapname" --revision="$revision"; done
}

#UpdateContainerAptitude () {
#   echo "kk"
#}

# --------------------------------------------------------------------------------
# PARAMETERS
# --------------------------------------------------------------------------------

if [[ $# != 0 ]]; then
   if [[ $1 == "--system" ]]; then
      UpdateSystemAptitude
      UpdateSystemSnap
   fi
   if [[ $1 == "--container" ]]; then
      if [[ $# == 1 ]]; then
         echo "update all"
      fi
      if [[ $# == 2 ]]; then
         Container=$2
         echo "container $Container"
      fi
   fi
fi











# --------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------


#if [[ -f .docker.tmp ]]; then
#   rm .docker.tmp
#fi
#lxc list -c n -f csv | awk '{print $1}' | while read name; do echo "$name" >> .docker.tmp ; done
#while read -r name; do update_container_aptitude "$name"; done < .docker.tmp
#


# update_container_aptitude () {
#    echo $1
#    lxc exec $1 -- aptitude update
#    #lxc exec $1 -- aptitude upgrade -y
#    #lxc exec $1 -- aptitude clean
#    #lxc exec $1 -- apt --purge autoremove
# }


#aptitude update && aptitude upgrade -y
#aptitude clean

#apt --purge autoremove

# --------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------

#snap refresh
#snap list --all | awk '/désactivé|disabled/{print $1, $3}' | while read snapname revision; do sudo snap remove "$snapname" --revision="$revision"; done

# --------------------------------------------------------------------------------
# 
# --------------------------------------------------------------------------------

#if [[ -f .docker.tmp ]]; then
#   rm .docker.tmp
#fi#

#lxc list -c n -f csv | awk '{print $1}' | while read name; do echo "$name" >> .docker.tmp ; done

#while read -r name; do update_container_aptitude "$name"; done < .docker.tmp


#lxc exec docker -- aptitude update
#lxc exec docker -- aptitude upgrade -y
#lxc exec docker -- aptitude autoremove
#lxc exec docker -- apt --purge autoremove


# --------------------------------------------------------------------------------
# CLEANUP 
# --------------------------------------------------------------------------------

#if [[ -f .docker.tmp ]]; then
#   rm .docker.tmp
#fi