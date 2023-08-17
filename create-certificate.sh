#!/bin/bash
# --------------------------------------------------------------------------------
# create-certificate --init
# create-certificate --create-root-certificate
# create-certificate --create-certificate [ server.domain.com | *.domain.com ]
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

init () {
    # write .certificate.env
    echo "j"
}

create-root-certificate () {

    # CREATE PRIVATE KEY
    openssl genrsa -out ROOTCA.key 4096

    # CREATE AND SELFSIGN ROOT CERTIFICATE
    openssl req -x509 -new -nodes -key ROOTCA.key -sha256 -days 1024 -subj "/C=BE/ST=BRUSSELS/O=Mohawkey Inc./CN=home.io" -out ROOTCA.crt

}

check-root-certificate () {

    # CHECK SELFSIGNED ROOT CERTIFICATE
    openssl x509 -in ROOTCA.crt -text -noout

}

create-certificate () {

    domain=$1
    echo "create cert $domain"

    openssl genrsa -out $domain.key 2048

    openssl req -new -sha256 -key $domain.key -subj "/CN=$domain" -out $domain.csr


}

check-certificate () {
    domain=$1
    openssl req -in $domain.csr -noout -text
}

# --------------------------------------------------------------------------------
#
# --------------------------------------------------------------------------------

if [[ $# != 0 ]]; then

   if [[ $1 == "--create-root-certificate" ]]; then
      create-root-certificate
   fi

   if [[ $1 == "--check-root-certificate" ]]; then
      check-root-certificate
   fi

   if [[ $1 == "--create-certificate" ]]; then
      create-certificate $2      
   fi

   if [[ $1 == "--check-certificate" ]]; then
      check-certificate $2      
   fi

fi
