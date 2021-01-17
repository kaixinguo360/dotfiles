FROM alpine:3

WORKDIR /root

COPY / /root/.dotfiles

RUN .dotfiles/install.sh

ENTRYPOINT [ "bash", "-ic" ]

CMD [ "bash" ]
