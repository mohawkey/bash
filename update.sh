#!/bin/bash
# --------------------------------------------------------------------------------
# update --system
# update --container <containername>
# update --container --all
# update --container
# --------------------------------------------------------------------------------

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

Update () {

   # --------------------------------------------------
   # Update
   # Update <containername>
   # --------------------------------------------------

   if [[ $# == 0 ]]; then
      echo "Update Main System"
      
      # aptitude update"
      # aptitude upgrade -y"
      # aptitude clean"
      # apt --purge autoremove"

      # snap refresh
      # snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do sudo snap remove "$snapname" --revision="$revision"; done
   fi

   if [[ $# == 1 ]]; then
      echo "update container [$1]"

      # lxc exec $1 -- aptitude update
      # lxc exec $1 -- aptitude upgrade -y
      # lxc exec $1 -- aptitude clean
      # lxc exec $1 -- apt --purge autoremove   

      # CHECK IF SNAP EXIST
      # lxc exec $1 -- /usr/bin/snap refresh
      # lxc exec $1 -- /usr/bin/snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do sudo snap remove "$snapname" --revision="$revision"; done
   fi
}

# --------------------------------------------------------------------------------
# PARAMETERS
# --------------------------------------------------------------------------------

if [[ $# != 0 ]]; then
   if [[ $1 == "--system" ]]; then
      Update
   fi
   if [[ $1 == "--container" ]]; then
      if [[ $# == 1 ]]; then
         echo "Update all containers"

         if [[ -f .docker.tmp ]]; then
            rm .docker.tmp
         fi

         lxc list -c n -f csv | awk '{print $1}' | while read name; do echo "$name" >> .docker.tmp ; done

         while read -r name; do Update "$name"; done < .docker.tmp

         if [[ -f .docker.tmp ]]; then
            rm .docker.tmp
         fi

      fi
      if [[ $# == 2 ]]; then
         Update $2
      fi
   fi
else
   echo "help"
fi

# --------------------------------------------------------------------------------
# CLEANUP 
# --------------------------------------------------------------------------------

if [[ -f .docker.tmp ]]; then
   rm .docker.tmp
fi