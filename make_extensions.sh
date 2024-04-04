#!/bin/bash
set -euo pipefail

DEBIAN_FRONTEND=noninteractive
PG_BIN=/usr/lib/postgresql/$VERSION/bin
export PATH="$PG_BIN:$PATH" 
export VERSION

# start test db
su - postgres -c "$PG_BIN/pg_ctl -D /var/lib/postgresql/data init "
su - postgres -c "$PG_BIN/pg_ctl -D /var/lib/postgresql/data start "

cd /build
for ext in $(ls -d *); do
	cd $ext
	echo "Building $ext"
	if [ -f "packages.txt" ]; then
		bash /tmp/install_package_list.sh packages.txt
	fi

	if [ -f "get.sh" ]; then
		bash ./get.sh
	fi
	bash ./build.sh
	cd -
done
