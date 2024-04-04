#!/bin/bash
set -euo pipefail
PLUGIN_BRANCH=print-vars
PG_BRANCH=REL_${VERSION}_STABLE
git clone -b $PG_BRANCH --single-branch https://github.com/postgres/postgres.git src
# Setup postgres
cd src/contrib 
# get debugger extension
git clone -b "$PLUGIN_BRANCH" --single-branch https://github.com/ng-galien/pldebugger.git