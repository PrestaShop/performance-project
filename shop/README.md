# Run pre-populated shop

```
cd shop
```

## 1/ Generate shop data

Here we use the shop-creator tool to generate fixture data

```
git clone git@github.com:PrestaShop/prestashop-shop-creator.git
cp shop-creator-config.yml prestashop-shop-creator/app/config/
cd prestashop-shop-creator/
composer install
rm -rf generated_data/*
php app/console.php
```

## 2/ Generate prestashop performance image

Copy generated fixture data into the shop image

```
cd ..
rm -rf prestashop-performance/fixtures/*
mkdir -p prestashop-performance/fixtures
cp -R prestashop-shop-creator/generated_data/* prestashop-performance/fixtures/
docker build -t prestashop/prestashop-performance -f prestashop-performance/Dockerfile prestashop-performance
```

## 3/ Run shop

Run docker image with parameters

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
