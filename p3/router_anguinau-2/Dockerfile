FROM alpine:3.20

RUN apk add --no-cache 'frr' 'tini'

COPY cnf/frr.conf /etc/frr/frr.conf
COPY docker-start.sh /usr/lib/frr/docker-start

RUN chmod +x '/usr/lib/frr/docker-start'

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/usr/lib/frr/docker-start"]
