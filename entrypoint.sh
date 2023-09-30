#!/bin/bash
set -meuo pipefail

STERLINGCOIN_DIR=/sterling/.sterlingcoin/
STERLINGCOIN_CONF=/sterling/.sterlingcoin/sterlingcoin.conf

if [ -z "${STERLINGCOIN_RPCPASSWORD:-}" ]; then
  # Provide a random password.
  STERLINGCOIN_RPCPASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 ; echo '')
fi

if [ ! -e "${STERLINGCOIN_CONF}" ]; then
  tee -a >${STERLINGCOIN_CONF} <<EOF
server=1
rpcuser=${STERLINGCOIN_RPCUSER:-sterlingrpc}
rpcpassword=${STERLINGCOIN_RPCPASSWORD}
rpcclienttimeout=${STERLINGCOIN_RPCCLIENTTIMEOUT:-30}
EOF
echo "Created new configuration at ${STERLINGCOIN_CONF}"
fi

if [ $# -eq 0 ]; then
  /usr/local/bin/sterlingcoind -rpcbind=:11886 -rpcallowip=* -printtoconsole=1
else
  exec "$@"
fi
