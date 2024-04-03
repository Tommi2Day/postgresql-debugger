#!/bin/bash
set -euo pipefail
PUSH=${1:-""}
PG_IMAGE=postgresql-debugger
DISTRO=bookworm
DOCKER_USER=${DOCKER_USER:-tommi2day}
VERSIONS="14 15 16"
for PG_VERSION in $VERSIONS; do
    echo "Building $PG_IMAGE:$PG_VERSION"
    docker build --build-arg "TAG=$PG_VERSION" --build-arg "BASE_IMAGE=${PG_VERSION}-${DISTRO}" -t "$DOCKER_USER/$PG_IMAGE:$PG_VERSION" .
done
docker tag "$DOCKER_USER/$PG_IMAGE:$PG_VERSION" "$DOCKER_USER/$PG_IMAGE:latest"
if [ "$PUSH" != "" ]; then
    docker login
    for PG_VERSION in $VERSIONS latest; do
        echo "Pushing $PG_IMAGE:$PG_VERSION"
        docker push "$DOCKER_USER/$PG_IMAGE:$PG_VERSION"
    done
fi