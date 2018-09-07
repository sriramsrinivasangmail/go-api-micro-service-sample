#!/bin/sh

set -e 

scriptdir=`dirname $0`
. ${scriptdir}/build_utils.sh

swagger validate ./api.yaml
swagger generate server  --spec ./api.yaml --name example-api

dep ensure
OS=$1


if [ "$1" = "linux" ];
then
do_go_build cmd/example-server linux 
else
do_go_build cmd/example-server
fi
