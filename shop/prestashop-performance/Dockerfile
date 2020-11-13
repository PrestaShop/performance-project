FROM prestashop/base:7.3-apache
LABEL maintainer="devops team <devops@prestashop.com>"

ENV PS_VERSION 1.7.7.0

# Get PrestaShop
ADD https://www.prestashop.com/download/old/prestashop_1.7.6.3.zip /tmp/prestashop.zip

# Extract
RUN mkdir -p /tmp/data-ps \
        && unzip -q /tmp/prestashop.zip -d /tmp/data-ps/ \
        && bash /tmp/ps-extractor.sh /tmp/data-ps \
        && rm /tmp/prestashop.zip

COPY pre-install-scripts/* /tmp/pre-install-scripts/
COPY post-install-scripts/* /tmp/post-install-scripts/
COPY init-scripts/* /tmp/init-scripts/

COPY --chown=www-data:www-data fixtures-10 /opt/fixtures-10
COPY --chown=www-data:www-data fixtures-1000 /opt/fixtures-1000
