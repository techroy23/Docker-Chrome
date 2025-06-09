FROM ghcr.io/techroy23/docker-slimvnc:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y

RUN apt-get autoclean && apt-get autoremove -y && apt-get autopurge -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY custom-entrypoint.sh /custom-entrypoint.sh
RUN chmod +x /custom-entrypoint.sh
