# https://github.com/elastic/logstash-docker
FROM docker.elastic.co/logstash/logstash:6.3.0
ADD logstash.yml /usr/share/logstash/config/
ADD logstash.conf /usr/share/logstash/pipeline/
# Add your logstash plugins setup here
# Example: RUN logstash-plugin install logstash-filter-json
