# version 0.0.1
ARG registry
FROM ${registry}/demo/base:latest
MAINTAINER Paul Lin "paullin@bluetechnology.com.tw"
RUN mkdir /ap
ADD get-pip.py /ap/
RUN python ap/get-pip.py
RUN pip install kafka-python
RUN pip install redis
RUN pip install web.py
RUN pip install pygal
RUN pip install pygal_maps_world
RUN pip install lxml
RUN pip install pymongo
RUN pip install pandas
WORKDIR /ap
ADD *.py /ap/
ADD *.conf /ap/
CMD ["bash"]
