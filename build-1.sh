#!/bin/bash
set -e

echo Building $1
plugin=$1

name=$(cat update-center.json|jq -r ".plugins[\"$plugin\"].name")
title=$(cat update-center.json|jq -r ".plugins[\"$plugin\"].title")
version=$(cat update-center.json|jq -r ".plugins[\"$plugin\"].version")
wiki=$(cat update-center.json|jq -r ".plugins[\"$plugin\"].wiki")
url=$(cat update-center.json|jq -r ".plugins[\"$plugin\"].url")
excerpt=$(cat update-center.json|jq -r ".plugins[\"$plugin\"].excerpt")
core=$(cat update-center.json|jq -r ".plugins[\"$plugin\"].requiredCore")
filename=${url//*\/}
REL=2
tmp=$(mktemp -d)

if grep -qx "jenkins-plugin-$name-${version//-/_}-$REL" p.txt
then
    echo Skip jenkins-plugin-$name-$REL
    exit 0
fi

if echo ${filename} | grep hpi$
then
    jpiname=$(basename ${filename} .hpi).jpi
    hpiname=$(basename ${filename})
fi
if echo ${filename} | grep jpi$
then
    hpiname=$(basename ${filename} .jpi).hpi
    jpiname=$(basename ${filename})
fi
(
cat <<  END
%define __os_install_post %{nil}
%define debug_package %{nil}
END
echo "Name:           jenkins-plugin-$name"
echo "Summary:        Jenkins Plugin $title"
echo "BuildArch: noarch"
echo "AutoReqProv: no"
echo "Version:        ${version//-/_}"
echo "Release:        $REL%{?dist}"
echo "Vendor:         %{?_host_vendor}"
echo "License:        https://wiki.jenkins-ci.org/display/JENKINS/Governance+Document#GovernanceDocument-License"
echo "Group:          Jenkins"
echo "URL:            $wiki"
echo "Source0:        $url"
echo "Provides:       jenkins-plugin($name) = $version"
echo "Requires:       jenkins >= $core"

cat update-center.json | jq -r ".plugins[\"$plugin\"].dependencies|\"\(.[])\""|while read l; do echo $l | jq -r "\"Requires:       jenkins-plugin(\"+.name+\") >= \"+.version";done

echo "%description"
echo "$excerpt"
echo "%build"
echo "mkdir -p \$RPM_BUILD_ROOT/var/lib/jenkins/plugins"
echo "cp \$RPM_SOURCE_DIR/$filename \$RPM_BUILD_ROOT/var/lib/jenkins/plugins/$jpiname"
echo "touch \$RPM_BUILD_ROOT/var/lib/jenkins/plugins/$hpiname"
echo "touch \$RPM_BUILD_ROOT/var/lib/jenkins/plugins/${jpiname}.pinned"
echo "%files"
echo "%ghost /var/lib/jenkins/plugins/$hpiname"
echo "%attr(644,jenkins,jenkins) /var/lib/jenkins/plugins/$jpiname"
echo "%attr(444,jenkins,jenkins) /var/lib/jenkins/plugins/${jpiname}.pinned"

) > jenkins-plugin-${plugin}.spec


su rpm -c "mkdir -p /tmp/d"
su rpm -c "spectool -C /tmp/d -g $PWD/jenkins-plugin-${plugin}.spec" > /dev/null
su rpm -c "rm -f /home/rpm/rpmbuild/RPMS/*/* || true"
su rpm -c "rpmbuild -bb --define '_sourcedir /tmp/d' jenkins-plugin-${plugin}.spec"
su rpm -c "cp /home/rpm/rpmbuild/RPMS/*/* /work"
su rpm -c "rm /home/rpm/rpmbuild/RPMS/*/*"
