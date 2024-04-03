# define base image
ARG TAG=16
ARG BASE_IMAGE=${TAG}
FROM postgres:${BASE_IMAGE}

# set major version again for scripts
ARG TAG=16

# build
COPY ["compile.sh","extra_packages.lst","/tmp/"]
RUN /tmp/compile.sh

# copy init files
COPY ["initdb/*", "/docker-entrypoint-initdb.d/"]
RUN chmod a+r /docker-entrypoint-initdb.d/*