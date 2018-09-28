# version 0.0.1
ARG registry
FROM ${registry}/demo/base:latest
MAINTAINER Paul Lin "paullin@bluetechnology.com.tw"

RUN yum install -y wget
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk8-downloads-2133151.html; oraclelicense=accept-securebackup-cookie;" "http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jre-8u172-linux-x64.rpm"
RUN rpm -ivh jre-*.rpm

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.1.rpm
RUN rpm --install elasticsearch-6.3.1.rpm

ADD run_elasticsearch.sh .
RUN sysctl -w vm.max_map_count=262144

CMD ["bash"]
