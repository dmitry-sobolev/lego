#!/bin/sh

set -e

if test -z "$ACME_DNS_TYPE" -o -z "$ACME_EMAIL" -o -z "$ACME_DOMAINS"; then
    echo "Env vars must be set"
    exit 1
fi

cmd=$1

if test -z "$cmd"; then
    echo "Command must be set"
    exit 1
fi

domains=$(echo "$ACME_DOMAINS" | tr "," "\n")
domain_args=""

for domain in $domains; do
    if test -n $domain; then
        domain_args="$domain_args -d $domain"
    fi
done

if test ! -n $domain_args; then
    echo "Empty domain list"
    exit 1
fi

app="/usr/bin/lego -a -m $ACME_EMAIL $domain_args --dns $ACME_DNS_TYPE -k rsa4096 "

if test "$cmd" = "run"; then
    exec sh -c "$app run"
fi

if test "$cmd" = "renew"; then
    while test 1; do
        sh -c "$app renew --days 60" && \
        echo "[$(date)] Sleeping. Next renewal scheduled in 45 days" && \
        sleep 45d
    done
fi

echo "Command must be either run or renew"
exit 1
