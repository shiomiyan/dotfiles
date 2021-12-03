FROM ubuntu:latest

WORKDIR /root
RUN apt update

COPY ./src ./.dotfiles

RUN ./src/setup.sh
