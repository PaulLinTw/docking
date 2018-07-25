# https://github.com/elastic/elasticsearch-docker
FROM docker.elastic.co/elasticsearch/elasticsearch:6.3.0

ADD elasticsearch_*.yml /usr/share/elasticsearch/config/
ADD clear_data.sh /usr/share/elasticsearch/

# Add your elasticsearch plugins setup here
# Example: RUN elasticsearch-plugin install analysis-icu
