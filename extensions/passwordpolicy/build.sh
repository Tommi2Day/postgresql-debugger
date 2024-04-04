#!/bin/bash

cp Makefile* src/
cd src
make clean && make USE_PGXS=1 && make USE_PGXS=1 install && make installcheck