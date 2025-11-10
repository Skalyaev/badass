FROM alpine:3.20

RUN apk add --no-cache 'tini'

COPY docker-start.sh /docker-start
RUN chmod +x '/docker-start'

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/docker-start"]
