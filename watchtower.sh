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

lxc exec docker -- docker pull containrrr/watchtower
lxc exec docker -- docker run --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --run-once --cleanu
p