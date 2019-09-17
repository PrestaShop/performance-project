FROM prestashop/prestashop:1.7

COPY entrypoint.sh /tmp/
COPY install.sh /tmp/
COPY run.sh /tmp/
COPY --chown=www-data:www-data fixtures-10 /var/www/html/install/fixtures/fixtures-10
COPY --chown=www-data:www-data fixtures-1000 /var/www/html/install/fixtures/fixtures-1000
COPY --chown=www-data:www-data settings.inc.php /var/www/html/config/

ENV DB_SERVER ""
ENV DB_PORT "3306"
ENV DB_NAME ""
ENV DB_USER ""
ENV DB_PASSWD ""
#ENV PS_INSTALL_AUTO "1"
ENV PS_DOMAIN ""
ENV PS_FOLDER_ADMIN ""
ENV PHP_CMD ""

CMD ["/tmp/entrypoint.sh"]
#CMD ["/tmp/docker_run.sh"] # docker_run.sh from prestashop image is launched by entrypoint.sh
