# version 0.0.1
FROM centos:latest
MAINTAINER Paul Lin "paullin@bluetechnology.com.tw"

ENV HD_VER "3.1.0"
RUN yum install -y wget
RUN yum install -y sshpass
RUN wget -q http://www.us.apache.org/dist/hadoop/common/hadoop-$HD_VER/hadoop-$HD_VER.tar.gz
RUN tar -zxf ./hadoop-$HD_VER.tar.gz -C /usr/local/
RUN mv /usr/local/hadoop-$HD_VER /usr/local/hadoop
WORKDIR /usr/local/hadoop
ADD *.xml ./etc/hadoop/
ADD workers ./etc/hadoop/
ADD *.sh /
RUN yum install -y java-1.8.0-openjdk
RUN yum install -y java-1.8.0-openjdk-devel.x86_64
RUN echo "export JAVA_HOME=\"/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.181-3.b13.el7_5.x86_64/jre\" >> ~/.bashrc"
RUN source ~/.bashrc
CMD ["bash"]
