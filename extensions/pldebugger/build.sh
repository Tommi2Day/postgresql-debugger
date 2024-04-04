#!/bin/bash
set -euo pipefail
cd src 
# config postgres
./configure
cd contrib/pldebugger
make clean && make USE_PGXS=1 && make USE_PGXS=1 install
