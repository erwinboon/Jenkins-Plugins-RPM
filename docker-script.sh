#!/bin/bash
set -e
echo -n "Getting updates.json ... "
curl -s https://updates.jenkins-ci.org/current/update-center.json|sed -n 2p > update-center.json
echo "done"

echo -n "Parsing JSON to plugin list ... "
for plugin in $(cat update-center.json|jq -r '.plugins| to_entries[] | { "name":.key,"version":.value.version}| map(.)|@csv');
	do echo $plugin | sed 's/"//g' | awk -F',' '{print $1}' >> utd.txt;
done;
echo "done"

echo -n "sorting input lists ... "
sort -i utd.txt >> td.txt
sort -i up.txt >> p.txt
echo "done"

echo -n "Create intersection between available and new plugins ... "
if [ -f p.txt ];
	then
		wc -l p.txt td.txt
		comm -13 p.txt td.txt > runpackages.txt
	else 
		echo "No list with existing plugins found"
		exit 1
fi
echo "done"

useradd -o -u ${1:-1000} rpm


#cat update-center.json | jq -r '.plugins|keys|"\(.[])"'|while read plugin
cat runpackages.txt|while read plugin
do

./build-1.sh $plugin

done
