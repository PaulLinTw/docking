FROM       golang:alpine as builder
RUN apk --no-cache add curl git make perl
RUN curl -s https://glide.sh/get | sh
RUN mkdir -p /go/src/github.com/prometheus/
RUN git clone https://github.com/prometheus/graphite_exporter.git
RUN mv graphite_exporter /go/src/github.com/prometheus/
RUN cd /go/src/github.com/prometheus/graphite_exporter && make

FROM       alpine:3.4
MAINTAINER Paul Lin <paullin@bluetechnology.com.tw>
RUN apk add --update ca-certificates
COPY --from=builder /go/src/github.com/prometheus/graphite_exporter/graphite_exporter /usr/local/bin/graphite_exporter
COPY ge_mapping .
EXPOSE     9108
EXPOSE     9109

CMD [ "/bin/sh" ]
