# version 0.0.1
FROM centos:latest
MAINTAINER Paul Lin "paullin@bluetechnology.com.tw"
RUN yum clean all && yum swap fakesystemd systemd
RUN yum -y install epel-release
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
RUN yum -y --enablerepo=remi,remi-test install redis
VOLUME /data
RUN mkdir /data/redis
ADD *.conf ./
ADD *.conf /data/redis/
CMD ["bash"]
