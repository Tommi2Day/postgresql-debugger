#!/bin/bash
set -euo pipefail
LIST=${1:-packages.txt}
export VERSION
if [ ! -r "$LIST" ]; then
	echo "$LIST not readable"
	exit 1
fi
for p in $(grep -v "^#" "$LIST" 2>/dev/null); do
	if [ -z "$p" ]; then
		continue
	fi
	echo "Installing $p"
	apt-get install -y "$(eval echo "$p")"
done



