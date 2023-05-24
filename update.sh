#!/bin/bash
# --------------------------------------------------------------------------------
# 
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

update () {

   # --------------------------------------------------
   # update
   # update <containername>
   # --------------------------------------------------

   if [[ $# == 0 ]]; then
      echo "Update Main System"
      
      aptitude update
      aptitude upgrade -y
      aptitude clean
      apt --purge autoremove

      snap refresh
      snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do sudo snap remove "$snapname" --revision="$revision"; done
   fi

   if [[ $# == 1 ]]; then
      echo "update container [$1]"

      lxc exec $1 -- aptitude update
      lxc exec $1 -- aptitude upgrade -y
      lxc exec $1 -- aptitude clean
      lxc exec $1 -- apt --purge autoremove   

      CHECK IF SNAP EXIST
      lxc exec $1 -- /usr/bin/snap refresh
      lxc exec $1 -- /usr/bin/snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do sudo snap remove "$snapname" --revision="$revision"; done
   fi
}

help () {
   echo " update <options>"
   echo ""
   echo " options: --system"
   echo ""
   echo "          --container"
   echo "          --container <containername>"
   echo ""
   echo "          --container <containername> --upgradeportainer"
   echo "          --container <containername> --upgradedocks"
   echo ""
}

# --------------------------------------------------------------------------------
# PARAMETERS
# --------------------------------------------------------------------------------

if [[ $# != 0 ]]; then
   if [[ $1 == "--system" ]]; then
      update
   fi
   if [[ $1 == "--container" ]]; then

      if [[ $# == 1 ]]; then
         echo "Update all containers"

         if [[ -f .docker.tmp ]]; then
            rm .docker.tmp
         fi

         lxc list -c n -f csv | awk '{print $1}' | while read name; do echo "$name" >> .docker.tmp ; done

         while read -r name; do update "$name"; done < .docker.tmp

         if [[ -f .docker.tmp ]]; then
            rm .docker.tmp
         fi

      fi

      if [[ $# == 2 ]]; then
         update $2
      fi

      if [[ $# == 3 ]]; then
         if [[ $3 == "--upgradeportainer" ]]; then

            echo "upgrade portainer in docker [$2]"

            lxc exec $2 -- docker stop portainer
            lxc exec $2 -- docker rm portainer
            lxc exec $2 -- docker pull portainer/portainer-ce:latest
            lxc exec $2 -- docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer:/data portainer/portainer-ce:latest

         fi
         if [[ $3 == "--upgradedocks" ]]; then  

            echo "upgrade all docks"

            lxc exec $2 -- docker pull containrrr/watchtower
            lxc exec $2 -- docker run --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --run-once --cleanup
         fi
      fi

   fi
else
   help
fi

# --------------------------------------------------------------------------------
# CLEANUP 
# --------------------------------------------------------------------------------

if [[ -f .docker.tmp ]]; then
   rm .docker.tmp
fi