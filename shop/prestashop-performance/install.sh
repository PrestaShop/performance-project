#!/bin/sh
# use it if you want to customize prestashop install
set -e

########################
# copy fixture folder if required
if [ "${FIXTURE_FOLDER}" != "" ]; then
    rm -rf /var/www/html/install/fixtures/fashion/*
	  cp -R /var/www/html/install/fixtures/"${FIXTURE_FOLDER}"/* /var/www/html/install/fixtures/fashion/
fi

########################
# fix some bugs

# "fixes" error at shop install : "Property Address->dni is empty."
sed -i -e 's/dni=""/dni="11111111"/g' /var/www/html/install/fixtures/fashion/data/address.xml

########################
# install shop
echo "Shop install in progress..."

php /var/www/html/install/index_cli.php \
        --language=en \
        --country=fr \
        --domain=$PS_DOMAIN \
        --base_uri=/ \
        --db_server=$DB_SERVER \
        --db_port=$DB_PORT \
        --db_user=$DB_USER \
        --db_name=$DB_NAME \
        --db_password=$DB_PASSWD \
        --db_create=1 \
        --firstname=Admin \
        --lastname=Admin \
        --name="shop" \
        --email="admin@prestashop.com" \
        --password="admin"

########################
# fix some bugs

# "fixes" forced host redirection : disable domain detection, disable cannical redirect
sed -i -e 's/OR su.domain_ssl =/OR su.domain LIKE "%" OR su.domain_ssl =/g' /var/www/html/classes/shop/Shop.php
mysql -h $DB_SERVER -P $DB_PORT -b $DB_NAME -u $DB_USER -p$DB_PASSWD -e "UPDATE ps_configuration SET value = '0' WHERE name = 'PS_CANONICAL_REDIRECT';"

########################
# finalize install
echo "Restore correct rights..."
chown -R www-data: /var/www/html
mv /var/www/html/admin /var/www/html/${PS_FOLDER_ADMIN}
echo "Admin root set to ${PS_DOMAIN}/${PS_FOLDER_ADMIN}"
echo "Remove install folder..."
rm -rf /var/www/html/install

echo "Docker shop ready ;)"
