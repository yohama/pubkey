#!/usr/bin/env bash

while getopts de: OPT
do
    case $OPT in
        d)  USE_DOCKER=1
            ;;
        e)  USE_DOCKER=1; CONTAINER_NAME=${OPTARG}
            ;;
    esac
done

shift $((OPTIND - 1))

shopt -s expand_aliases

if [ -n "${USE_DOCKER}" ]; then
    if type "docker" > /dev/null 2>&1; then
        IMG_TAG='3.0.0'
        if [ "$(arch)" = "x86_64" ]; then
            IMG_TAG='3.0.0-alpha13'
        fi
        if [ -n "${CONTAINER_NAME}" ]; then
            alias openssl='docker exec ${CONTAINER_NAME} openssl'
        else
            alias openssl='docker run --rm -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro -u $(id -u $USER):$(id -g $USER) -v $(pwd):/tmp/exec:z --workdir="/tmp/exec" shamelesscookie/openssl:${IMG_TAG}'
        fi
    fi
fi

KEY=$1
TARGET=$2

openssl aes-256-cbc -e -base64 -pbkdf2 -iter 99999 -nosalt -in ${TARGET} -pass file:${KEY}
