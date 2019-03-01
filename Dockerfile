# VERSION 0.2
# AUTHOR:         Sven Hartge <sven@svenhartge.de>
# DESCRIPTION:    Image with testssl.sh and testssl.sh-webfrontend
# TO_BUILD:       docker build -t testssl-web .
# TO_RUN:         docker run -d -p 5000:5000 -v /tmp/testssl/output:/testssl/output --name testssl-web testssl-web

FROM debian:stretch-slim
ENV DEBIAN_FRONTEND noninteractive

# File Author / Maintainer
MAINTAINER Sven Hartge <sven@svenhartge.de>

# Install Packages
RUN apt-get update --fix-missing -y && apt-get -y dist-upgrade && \
	apt-get --no-install-recommends -y install openssl net-tools dnsutils aha python3-pkg-resources python3-flask bsdmainutils procps nginx-light uwsgi uwsgi-plugin-python3 supervisor && \
	apt-get --purge autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt* /tmp/* /var/tmp/* /var/log/apt/* /var/log/*log

# Copy the application folder inside the container
ADD ./testssl.sh-webfrontend/ /testssl
ADD ./testssl.sh/ /testssl/testssl.sh
# Clean git cruft
RUN find /testssl -name ".git*" -exec rm -rv {} +

# Configure nginx
COPY nginx.conf /etc/nginx/
COPY testssl.conf /etc/nginx/sites-enabled/
RUN mkdir -p /var/cache/nginx/cache
RUN rm /etc/nginx/sites-enabled/default

# Configure uwsgi
COPY uwsgi.ini /etc/uwsgi/

# Configure supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Expose ports
EXPOSE 5000
# Export Volume
VOLUME /testssl/output

# Set Application base directory
WORKDIR /testssl

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

# Start
CMD ["/usr/bin/supervisord","-c","/etc/supervisor/supervisord.conf"]
