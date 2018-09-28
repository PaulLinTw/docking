# version 0.0.1
ARG registry
FROM ${registry}/demo/java8:latest
MAINTAINER Paul Lin "paullin@bluetechnology.com.tw"
ENV Ver "0.11.0.2"
ENV Scala "2.11"
RUN mkdir kafka
WORKDIR kafka
RUN yum install -y wget
RUN wget http://apache.stu.edu.tw/kafka/$Ver/kafka_$Scala-$Ver.tgz
RUN tar zxf kafka_$Scala-$Ver.tgz
RUN mkdir var
RUN mkdir tmp
RUN mv kafka_$Scala-$Ver $Ver
RUN rm kafka_$Scala-$Ver.tgz
VOLUME /data
RUN yum install -y which
WORKDIR /usr/local/
ENV MAVEN_VER "3.5.4"
RUN wget http://www-eu.apache.org/dist/maven/maven-3/$MAVEN_VER/binaries/apache-maven-$MAVEN_VER-bin.tar.gz
RUN tar xzf apache-maven-$MAVEN_VER-bin.tar.gz
RUN ln -s apache-maven-$MAVEN_VER  maven
ADD maven.sh /etc/profile.d/
RUN source /etc/profile.d/maven.sh
WORKDIR /kafka
ADD jmx_exporter-master.zip ./
RUN yum install -y unzip
RUN unzip jmx_exporter-master.zip
WORKDIR /kafka/jmx_exporter-master/
RUN /usr/local/maven/bin/mvn package
RUN cp jmx_prometheus_javaagent/target/jmx_prometheus_javaagent-0.2.1-SNAPSHOT.jar /kafka/
WORKDIR /kafka
ADD *.sh ./
ADD server.properties.* $Ver/config/
ADD kafka-0-8-2.yml ./
CMD ["bash"]
