FROM prestashop/prestashop:1.7

COPY entrypoint.sh /tmp/

COPY --chown=www-data:www-data fixtures-10 /opt/fixtures-10
COPY --chown=www-data:www-data fixtures-1000 /opt/fixtures-1000

CMD ["/tmp/entrypoint.sh"]
