#!/bin/sh

docker_image_name=mycluster.icp:8500/default/example-api
docker_image_tag=v1
container_name=test_example-api

docker rm --force ${container_name}

docker run --name ${container_name} -p 13333:3333 -v `pwd`:/src -d ${docker_image_name}:${docker_image_tag}


