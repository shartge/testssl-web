############################################################
# Dockerfile to build testssl.sh WebFrontend
############################################################

FROM debian:stretch
ENV DEBIAN_FRONTEND noninteractive

# File Author / Maintainer
MAINTAINER Sven Hartge

# Install Packages
RUN apt-get update --fix-missing -y && apt-get -y dist-upgrade && \
	apt-get --no-install-recommends -y install openssl net-tools dnsutils aha python3-setuptools python3-flask bsdmainutils procps && \
	apt-get --purge autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy the application folder inside the container
ADD ./testssl.sh-webfrontend/ /testssl

# Clean git cruft
RUN find /testssl -name ".git*" -exec rm -rv {} +

# Create Log and  Result folder
RUN mkdir -p /testssl/log /testssl/result/json /testssl/result/html

# Expose ports
EXPOSE 5000

# Set the default directory where CMD will execute
WORKDIR /testssl

# Set the default command to execute    
# CMD python3 SSLTestPortal.py
ENV FLASK_ENV=development 
ENV FLASK_APP=SSLTestPortal.py 
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
CMD flask run
