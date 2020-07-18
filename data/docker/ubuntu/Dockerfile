FROM ubuntu:16.04

WORKDIR /root

COPY / /root/.dotfiles

RUN .dotfiles/script/install.sh

ENTRYPOINT bash
