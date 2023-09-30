FROM ubuntu:18.04 AS builder
COPY  --from=lncm/berkeleydb:v4.8.30.NC  /opt  /opt
ENV BDB_PREFIX="/opt/db4"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        make \
        g++ \
        autoconf \
        automake \
        libtool \
        pkg-config \
        libboost-all-dev \
        libdb++-dev \
        libevent-dev \
        libssl-dev \
        libminiupnpc-dev \
        ca-certificates \
        bsdmainutils

RUN addgroup --gid 1000 sterling && \
    adduser --disabled-password --gecos "" --home /sterling --ingroup sterling --uid 1000 sterling
USER sterling
RUN mkdir /sterling/.sterlingcoin

RUN git clone https://github.com/Sterlingcoin/Sterlingcoin-1.7-Release.git /sterling/sterlingcoin
WORKDIR /sterling/sterlingcoin
RUN git checkout tags/Sterlingcoin-1.7.1.3-Release
WORKDIR /sterling/sterlingcoin/src
RUN make -f makefile.unix

FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libboost-all-dev \
        libevent-dev \
        libssl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder sterling/sterlingcoin/src/sterlingcoind /usr/local/bin/sterlingcoind
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN addgroup --gid 1000 sterling && \
    adduser --disabled-password --gecos "" --home /sterling --ingroup sterling --uid 1000 sterling

USER sterling
WORKDIR /sterling
RUN mkdir .sterlingcoin
VOLUME /sterling/.sterlingcoin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
EXPOSE 11887/tcp
EXPOSE 11886/tcp
