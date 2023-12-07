#!/bin/sh

name="my-ory"
img=$name:local

env=${1:-".env"}

export $(cat "$env" | xargs)

docker container remove --force $name

plop=${HYDRA_VERSION:-"latest"}
plip=${KRATOS_VERSION:-"latest"}

echo "$plop $plip"

docker build \
--build-arg="HYDRA_VERSION=$plop" \
--build-arg="KRATOS_VERSION=$plip" \
. -t $img

docker run -it \
--rm \
--name $name \
--env-file "$env" \
-p 4444:4444 \
-p 4445:4445 \
-p 4433:4433 \
-p 4434:4434 \
-p 4455:4455 \
-p 5050:5050 \
$img init