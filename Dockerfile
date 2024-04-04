ARG VERSION=16
ARG DISTRO=bookworm
ARG BASE_TAG=${VERSION}-${DISTRO}

FROM postgres:$BASE_TAG as builder
ARG VERSION=16
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt -y upgrade
# install build requirements
RUN apt-get -y install \
	make \
	build-essential \
	cmake \
	git-core \
	libreadline-dev \
	zlib1g-dev \
	bison \
	flex \
	libkrb5-dev \
	libicu-dev \
	pkg-config \
	postgresql-client-$VERSION \
	postgresql-server-dev-$VERSION 

RUN mkdir /build
COPY ["make_extensions.sh","install_package_list.sh","/tmp/"]
ADD ["extensions", "/build/"]

# compile extensions
RUN bash /tmp/make_extensions.sh


ARG BASE_TAG
FROM postgres:${BASE_TAG}
ARG VERSION
ARG INITDB=./initdb
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt -y upgrade && apt-get install -y --no-install-recommends locales tzdata
RUN localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8
#set DB LANG in RUN env if needed, eg. "-e LANG=de_DE.utf8"
ADD  $INITDB /docker-entrypoint-initdb.d

COPY --from=builder /usr/share/postgresql/$VERSION/extension /usr/share/postgresql/$VERSION/extension
COPY --from=builder /usr/lib/postgresql/$VERSION/lib /usr/lib/postgresql/$VERSION/lib
COPY ["install_package_list.sh","extra_packages.lst","/tmp/"]
RUN bash /tmp/install_package_list.sh /tmp/extra_packages.lst