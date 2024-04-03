#!/bin/bash
set -euo pipefail
export TAG=${TAG:-16}
PG_LIB=postgresql-server-dev-${TAG}
PG_BRANCH=REL_${TAG}_STABLE
PLUGIN_BRANCH=print-vars

apt-get --yes update
apt-get --yes upgrade
apt-get --yes install git build-essential libreadline-dev zlib1g-dev bison libkrb5-dev flex libicu-dev pkg-config $PG_LIB
for p in $(</tmp/extra_packages.lst); do apt-get install -y "$(eval echo "$p")"; done
cd "/usr/src/" ||exit 1
git clone --progress -b "$PG_BRANCH" --single-branch https://github.com/postgres/postgres.git
cd postgres ||exit 1
./configure
cd /usr/src/postgres/contrib ||exit 1
git clone -b "$PLUGIN_BRANCH" --single-branch https://github.com/ng-galien/pldebugger.git
cd pldebugger || exit 1
make clean && make USE_PGXS=1 && make USE_PGXS=1 install
rm -r /usr/src/postgres
apt-get --yes remove --purge git build-essential libreadline-dev zlib1g-dev bison libkrb5-dev flex libicu-dev pkg-config $PG_LIB
apt-get --yes autoremove
apt-get --yes clean