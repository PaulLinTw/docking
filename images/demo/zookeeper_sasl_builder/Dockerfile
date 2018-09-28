# version 0.0.1
ARG registry
FROM ${registry}/demo/zookeeper:latest
MAINTAINER Paul Lin "paullin@bluetechnology.com.tw"
RUN yum -y install ntp
RUN yum -y install krb5-libs krb5-workstation pam_krb5
ADD restart_zk_*.sh ./
CMD ["bash"]
