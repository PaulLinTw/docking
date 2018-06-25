# version 0.0.1
ARG registry
FROM ${registry}/demo/base:latest
MAINTAINER Paul Lin "paullin@bluetechnology.com.tw"
RUN yum install -y wget psmisc
RUN wget -O ./prometheus-1.4.1.linux-amd64.tar.gz https://github.com/prometheus/prometheus/releases/download/v1.4.1/prometheus-1.4.1.linux-amd64.tar.gz
RUN useradd prometheus
RUN mkdir /opt/prometheus
RUN chown prometheus:prometheus /opt/prometheus/
RUN tar -xvf ./prometheus-1.4.1.linux-amd64.tar.gz -C /opt/prometheus --strip=1
ADD prometheus.service /etc/systemd/system/
ADD prometheus.yml /opt/prometheus
#RUN systemctl enable prometheus
WORKDIR /opt/prometheus
CMD ["bash"]
