FROM node:12.18.4-stretch-slim
RUN apt-get update && apt-get install -y -qq --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    lxc \
    iptables && \
    apt-get clean autoclean

# Installing docker
RUN curl -sSL https://get.docker.com/ | sh

RUN apt-get clean autoclean

# Cleanup
RUN rm -rf /var/lib/apt/* /var/lib/cache/* /var/lib/log/*

RUN apt-get update && apt-get install -y python3-pip
RUN apt-get update && apt-get install -y python3-dev libffi-dev gcc libc-dev make \
  && pip3 install docker-compose

RUN apt-get update && \
  apt-get install -y \
    libgtk2.0-0 \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    xvfb

RUN mkdir /cypress-cache
ENV CYPRESS_CACHE_FOLDER=/cypress-cache

RUN npm install --unsafe-perm=true --allow-root -g cypress

RUN cypress verify

RUN cypress cache path
RUN cypress cache list

CMD service docker start && /bin/bash
