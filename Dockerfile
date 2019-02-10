FROM alpine:3.9

RUN apk --no-cache add --virtual .build-dependencies make g++ linux-headers patch wget ca-certificates libnl3-dev glib-dev \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && wget -qO- https://github.com/navossoc/ndppd/archive/master.zip \
    && unzip master.zip \
    && cd /usr/src/ndppd-master \
    && make && make install \
    && cd / && rm -rf /usr/src/ndppd-master \
    && apk del .build-dependencies

RUN apk -U upgrade \
    && apk add --update --no-cache openssl util-linux strongswan bash iptables ip6tables \
    && rm -rf /var/cache/apk/* \
    && rm -f /etc/ipsec.secrets

ADD ./etc/* /etc/
ADD ./bin/* /usr/bin/

VOLUME /etc
VOLUME /config

# http://blogs.technet.com/b/rrasblog/archive/2006/06/14/which-ports-to-unblock-for-vpn-traffic-to-pass-through.aspx
EXPOSE 500/udp 4500/udp

CMD /usr/bin/start-vpn
