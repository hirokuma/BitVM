#!/bin/bash

pid=`docker ps | grep blockstream/esplora | awk '{print $1}'`
generate_command="/srv/explorer/bitcoin/bin/bitcoin-cli -conf=/data/.bitcoin.conf -datadir=/data/bitcoin $@"

docker exec $pid /bin/bash -c "$generate_command"
