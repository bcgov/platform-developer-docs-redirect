FROM caddy:2.10.0-alpine@sha256:e2e3a089760c453bc51c4e718342bd7032d6714f15b437db7121bfc2de2654a6

# Needed to use Caddy's logging format transform
RUN caddy add-package github.com/caddyserver/transform-encoder   

# From https://docs.redhat.com/en/documentation/openshift_container_platform/4.16/html/images/creating-images#use-uid_create-images
RUN mkdir -p /data/caddy /config/caddy && \
    chgrp -R 0 /data /config && \
    chmod -R g=u /data /config

WORKDIR /srv

COPY Caddyfile /etc/caddy/Caddyfile
RUN caddy fmt /etc/caddy/Caddyfile

COPY error.html /srv/error.html

EXPOSE 2015 2016

USER 1001

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=5 CMD wget -qO- http://localhost:2016/health || exit 1

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
