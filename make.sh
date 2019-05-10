#!/bin/bash
set -e
set -x
rm -f *.rpm||true
rm utd.txt up.txt p.txt td.txt -f
PACKAGEDIR=/srv/www/yumrepo

echo -n "Compiling available jenkins rpm's in to list"
for file in $PACKAGEDIR/*.rpm; do rpm -qp --qf "%{NAME}\n" $file|sed s/jenkins-plugin-// >> up.txt; done

docker run -v $PWD:/work -w /work --rm jenkins-plugins-build ./docker-script.sh $1
