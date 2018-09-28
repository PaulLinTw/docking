# version 0.0.1
FROM centos:latest
MAINTAINER Paul Lin "paullin@bluetechnology.com.tw"

RUN yum install -y wget
RUN yum install -y sshpass
RUN wget -q http://apache.stu.edu.tw/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz
RUN tar -zxf ./spark-2.3.1-bin-hadoop2.7.tgz -C /usr/local
WORKDIR /usr/local/spark

ADD spark-env.sh ./conf/
RUN echo "export JAVA_HOME=$JAVA_HOME" >> /usr/local/spark/conf/spark-env.sh

ADD *.sh /
ADD ge_mapping /

CMD ["bash"]
