# version 0.0.1
FROM continuumio/anaconda3
MAINTAINER Jimmy "jimmybow@bluetechnology.com.tw"
RUN pip install --upgrade pip
RUN pip install pymongo
RUN pip install mydf
RUN pip install apscheduler
RUN pip install myapriori
RUN pip install redis
RUN pip install plotly
RUN pip3 install http://download.pytorch.org/whl/cpu/torch-0.3.1-cp36-cp36m-linux_x86_64.whl
RUN pip install pyclustering
RUN mkdir /analyze
WORKDIR /analyze
RUN apt install -y libgl1-mesa-glx
ADD *.py /analyze/
CMD ["bash"]
