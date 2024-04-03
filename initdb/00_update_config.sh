#!/bin/bash

PGDATA=${PGDATA:-/var/lib/postgresql/data}
sed -i "s/#shared_preload_libraries = ''/shared_preload_libraries = 'pgaudit,pg_stat_statements,plugin_debugger'/g" $PGDATA/postgresql.conf

#create tls cert if needed
if [ ! -r $PGDATA/server.key ]; then
        openssl req -new -newkey rsa:4096 -x509 -days 365 -nodes -out $PGDATA/server.crt -keyout $PGDATA/server.key -subj "/C=DE/ST=NRW/L=Cologne/O=DEVK/CN=$HOSTNAME"
fi

#restart postgresql
pg_ctl -w restart -D $PGDATA