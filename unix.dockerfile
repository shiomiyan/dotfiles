FROM ubuntu:latest

WORKDIR /root
RUN apt update

COPY ./src /root/.dotfiles
