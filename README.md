# Postgresql PL/pg Docker Images

[![Docker Pulls](https://img.shields.io/docker/pulls/tommi2day/postgresql-debugger.svg)](https://hub.docker.com/r/tommi2day/postgresql-debugger/)

This runs on top of the [official Postgres image](https://hub.docker.com/_/postgres), and compiles and configure the pldebugger and adds extra extensions: 
- pgaudit
- pg_stat_statements
- pldbgapi

### CREDITS
based on Dockerfile and scripts provided on https://github.com/ng-galien/idea-plpgdebugger/tree/233/docker

### build
see [build_all.sh](build_all.sh). This will create Images for Postgresql 14,15,16

if you like to install non-default extension packages (such as pgaudit), add them to the extra_packages.lst file similar. `${TAG}` will be replaced by the build argument. Dont forget to add your `create extension` statement to the init files (see below)


### use
Use it the same way as the official PostgreSQL image, but use this one. You may add more init scripts to the initdb folder, which will copied to /docker-entrypoint-initdb.d/

docker run -p 5514:5432 --name PG16-debug -e POSTGRES_PASSWORD=postgres -d tommi2day/postgresql-debugger:16

### see also 
- [Source Repo](https://github.com/tommi2day/postgresql-debugger)
- IntelliJ [PL/pg SQL Debugger](https://github.com/ng-galien/idea-plpgdebugger) Repo
- Intellij [Plugin Page](https://plugins.jetbrains.com/plugin/18419-postgresql-debugger)
- Original Images: [galien0xffffff/postgres-debugger docker](https://hub.docker.com/repository/docker/galien0xffffff/postgres-debugger)
