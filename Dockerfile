# VERSION 0.2
# AUTHOR:         Sven Hartge <sven@svenhartge.de>
# DESCRIPTION:    Image with testssl.sh and testssl.sh-webfrontend
# TO_BUILD:       docker build -t testssl-web .
# TO_RUN:         docker run -d -p 5000:5000 --name testssl-web testssl-web

FROM debian:stretch-slim
ENV DEBIAN_FRONTEND noninteractive

# File Author / Maintainer
MAINTAINER Sven Hartge <sven@svenhartge.de>

# Install Packages
RUN apt-get update --fix-missing -y && apt-get -y dist-upgrade && \
	apt-get --no-install-recommends -y install openssl net-tools dnsutils aha python3-pkg-resources python3-flask python3-waitress bsdmainutils procps gosu && \
	apt-get --purge autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /var/cache/apt* /tmp/* /var/tmp/*

# Copy the application folder inside the container
ADD ./testssl.sh-webfrontend/ /testssl
COPY entrypoint.sh /

# Clean git cruft
RUN find /testssl -name ".git*" -exec rm -rv {} +

# Create Log and Result folder
RUN mkdir -p /testssl/log /testssl/result/json /testssl/result/html

# Expose ports
EXPOSE 5000

# Start
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
