FROM centos:7

MAINTAINER Ragnarson sp. z o.o. <biz@ragnarson.com>

COPY blackhole.sh /

CMD ["/bin/bash", "/blackhole.sh"]
