#!/bin/bash

docker build --platform linux/amd64 --build-arg PROGRAM=$1 -t $1 .

docker run --rm --platform linux/amd64 $1

docker rmi $1