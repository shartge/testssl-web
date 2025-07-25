# syntax=docker/dockerfile:1.4
# AUTHOR:         Sven Hartge <sven@svenhartge.de>
# DESCRIPTION:    Image with testssl.sh and testssl.sh-webfrontend
# TO_BUILD:       docker buildx build -t testssl-web .
# TO_RUN:         docker run -d -p 5000:5000 --name testssl-web testssl-web

# Builder
FROM debian:bookworm-slim as builder
ENV DEBIAN_FRONTEND noninteractive

ENV WEB_BRANCH master
ENV TS_BRANCH 3.2

RUN <<BUILD1
apt-get update --fix-missing -y
apt-get --no-install-recommends -y install git ca-certificates
BUILD1

# Bust the Cache
ADD https://api.github.com/repos/shartge/testssl.sh-webfrontend/git/refs/heads/${WEB_BRANCH} testssl.sh-webfrontend-version.json
RUN git clone --depth 1 --branch=${WEB_BRANCH} https://github.com/shartge/testssl.sh-webfrontend.git /testssl
# Bust the Cache again
ADD https://api.github.com/repos/testssl/testssl.sh/git/refs/heads/${TS_BRANCH} testssl.sh-version.json
RUN git clone --depth 5 --branch=${TS_BRANCH} https://github.com/testssl/testssl.sh.git /testssl.sh
# Create Commit log for Webinterface
RUN cd /testssl.sh; git log -n 5 > /testssl.sh/testssl-changelog.txt
# Remove some cruft
RUN <<BUILD2
rm -r /testssl/.git/
rm -r /testssl.sh/.git/ /testssl.sh/bin/openssl.Darwin.x86_64 /testssl.sh/bin/openssl.FreeBSD.amd64
BUILD2

# Final Image
FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND noninteractive
LABEL maintainer="sven@svenhartge.de"
LABEL org.opencontainers.image.source="https://github.com/shartge/testssl-web"
#########################################
# Number of uWSGI processes and threads: amount of max. parallel running SSL checks
ENV UWSGI_PROCESSES 4
ENV UWSGI_THREADS 2

# Set the timeout for the portal site (default 300 seconds)
# The nginx uwsgi_read_timeout is derived from that by adding 10 seconds
ENV TEST_TIMEOUT 300

# Enable debugging for testssl.sh by setting this variable to a higher value
# Values from 0 (no debugging, default) to 6 (maximum debugging) are supported
ENV TESTSSLDEBUG 0
#########################################

# Install Packages
RUN <<FINAL1
apt-get update --fix-missing -y
apt-get --no-install-recommends -y install openssl net-tools dnsutils aha xxd python3-pkg-resources python3-flask bsdmainutils procps nginx-light uwsgi uwsgi-plugin-python3 supervisor socat
apt-get --purge autoremove -y
apt-get clean
rm -rf /var/lib/apt/lists/* /var/cache/apt* /tmp/* /var/tmp/* /var/log/apt/* /var/log/*log
FINAL1

# Configure nginx
COPY nginx.conf /etc/nginx/
COPY testssl.conf /etc/nginx/sites-enabled/default

# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure uwsgi
COPY uwsgi.ini /etc/uwsgi/

# Start-Code
COPY entrypoint.sh /

# Add Entrypoint
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]

# Add applications inside the container
copy --from=builder /testssl /testssl
copy --from=builder /testssl.sh /testssl.sh

# Expose ports
EXPOSE 5000

# Set Application base directory
WORKDIR /testssl

