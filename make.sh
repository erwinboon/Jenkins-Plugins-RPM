#!/bin/bash
set -e
set -x
rm -f *.rpm||true
ls /var/www/repo/*.rpm|sed 's/.*\///'|sed s/.el7.centos.noarch.rpm// > p.txt
docker run -v $PWD:/work -w /work --rm jenkins-plugins-build ./docker-script.sh $1
