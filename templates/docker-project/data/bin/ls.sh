#!/bin/sh

. $(dirname $0)/lib.sh

ls -d ./deploy*.env 2>/dev/null \
    | sed "s/^/-\n/g" \
    | xargs -l1 ./bin/info.sh \
    | sed -nE "s#DEPLOY_SUBDOMAIN=\"([^\"]*)\"#https://\1.$DEPLOY_HOSTNAME#p" \
    | sort -u \
    | xargs -l1 -i sh -c 'curl -Lsf {} >/dev/null && echo "{}"'

