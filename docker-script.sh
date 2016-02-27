#!/bin/bash
set -e
echo -n "Getting updates.json ... "
curl -s https://updates.jenkins-ci.org/current/update-center.json|sed -n 2p > update-center.json
echo "done"

useradd -o -u ${1:-1000} rpm


cat update-center.json | jq -r '.plugins|keys|"\(.[])"'|while read plugin
do

./build-1.sh $plugin

done
