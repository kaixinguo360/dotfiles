FROM alpine:3

WORKDIR /root

COPY / /root/.dotfiles

RUN .dotfiles/script/install.sh

ENTRYPOINT bash
