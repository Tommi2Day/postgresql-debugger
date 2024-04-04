#!/bin/bash
# set -euo pipefail

VERSION=16

if [ $# -eq 0 ]; then
    RUN="-d"
else
    RUN="--rm -it"
fi

NAME=PG${VERSION}-debugger
DATA=${NAME}-data
# create volume for persistent data, drop manually for cleanup
docker volume create $DATA
RUNNING=$(docker inspect --format="{{ .State.Running }}" $NAME 2> /dev/null)
if [ "$RUNNING" != "true" ]; then
    docker run -p $PGPORT:5432 --name $NAME \
        --hostname $NAME \
        -e POSTGRES_PASSWORD=$PGPASSWORD \
        -v $DATA:/var/lib/postgresql/data \
        -v $(pwd)/initdb:/docker-entrypoint-initdb.d \
        $RUN \
        tommi2day/postgresql-debugger:$VERSION $@
fi
export PGUSER=postgres
export PGPASSWORD=postgres
export PGDATABASE=postgres
export PGHOST=localhost
export PGPORT=5514
export PGSSLMODE=require
export PGSSLROOTCERT=$(pwd)/$NAME.crt

if [ "$RUN" == "-d" ]; then
    echo "Waiting for $NAME to start"
    sleep 15
    
    # retrieve tls cert
    echo "retrieve tls cert"
    docker exec $NAME cat /var/lib/postgresql/data/server.crt | cat - >$PGSSLROOTCERT
    
    # run psql
    psql

    # stop and remove container
    docker stop $NAME
    docker rm $NAME
fi