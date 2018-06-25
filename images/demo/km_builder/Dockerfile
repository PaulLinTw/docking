# version 0.0.1
ARG registry
FROM ${registry}/demo/java8:latest
MAINTAINER Paul Lin "paullin@bluetechnology.com.tw"
RUN mkdir km
WORKDIR km
RUN yum install -y unzip
RUN yum install git -y
RUN curl https://bintray.com/sbt/rpm/rpm > bintray-sbt-rpm.repo
RUN mv bintray-sbt-rpm.repo /etc/yum.repos.d/
RUN yum install sbt -y
RUN git clone https://github.com/yahoo/kafka-manager.git kmsbt
WORKDIR /km/kmsbt/
RUN sbt clean dist
WORKDIR /km/
RUN cp kmsbt/target/universal/*.zip ./
RUN unzip *.zip
RUN mv -f kafka-manager-*/ kafka-manager/
RUN rm -r kmsbt
RUN rm -f *.zip
ADD *.conf kafka-manager/conf/
ADD *.sh ./
CMD ["bash"]
