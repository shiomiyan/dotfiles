FROM ubuntu:latest

WORKDIR /root
RUN apt update

COPY ./src /root/.dotfiles

RUN ./src/setup.sh
