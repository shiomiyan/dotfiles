FROM ubuntu:latest

WORKDIR /root
RUN apt update

COPY ./src/setup.sh .

RUN ./src/setup.sh
