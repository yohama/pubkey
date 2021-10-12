#!/usr/bin/env bash

shopt -s expand_aliases

if type "docker" > /dev/null 2>&1; then
    IMG_TAG='3.0.0'
    if [ "$(arch)" = "x86_64" ]; then
        IMG_TAG='3.0.0-alpha13'
    fi
    alias openssl='docker run --rm -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro -u $(id -u $USER):$(id -g $USER) -v $(pwd):/tmp/exec:z --workdir="/tmp/exec" shamelesscookie/openssl:${IMG_TAG}'
fi

OWNKEYS=$1
PUBKEY=$2

openssl pkeyutl -derive -inkey ${OWNKEYS} -peerkey ${PUBKEY} | sha256sum -b - | sed -e 's/ .*//g' | base64
