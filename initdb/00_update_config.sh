#!/bin/bash

PGDATA=${PGDATA:-/var/lib/postgresql/data}
sed -i "s/#shared_preload_libraries = .*/shared_preload_libraries = 'pgaudit,pg_stat_statements,plugin_debugger,passwordpolicy'/g" $PGDATA/postgresql.conf

# passwordpolicy settings
echo "
p_policy.min_password_len = 12       # Set minimum Password length
p_policy.min_special_chars = 1      # Set minimum number of special chracters
p_policy.min_numbers = 1            # Set minimum number of numeric characters
p_policy.min_uppercase_letter = 1   # Set minimum number of upper case letters
p_policy.min_lowercase_letter = 1   # Set minimum number of lower casae letters
" >>$PGDATA/postgresql.conf

#enable ssl
echo "hostssl   all     all     0.0.0.0/0   md5" >>$PGDATA/pg_hba.conf
echo "ssl = on
ssl_ca_file = ''
ssl_cert_file = 'server.crt'
ssl_crl_file = ''
ssl_key_file = 'server.key'
ssl_ciphers = 'HIGH:MEDIUM:+3DES:!aNULL' # allowed SSL ciphers
ssl_prefer_server_ciphers = on
ssl_ecdh_curve = 'prime256v1'
ssl_min_protocol_version = 'TLSv1.2'
ssl_max_protocol_version = ''
" >>$PGDATA/postgresql.conf

# create tls cert if needed
if [ ! -r $PGDATA/server.key ]; then
        openssl req -new -newkey rsa:4096 -x509 -days 365 -nodes -out $PGDATA/server.crt -keyout $PGDATA/server.key -subj "/C=DE/ST=NRW/L=Cologne/O=TOMMI2DAY/CN=$HOSTNAME"
fi

# restart postgresql
pg_ctl -w restart -D $PGDATA