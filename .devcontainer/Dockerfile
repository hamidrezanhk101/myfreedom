FROM debian:bookworm-slim

ENV XRAY_VERSION=v26.3.27

COPY setup.sh /tmp/setup.sh
COPY start.sh /usr/local/bin/start.sh
COPY config.json /etc/xray/g2ray.json

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       bash curl wget unzip ca-certificates openssl jq \
    && rm -rf /var/lib/apt/lists/* \
    && chmod +x /tmp/setup.sh \
    && chmod +x /usr/local/bin/start.sh \
    && /tmp/setup.sh \
    && rm /tmp/setup.sh

EXPOSE 443

CMD ["/usr/local/bin/start.sh"]
