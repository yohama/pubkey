#!/usr/bin/env bash

shopt -s expand_aliases

if type "docker" > /dev/null 2>&1; then
    IMG_TAG='3.0.0'
    if [ "$(arch)" = "x86_64" ]; then
        IMG_TAG='3.0.0-alpha13'
    fi
    alias openssl='docker run --rm -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro -u $(id -u $USER):$(id -g $USER) -v /tmp:/tmp -v $(pwd):/tmp/exec:z --workdir="/tmp/exec" shamelesscookie/openssl:${IMG_TAG}'
fi

TMP_FILE=$(mktemp)
KEY=$1
SIGNATURE=$2

cat - | openssl dgst -sha256 | sed -e 's/.* //' > ${TMP_FILE}
openssl pkeyutl -verify -pubin -inkey ${KEY} -rawin -in ${TMP_FILE} -sigfile ${SIGNATURE}
rm ${TMP_FILE}
