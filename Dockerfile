FROM python:3.10-slim-buster

USER root

RUN apt update -y && apt install build-essential libpq-dev -y

WORKDIR /src

COPY ./analytics/requirements.txt requirements.txt

RUN pip install --upgrade pip setuptools wheel
RUN pip install -r requirements.txt
RUN pip install Werkzeug==2.2.2

COPY ./analytics .

RUN kubectl port-forward svc/postgresql-service 5433:5432 &
CMD export DB_USERNAME=myuser && export DB_PASSWORD=mypassword && export DB_HOST=127.0.0.1 && export DB_PORT=5433 && export DB_NAME=mydatabase && python app.py
