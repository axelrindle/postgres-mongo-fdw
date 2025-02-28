ARG POSTGRES_VERSION=15

FROM postgres:${POSTGRES_VERSION}-alpine

ARG POSTGRES_VERSION

RUN apk add --no-cache --virtual .deps \
        cmake \
        make \
        git \
        pkgconf \
        postgresql${POSTGRES_VERSION}-dev \
        openssl-dev \
        curl-dev \
        clang19 \
        llvm19 \
    && \
    git clone --depth 1 --branch REL-5_5_2 \
        https://github.com/EnterpriseDB/mongo_fdw.git \
        /usr/local/src/mongo-fdw \
    && \
    cd /usr/local/src/mongo-fdw && \
    ./autogen.sh && \
    export PKG_CONFIG_PATH=mongo-c-driver/src/libmongoc/src:mongo-c-driver/src/libbson/src && \
    make USE_PGXS=1 && \
    make USE_PGXS=1 install && \
    apk del .deps
