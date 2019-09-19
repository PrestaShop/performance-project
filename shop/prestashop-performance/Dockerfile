FROM prestashop/prestashop:1.7

COPY entrypoint.sh /tmp/
COPY install.sh /tmp/
COPY run.sh /tmp/
RUN rm -rf /var/www/html/install/fixtures/fashion/*

COPY --chown=www-data:www-data fixtures-10 /opt/fixtures-10
COPY --chown=www-data:www-data fixtures-1000 /opt/fixtures-1000

COPY --chown=www-data:www-data settings.inc.php /opt/

ENV PHP_CMD ""

CMD ["/tmp/entrypoint.sh"]
#CMD ["/tmp/docker_run.sh"] # docker_run.sh from prestashop image is launched by entrypoint.sh
