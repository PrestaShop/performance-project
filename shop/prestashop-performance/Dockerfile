FROM prestashop/prestashop:1.7

COPY pre-install-scripts/* /tmp/pre-install-scripts/
COPY post-install-scripts/* /tmp/post-install-scripts/
COPY init-scripts/* /tmp/init-scripts/

COPY --chown=www-data:www-data fixtures /opt/fixtures
