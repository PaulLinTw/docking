# version 0.0.1
ARG registry
FROM ${registry}/demo/java8:latest
MAINTAINER Paul Lin "paullin@bluetechnology.com.tw"
ENV Ver "3.4.12"
RUN mkdir zookeeper
WORKDIR zookeeper
RUN yum install -y wget
RUN wget http://apache.stu.edu.tw/zookeeper/zookeeper-$Ver/zookeeper-$Ver.tar.gz
RUN tar zxf zookeeper-$Ver.tar.gz
RUN mkdir -p var/zookeeper
RUN mkdir -p tmp
RUN mv zookeeper-$Ver $Ver
RUN rm zookeeper-$Ver.tar.gz
ADD zookeeper.cfg $Ver/conf/
ADD zookeeper.cfg.* $Ver/conf/
ADD restart_zk.sh ./
CMD ["bash"]
