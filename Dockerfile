FROM centos:7
RUN yum install -y epel-release
RUN yum install -y /usr/bin/spectool /usr/bin/rpmbuild /usr/bin/jq /usr/bin/curl /usr/bin/wget

