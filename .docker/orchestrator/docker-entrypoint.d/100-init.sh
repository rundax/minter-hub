
#!/usr/bin/env bash

set -e
set -u
set -o pipefail


if [ ! -d /home/mhub/.mhub/config  ]; then
    mkdir -v -p /home/mhub/.mhub/config
fi


if [ ! -f /home/mhub/.mhub/config/genesis.json  ]; then
    echo "Install genesis"
    wget ${MHUB_GENESIS_LINK} -O /home/mhub/.mhub/config/genesis.json
fi
