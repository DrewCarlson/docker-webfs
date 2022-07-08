FROM alpine AS builder

RUN apk update && apk add build-base mailcap openssl-dev
RUN wget https://www.kraxel.org/releases/webfs/webfs-1.21.tar.gz -O - | tar xzf -
RUN cd webfs-1.21 && make install && cd .. && rm -r webfs-1.21

FROM alpine

COPY --from=builder /etc/mime.types /etc/mime.types
COPY --from=builder /usr/local/bin/webfsd /usr/local/bin/webfsd

EXPOSE 80

CMD /usr/local/bin/webfsd -p 80 -d -r /srv