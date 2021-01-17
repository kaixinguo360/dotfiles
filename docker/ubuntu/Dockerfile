FROM ubuntu:16.04

WORKDIR /root

COPY / /root/.dotfiles

RUN .dotfiles/install.sh

ENTRYPOINT [ "bash", "-ic" ]

CMD [ "bash" ]
