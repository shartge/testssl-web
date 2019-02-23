############################################################
# Dockerfile to build testssl.sh WebFrontend
############################################################

FROM debian:stretch-slim
ENV DEBIAN_FRONTEND noninteractive

USER root

# File Author / Maintainer
MAINTAINER Sven Hartge

# Minimize the image
COPY 00dpkg-minimize-debian /etc/dpkg/dpkg.cfg.d/

# Install Packages
RUN apt-get update --fix-missing -y && apt-get -y dist-upgrade && \
	apt-get --no-install-recommends -y install openssl net-tools dnsutils aha python3-pkg-resources python3-flask python3-waitress bsdmainutils procps gosu && \
	apt-get --purge autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy the application folder inside the container
ADD ./testssl.sh-webfrontend/ /testssl
COPY entrypoint.sh /

# Clean git cruft
RUN find /testssl -name ".git*" -exec rm -rv {} +

# Create Log and Result folder
RUN mkdir -p /testssl/log /testssl/result/json /testssl/result/html

# Expose ports
EXPOSE 5000

# Set the default directory where CMD will execute
WORKDIR /testssl

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
