FROM alpine:3.13 as builder

RUN apk add --no-cache git make g++ boost-dev openssl-dev db-dev miniupnpc-dev zlib-dev
RUN addgroup --gid 1000 sterling
RUN adduser --disabled-password --gecos "" --home /sterling --ingroup sterling --uid 1000 sterling

USER sterling

RUN git clone https://github.com/Sterlingcoin/Sterlingcoin-1.7-Release.git /sterling/sterlingcoin
WORKDIR /sterling/sterlingcoin
RUN git checkout tags/Sterlingcoin-1.7.1.3-Release
WORKDIR /sterling/sterlingcoin/src
RUN make -f makefile.unix

FROM alpine:3.18.2

RUN apk add --no-cache boost-dev db-dev miniupnpc-dev zlib-dev bash curl
RUN addgroup --gid 1000 sterling
RUN adduser --disabled-password --gecos "" --home /sterling --ingroup sterling --uid 1000 sterling

USER sterling
COPY --from=builder /sterling /sterling
COPY ./entrypoint.sh /

RUN mkdir /sterling/.sterlingcoin
VOLUME /sterling/.sterlingcoin
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 11887/tcp
EXPOSE 11886/tcp
