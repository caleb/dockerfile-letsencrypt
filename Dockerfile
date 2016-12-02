FROM debian:jessie

MAINTAINER Caleb Land <caleb@land.fm>

RUN apt-get update \
&&  apt-get install -y git-core

RUN git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt/src
RUN /opt/letsencrypt/src/letsencrypt-auto --os-packages-only \
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/* \
           /tmp/* \
           /var/tmp/*

RUN virtualenv --no-site-packages -p python2 /opt/letsencrypt/venv \
&&  /opt/letsencrypt/venv/bin/pip install \
    --upgrade setuptools \
    -e /opt/letsencrypt/src/acme \
    -e /opt/letsencrypt/src \
    -e /opt/letsencrypt/src/certbot-apache \
    -e /opt/letsencrypt/src/certbot-nginx

ENV PATH /opt/letsencrypt/venv/bin:$PATH

ENTRYPOINT ["certbot"]
