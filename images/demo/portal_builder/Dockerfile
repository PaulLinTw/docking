FROM python:3.6

COPY requirements.txt .

RUN pip install -r requirements.txt

RUN pip install pymongo

RUN pip install sklearn

RUN pip install scipy

RUN pip install apscheduler

RUN pip3 install http://download.pytorch.org/whl/cpu/torch-0.3.1-cp36-cp36m-linux_x86_64.whl

COPY gunicorn_config.py .

COPY source /app

EXPOSE 5000

CMD ["gunicorn", "--chdir", "app", "--config", "./gunicorn_config.py", "app:app"]
