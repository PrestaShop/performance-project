# Run pre-populated shop

```
cd shop
```

## 1/ Generate shop data

Here we use the shop-creator tool to generate fixture data. 
These data will be used during Prestashop installation process to pre-populate shop.

Fixture sizes are located in `shop-creator-config.yml`. Feel free to edit this one to get your own fixtures set !

```
git clone git@github.com:PrestaShop/prestashop-shop-creator.git
cp shop-creator-config.yml prestashop-shop-creator/app/config/
cd prestashop-shop-creator/
composer install
rm -rf generated_data/*
php app/console.php
```

This last line generates data into the directory `generated_data`

## 2/ Generate prestashop performance image

Copy generated fixture data into the shop image. Build docker image with it.

```
cd ..
rm -rf prestashop-performance/fixtures/*
mkdir -p prestashop-performance/fixtures
cp -R prestashop-shop-creator/generated_data/* prestashop-performance/fixtures/
docker build -t prestashop/prestashop-performance -f prestashop-performance/Dockerfile prestashop-performance
```

## 3/ Run shop

Run docker image with parameters, it will install fixtures and expose shop.

```
docker run \
    -e FIXTURE_FOLDER=fixtures-1000\
    -e PS_DOMAIN=localhost:8080\
    -e PS_FOLDER_ADMIN=admin1234\
    -e PS_ERASE_DB=1 \
    -e PS_CANONICAL_REDIRECT_DISABLE=1 \
    -e DB_SERVER=host.docker.internal\
    -e DB_PORT=3306\
    -e DB_NAME=prestashop_bench \
    -e DB_USER=prestashop_bench \
    -e DB_PASSWD=prestashop_bench \
    -p 8080:80 \
    prestashop/prestashop-performance
```

This will 
* run the prestashop image
* install shop
* install fixtures from `FIXTURE_FOLDER`
* locally expose the shop on port 8080
