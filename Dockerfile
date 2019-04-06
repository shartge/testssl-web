# VERSION 0.3
# AUTHOR:         Sven Hartge <sven@svenhartge.de>
# DESCRIPTION:    Image with testssl.sh and testssl.sh-webfrontend
# TO_BUILD:       docker build -t testssl-web .
# TO_RUN:         docker run -d -p 5000:5000 --name testssl-web testssl-web

FROM debian:stretch-slim
ENV DEBIAN_FRONTEND noninteractive

# File Author / Maintainer
LABEL maintainer="sven@svenhartge.de"

# Install Packages
RUN apt-get update --fix-missing -y && \
	apt-get --no-install-recommends -y install \
		libpam-modules-bin openssl net-tools ca-certificates dnsutils aha \
		python3-pkg-resources python3-flask bsdmainutils procps \
		nginx-light uwsgi uwsgi-plugin-python3 supervisor && \
	apt-get --purge autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /var/cache/apt* /tmp/* /var/tmp/* /var/log/apt/* /var/log/*log

# Copy the application folder inside the container
ADD ./testssl.sh-webfrontend/ /testssl
ADD ./testssl.sh/ /testssl/testssl.sh

# Configure nginx
COPY nginx.conf /etc/nginx/
COPY testssl.conf /etc/nginx/sites-enabled/default
RUN mkdir -p /var/cache/nginx/cache

# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Configure uwsgi
COPY uwsgi.ini /etc/uwsgi/

# Number of uWSGI processes and threads: amount of max. parallel running SSL checks
ENV UWSGI_PROCESSES 4
ENV UWSGI_THREADS 2

# Set the timeout for the portal site (default 300 seconds)
# The nginx uwsgi_read_timeout is derived from that by adding 10 seconds
ENV TEST_TIMEOUT 300

# Enable debugging for testssl.sh by setting this variable to a higher value
# Values from 0 (no debugging, default) to 6 (maximum debugging) are supported
ENV TESTSSLDEBUG 0

# Expose ports
EXPOSE 5000

# Set Application base directory
WORKDIR /testssl

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

# Start
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
