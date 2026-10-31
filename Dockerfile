# Version of the caddy-dns/cloudflare plugin to compile in.
# The workflow passes the exact resolved version (e.g. v0.2.4) so that a new
# plugin release changes this layer and busts the Docker build cache.
ARG CLOUDFLARE_PLUGIN_VERSION=latest

FROM caddy:builder AS builder

ARG CLOUDFLARE_PLUGIN_VERSION

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare@${CLOUDFLARE_PLUGIN_VERSION}

FROM caddy:latest

ARG CLOUDFLARE_PLUGIN_VERSION
LABEL io.github.caddy-dns.cloudflare.version="${CLOUDFLARE_PLUGIN_VERSION}"

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
