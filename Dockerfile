FROM xenolf/lego

ENV DO_AUTH_TOKEN='' \
    ACME_EMAIL='' \
    ACME_DOMAINS='' \
    ACME_DNS_TYPE='digitalocean'

WORKDIR /opt

COPY ./entrypoint.sh /opt

VOLUME ["/opt/.lego"]

ENTRYPOINT ["/bin/sh", "entrypoint.sh"]

CMD ["run"]
