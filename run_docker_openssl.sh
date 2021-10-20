#!/usr/bin/env bash

while getopts n: OPT
do
    case $OPT in
        n)  CONTAINER_NAME=${OPTARG}
            ;;
    esac
done

shift $((OPTIND - 1))

IMG_TAG='3.0.0'
if [ "$(arch)" = "x86_64" ]; then
    IMG_TAG='3.0.0-alpha13'
fi

if [ -n "${CONTAINER_NAME}" ]; then
    docker run -itd --name ${CONTAINER_NAME} -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro -u $(id -u $USER):$(id -g $USER) -v $(pwd):/tmp/exec:z -v /tmp:/tmp:z --entrypoint='' --workdir="/tmp/exec" shamelesscookie/openssl:${IMG_TAG} /bin/sh
else
    docker run -itd -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro -u $(id -u $USER):$(id -g $USER) -v $(pwd):/tmp/exec:z -v /tmp:/tmp:z --entrypoint='' --workdir="/tmp/exec" shamelesscookie/openssl:${IMG_TAG} /bin/sh
fi
