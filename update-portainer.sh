#!/bin/bash

# --------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# --------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------

lxc exec docker -- docker stop portainer
lxc exec docker -- docker rm portainer
lxc exec docker -- docker pull portainer/portainer-ce:latest
lxc exec docker -- docker run -d -p 8000:8000 -p 9443:9443 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer:/data portainer/portainer-ce:latest
