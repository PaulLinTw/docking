# version 0.0.1
ARG registry
FROM ${registry}/demo/kafka:latest
MAINTAINER Paul Lin "paullin@bluetechnology.com.tw"
WORKDIR /kafka
RUN yum -y install ntp
RUN yum -y install krb5-libs krb5-workstation pam_krb5
ADD restart_*.sh ./
CMD ["bash"]
