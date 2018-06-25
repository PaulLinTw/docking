# version 0.0.1
ARG registry
FROM ${registry}/demo/base:latest
MAINTAINER Paul Lin "paullin@bluetechnology.com.tw
ADD mongodb.repo /etc/yum.repos.d/mongodb.repo
RUN yum install -y mongodb-enterprise
ADD *.sh /
ADD *.js /
CMD ["bash"]
