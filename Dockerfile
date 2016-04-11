FROM alpine:3.3

MAINTAINER Ragnarson sp. z o.o. <biz@ragnarson.com>

RUN apk add --update bash sed grep && rm -rf /var/cache/apk/*

COPY blackhole.sh /

CMD ["/bin/bash", "/blackhole.sh"]
